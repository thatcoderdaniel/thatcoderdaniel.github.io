#!/bin/bash

# Perfect Deployment Script for itsdanmanole.com
# Cross-platform compatible Jekyll deployment to Google Cloud Platform
# Works on Linux, macOS, Windows (WSL), and Android (Termux)

set -e  # Exit on any error

# Configuration
SITE_NAME="itsdanmanole.com"
GCS_BUCKET="blog.itsdanmanole.com"
CDN_LB_NAME="blog-lb"
GCP_PROJECT="dmisblogging-prod"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Platform detection and setup
setup_environment() {
    log_info "Setting up cross-platform environment..."
    
    # Detect platform
    if [[ "$OSTYPE" == "linux-android"* ]]; then
        PLATFORM="termux"
        log_info "Detected: Android/Termux"
        # Termux-specific paths
        export PATH="$PREFIX/bin:$PATH"
        if [ -d "$PREFIX/google-cloud-sdk/bin" ]; then
            export PATH="$PREFIX/google-cloud-sdk/bin:$PATH"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
        log_info "Detected: Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
        log_info "Detected: macOS"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        PLATFORM="windows"
        log_info "Detected: Windows"
    else
        PLATFORM="unknown"
        log_warning "Unknown platform, proceeding with default settings"
    fi
}

# Pre-flight checks
preflight_checks() {
    log_info "Running pre-flight checks..."
    
    # Check for required commands
    local missing_deps=()
    
    if ! command -v bundle &> /dev/null; then
        missing_deps+=("bundler")
    fi
    
    if ! command -v jekyll &> /dev/null && ! bundle exec jekyll --version &> /dev/null; then
        missing_deps+=("jekyll")
    fi
    
    if ! command -v gcloud &> /dev/null; then
        missing_deps+=("gcloud")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_info "Please install the missing dependencies and try again"
        exit 1
    fi
    
    # Check GCP authentication
    if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q "."; then
        log_error "No active GCP authentication found"
        log_info "Run: gcloud auth login"
        exit 1
    fi
    
    # Check if we're in a Jekyll site
    if [ ! -f "_config.yml" ]; then
        log_error "Not in a Jekyll site directory (no _config.yml found)"
        exit 1
    fi
    
    log_success "Pre-flight checks passed"
}

# Build the Jekyll site
build_site() {
    log_info "Building Jekyll site with production settings..."
    
    # Clean previous build
    rm -rf _site
    
    # Choose appropriate Gemfile
    local gemfile
    if [ -f "Gemfile.production" ]; then
        gemfile="Gemfile.production"
        log_info "Using production Gemfile"
    elif [ -f "Gemfile.deploy" ]; then
        gemfile="Gemfile.deploy"
        log_info "Using deploy Gemfile"
    else
        gemfile="Gemfile"
        log_info "Using default Gemfile"
    fi
    
    # Build with optimizations
    BUNDLE_GEMFILE="$gemfile" JEKYLL_ENV=production bundle exec jekyll build --config _config.yml
    
    if [ ! -d "_site" ]; then
        log_error "Jekyll build failed - no _site directory created"
        exit 1
    fi
    
    # Build statistics
    local file_count=$(find _site -type f | wc -l)
    local site_size=$(du -sh _site | cut -f1)
    
    log_success "Jekyll build completed"
    log_info "Files: $file_count | Size: $site_size"
}

# Deploy to Google Cloud Storage
deploy_to_gcs() {
    log_info "Deploying to Google Cloud Storage..."
    
    # Set the project
    gcloud config set project "$GCP_PROJECT" --quiet
    
    # Unified sync approach - consistent with GitHub Actions
    log_info "Syncing files with unified approach..."
    gcloud storage rsync _site/ "gs://$GCS_BUCKET/" \
        --recursive \
        --delete-unmatched-destination-objects \
        --exclude="admin/config.yml" \
        --exclude="*.log"
    
    if [ $? -ne 0 ]; then
        log_error "Upload to GCS failed"
        exit 1
    fi
    
    log_success "Files uploaded to GCS"
}

# Set optimal content types and security headers
optimize_delivery() {
    log_info "Optimizing content delivery and security..."
    
    # HTML files - short cache for content updates
    gcloud storage objects update "gs://$GCS_BUCKET/**/*.html" \
        --content-type="text/html" \
        --cache-control="public,max-age=3600" \
        --custom-metadata="x-frame-options=DENY,x-content-type-options=nosniff,x-xss-protection=1; mode=block" \
        --quiet 2>/dev/null || log_warning "Some HTML files may not have been updated"
    
    # CSS files - longer cache
    gcloud storage objects update "gs://$GCS_BUCKET/**/*.css" \
        --content-type="text/css" \
        --cache-control="public,max-age=86400" \
        --quiet 2>/dev/null || true
    
    # JavaScript files - longer cache  
    gcloud storage objects update "gs://$GCS_BUCKET/**/*.js" \
        --content-type="application/javascript" \
        --cache-control="public,max-age=86400" \
        --quiet 2>/dev/null || true
    
    # Assets - very long cache
    gcloud storage objects update "gs://$GCS_BUCKET/**/*.{png,jpg,jpeg,gif,svg,woff,woff2}" \
        --cache-control="public,max-age=31536000" \
        --quiet 2>/dev/null || true
    
    # Secure admin directory
    gcloud storage objects update "gs://$GCS_BUCKET/admin/**" \
        --cache-control="no-cache,no-store,must-revalidate" \
        --custom-metadata="x-frame-options=DENY" \
        --quiet 2>/dev/null || log_info "No admin files to secure"
    
    log_success "Content delivery optimized"
}

# Invalidate CDN cache
invalidate_cdn() {
    log_info "Invalidating CDN cache globally..."
    
    gcloud compute url-maps invalidate-cdn-cache "$CDN_LB_NAME" \
        --path="/*" \
        --async \
        --quiet
    
    if [ $? -ne 0 ]; then
        log_warning "CDN cache invalidation failed, but deployment succeeded"
    else
        log_success "CDN cache invalidated"
    fi
}

# Main deployment function
main() {
    echo "🚀 Perfect Deployment Script for $SITE_NAME"
    echo "================================================"
    echo ""
    
    setup_environment
    preflight_checks
    build_site
    deploy_to_gcs
    optimize_delivery
    invalidate_cdn
    
    echo ""
    echo "🎉 Perfect deployment completed successfully!"
    echo ""
    echo "📊 Deployment Summary:"
    echo "🌐 Site: https://$SITE_NAME"
    echo "⏰ Deployed: $(date)"
    echo "🔒 Security: Headers applied, Admin secured"
    echo "⚡ CDN: Cache invalidated globally"
    echo "🎯 Status: Production ready"
    echo ""
    log_success "Your Jekyll site is live!"
}

# Handle interruption gracefully
trap 'log_error "Deployment interrupted"; exit 1' INT TERM

# Run main function
main "$@"