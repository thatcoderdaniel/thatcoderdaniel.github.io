#!/bin/bash

# Deployment script for itsdanmanole.com
# This script builds and deploys the Jekyll site to Google Cloud Storage

echo "🚀 Starting deployment process..."

# Set up environment
export PATH=/data/data/com.termux/files/usr/bin:$PATH:/data/data/com.termux/files/usr/google-cloud-sdk/bin
export CLOUDSDK_PYTHON=/data/data/com.termux/files/usr/bin/python

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

# Invalidate CDN cache if using Cloud CDN
echo "🔄 Invalidating CDN cache..."
# Replace YOUR_URL_MAP with your actual URL map name
# gcloud compute url-maps invalidate-cdn-cache YOUR_URL_MAP --path "/*"

echo "🎉 Deployment completed successfully!"
echo "🌐 Site should be live at: https://itsdanmanole.com"