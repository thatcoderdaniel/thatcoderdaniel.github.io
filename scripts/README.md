# Scripts Directory

Organization of shell scripts for the blog infrastructure.

## 📁 Structure

### `/deployment/` - Active Production Scripts
- **`deploy.sh`** - Main deployment script (GCP upload + CDN invalidation)
- **`setup-gcp.sh`** - Initial GCP infrastructure setup
- **`security-deploy.sh`** - Deployment with enhanced security headers

### `/legacy/` - Historical Debug Scripts
Contains old troubleshooting and fix scripts from development:
- Theme fixing scripts (dark mode, headings, SASS conflicts)
- CSS debugging tools
- Lightbox implementation scripts
- Background consistency fixes

**Note**: Legacy scripts are kept for reference but should not be used in production.

## 🚀 Usage

### Primary Deployment
```bash
# From project root (symlinked)
./deploy.sh

# Or directly
./scripts/deployment/deploy.sh
```

### GCP Setup (One-time)
```bash
./scripts/deployment/setup-gcp.sh
```

### Security-Enhanced Deployment
```bash
./scripts/deployment/security-deploy.sh
```

## 📝 Script Descriptions

### deploy.sh
The main workhorse script that:
1. Builds Jekyll site
2. Uploads to Google Cloud Storage
3. Sets content types and security headers
4. Invalidates CDN cache
5. Applies bucket security policies

### setup-gcp.sh
Initial infrastructure setup for:
- Cloud Storage bucket creation
- CDN configuration
- Load balancer setup
- SSL certificate configuration

### security-deploy.sh
Enhanced deployment with additional security measures:
- Content Security Policy headers
- HTTPS enforcement
- Admin interface protection
- Bucket access controls

## 🧹 Maintenance

The `legacy/` folder contains historical scripts that were used during development but are no longer needed. They are kept for reference and can be safely ignored for normal operations.

All active deployment should use the scripts in the `deployment/` folder.