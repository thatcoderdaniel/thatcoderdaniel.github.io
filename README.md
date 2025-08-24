# Dan Manole - Production Cloud Infrastructure Blog

Personal blog showcasing cloud infrastructure, DevOps practices, and technical tutorials. Built with Jekyll and deployed on Google Cloud Platform.

🌐 **Live Site**: https://itsdanmanole.com

## 🏗️ Architecture

- **Frontend**: Jekyll static site generator with no-style-please theme
- **CMS**: TinaCMS for content management
- **Hosting**: Google Cloud Storage + Cloud CDN
- **CI/CD**: GitHub Actions with automated GCP deployments
- **Theme**: Custom dark/light mode with professional styling

## 🚀 Quick Start

### Prerequisites
- Ruby with Jekyll
- Node.js (for TinaCMS)
- Google Cloud SDK (for deployments)

### Local Development
```bash
# Clone repository
git clone https://github.com/thatcoderdaniel/thatcoderdaniel.github.io.git
cd thatcoderdaniel.github.io

# Install dependencies
bundle install
npm install

# Start local server
bundle exec jekyll serve --drafts
```

### Content Management
```bash
# Start TinaCMS locally
npx tinacms dev

# Access CMS at: http://localhost:3000/admin
```

## 📝 Content Management Workflow

### Adding/Editing Posts via TinaCMS

1. **Access TinaCMS**: Visit https://itsdanmanole.com/admin
2. **Create/Edit**: Add or modify blog posts through the visual editor
3. **Deploy Changes**: After saving in TinaCMS, run deployment:
   ```bash
   git pull  # Pull TinaCMS changes
   ./deploy.sh  # Deploy to live site
   ```

### Manual Post Creation
Posts are stored in `_posts/` using this naming convention: `YYYY-MM-DD-title.md`

Example frontmatter:
```yaml
---
title: "Your Post Title"
date: 2025-02-08
description: "Brief description for SEO"
---
```

## 🎨 Theme & Styling

### Features
- **Responsive Design**: Mobile-first approach
- **Dark/Light Mode**: Professional toggle with premium styling
- **Code Highlighting**: Enhanced syntax highlighting with Rouge
- **Professional Navigation**: Clean, button-based navigation
- **Reading Experience**: Progress indicators, TOC, estimated read time

### Customization
Main styling files:
- `_sass/no-style-please.scss` - Core theme styles
- `assets/js/theme-toggle.js` - Dark/light mode functionality
- `assets/js/reading-experience.js` - Reading enhancements

## 🚢 Deployment

### Automated Deployment
```bash
./deploy.sh
```

This script:
1. Builds Jekyll site
2. Uploads to Google Cloud Storage
3. Sets proper content types and security headers
4. Invalidates CDN cache
5. Applies bucket security policies

### Manual Commands
```bash
# Build only
bundle exec jekyll build

# Deploy to GCP (after build)
gsutil -m rsync -r -d _site/ gs://blog.itsdanmanole.com/

# Invalidate CDN cache
gcloud compute url-maps invalidate-cdn-cache blog-lb --path="/*" --async
```

## 🔧 Configuration

### Jekyll Configuration (`_config.yml`)
```yaml
title: "Dan Manole"
description: "Production Cloud Infrastructure"
url: "https://itsdanmanole.com"

# Theme settings
style: auto  # options: light, dark, auto
show_style_switcher: true

navigation:
  - title: "Archive"
    url: "/archive.html"
```

### Environment Setup
Create `.env` for local development:
```env
TINA_PUBLIC_CLIENT_ID=your_tina_client_id
TINA_TOKEN=your_tina_token
```

**⚠️ Security**: Never commit `.env` files to git.

## 📊 Maintenance

### Regular Tasks
```bash
# Update dependencies
bundle update
npm update

# Check for security issues
bundle audit
npm audit

# Sync TinaCMS changes and deploy
git pull && ./deploy.sh

# Clean build files
bundle exec jekyll clean
```

