#!/bin/bash

# GCP Setup Script for Termux
# Usage: ./setup-gcp.sh /path/to/service-account-key.json

if [ $# -eq 0 ]; then
    echo "Usage: $0 /path/to/service-account-key.json"
    echo ""
    echo "Example: $0 ~/Downloads/my-project-key.json"
    exit 1
fi

KEY_FILE="$1"

if [ ! -f "$KEY_FILE" ]; then
    echo "❌ Key file not found: $KEY_FILE"
    exit 1
fi

echo "🔧 Setting up GCP authentication..."

# Set up environment
export PATH=/data/data/com.termux/files/usr/bin:$PATH:/data/data/com.termux/files/usr/google-cloud-sdk/bin
export CLOUDSDK_PYTHON=/data/data/com.termux/files/usr/bin/python

# Authenticate with service account
echo "🔐 Authenticating with service account..."
gcloud auth activate-service-account --key-file="$KEY_FILE"

if [ $? -ne 0 ]; then
    echo "❌ Authentication failed"
    exit 1
fi

echo "✅ Authentication successful!"

# Set default project
echo "📋 Available projects:"
gcloud projects list

echo ""
echo "🎯 To set a default project, run:"
echo "gcloud config set project YOUR_PROJECT_ID"

echo ""
echo "✅ GCP setup complete! You can now run ./deploy.sh"