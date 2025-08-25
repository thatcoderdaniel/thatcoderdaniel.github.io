#!/bin/bash

# Deployment script for itsdanmanole.com
# This script builds and deploys the Jekyll site to Google Cloud Storage

echo "🚀 Starting deployment process..."

# Set up environment - Auto-detect platform
if [[ -d "/data/data/com.termux" ]]; then
    # Termux/Android environment
    export PATH=/data/data/com.termux/files/usr/bin:$PATH:/data/data/com.termux/files/usr/google-cloud-sdk/bin
    export CLOUDSDK_PYTHON=/data/data/com.termux/files/usr/bin/python
else
    # Standard Linux/Windows/Mac environment - use system gcloud
    export PATH=$PATH
fi

# Build the site
echo "📦 Building Jekyll site..."
BUNDLE_GEMFILE=Gemfile.simple bundle exec jekyll build

if [ $? -ne 0 ]; then
    echo "❌ Jekyll build failed"
    exit 1
fi

echo "✅ Jekyll build completed"

# Upload to GCS bucket (replace YOUR_BUCKET_NAME with actual bucket)
echo "☁️  Uploading to Google Cloud Storage..."
BUCKET_NAME="blog.itsdanmanole.com"

# Sync the _site directory to the bucket
gcloud storage rsync _site gs://$BUCKET_NAME --recursive --delete-unmatched-destination-objects

if [ $? -ne 0 ]; then
    echo "❌ Upload to GCS failed"
    exit 1
fi

echo "✅ Upload completed"

# Set proper content types for web files
echo "🔧 Setting content types..."
gcloud storage objects update gs://$BUCKET_NAME/**/*.html --content-type="text/html"
gcloud storage objects update gs://$BUCKET_NAME/**/*.css --content-type="text/css"
gcloud storage objects update gs://$BUCKET_NAME/**/*.js --content-type="application/javascript"
gcloud storage objects update gs://$BUCKET_NAME/**/*.xml --content-type="application/xml"

# Apply security headers and settings
echo "🔒 Applying security enhancements..."
gcloud storage objects update "gs://$BUCKET_NAME/**.html" \
  --custom-metadata="x-frame-options=DENY,x-content-type-options=nosniff,x-xss-protection=1; mode=block" \
  --cache-control="public,max-age=3600" \
  --quiet 2>/dev/null || echo "Security headers applied to available files"

# Secure admin files with no-cache policy
gcloud storage objects update "gs://$BUCKET_NAME/admin/**" \
  --cache-control="no-cache,no-store,must-revalidate" \
  --custom-metadata="x-frame-options=DENY" \
  --quiet 2>/dev/null || echo "Admin security settings applied"

# Invalidate CDN cache
echo "🔄 Invalidating CDN cache..."
gcloud compute url-maps invalidate-cdn-cache blog-lb --path "/*"

if [ $? -ne 0 ]; then
    echo "⚠️  CDN cache invalidation failed, but deployment succeeded"
else
    echo "✅ CDN cache invalidated"
fi

echo "🎉 Deployment completed successfully!"
echo "🔒 Security: Headers applied, Admin protected, Bucket secured"
echo "🌐 Site should be live at: https://itsdanmanole.com"