### Content Updates
- **TinaCMS Changes**: Automatically sync with git, then deploy
- **Theme Updates**: Edit SCSS files and deploy
- **Feature Additions**: Test locally, then deploy

### Monitoring
- **Site Health**: Monitor https://itsdanmanole.com
- **CDN Performance**: Check Google Cloud Console
- **Analytics**: Review user engagement metrics

## 🔒 Security

- **Content Security Policy**: Applied via deployment script
- **HTTPS Only**: Enforced at CDN level
- **Admin Protection**: TinaCMS access restricted
- **Token Security**: Environment variables not committed

## 📋 Changelog

### v3.1.0 - August 2025 (Current)
**🚀 GitHub Actions CI/CD Automation & Security Hardening**
- **Automated Deployment**: Complete GitHub Actions workflow for seamless TinaCMS integration
- **Dependency Management**: Optimized Gemfile.deploy for reliable CI/CD builds
- **Safe File Sync**: Smart deployment that preserves system files while updating site content
- **Error Resolution**: Fixed bundle install issues and Node.js dependency conflicts
- **Security Hardening**: Enhanced .gitignore to prevent secret exposure, removed potential credential files
- **Secret Management**: Proper GitHub Secrets integration with GCP service account authentication
- **Production Ready**: Bulletproof automation from TinaCMS updates to live deployment with enterprise-grade security

### v3.0.0 - February 2025
**🎨 Major Theme & UX Overhaul**
- **Premium Dark Mode**: Professional dark theme with enhanced code blocks, subtle shadows, and VS Code-like styling
- **Navigation Redesign**: Removed redundant "Home" button, added professional black button styling for Archive
- **Mobile Optimization**: Fixed iPhone theme toggle with touch events, responsive TOC design
- **Code Block Enhancement**: Superior syntax highlighting with proper contrast in both themes
- **UI Polish**: Removed unwanted elements (back-to-top button, lightbox X), clean professional appearance

### v2.1.0 - February 2025
**🚀 Performance & Infrastructure**
- **Deployment Automation**: Custom `./deploy.sh` script with GCP integration
- **CDN Optimization**: Automated cache invalidation and content type handling
- **Security Hardening**: Bucket policies, admin protection, CSP headers
- **TinaCMS Integration**: Seamless content management workflow

### v2.0.0 - February 2025
**🏗️ Platform Migration**
- **GCP Migration**: Moved from GitHub Pages to Google Cloud Platform
- **Custom Domain**: Configured https://itsdanmanole.com with SSL
- **CDN Setup**: Google Cloud CDN for global performance
- **CMS Integration**: Added TinaCMS for content management

### v1.0.0 - Initial Release
**📝 Foundation**
- **Jekyll Setup**: Static site generator with no-style-please theme
- **Basic Theming**: Light/dark mode toggle
- **Content Structure**: Blog post templates and archives
- **GitHub Pages**: Initial hosting platform

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make changes and test locally
4. Commit with descriptive messages
5. Push and create a Pull Request

## 📜 License

This project is open source. Feel free to use as reference for your own Jekyll blog.

## 🆘 Troubleshooting

### Common Issues

**TinaCMS not syncing**
```bash
git status  # Check for uncommitted changes
git pull    # Pull latest TinaCMS changes
```

**Deployment failures**
```bash
# Check GCP authentication
gcloud auth list

# Verify bucket permissions
gsutil ls -l gs://blog.itsdanmanole.com/
```

**Theme issues**
```bash
# Clear Jekyll cache
bundle exec jekyll clean
bundle exec jekyll build
```

**Mobile display problems**
- Check responsive CSS in `_sass/no-style-please.scss`
- Test touch events in `assets/js/theme-toggle.js`
- Verify mobile-first media queries

---

**Built with ❤️ by Dan Manole** | **Powered by Jekyll & Google Cloud Platform**