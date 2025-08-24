# Claude Code Reference - Dan Manole's Blog

> **🤖 AI Assistant Reference File**  
> This file contains the complete context needed for Claude Code to understand and maintain this website without breaking existing functionality.

## 🎯 Website Identity & Purpose

**Site**: https://itsdanmanole.com  
**Owner**: Dan Manole  
**Purpose**: Production Cloud Infrastructure blog showcasing DevOps practices and technical tutorials  
**Theme Philosophy**: Clean, professional, minimal design with premium dark mode experience  

## 🏗️ Complete Architecture Stack

### Core Technologies
- **Static Site Generator**: Jekyll 4.4.1
- **Base Theme**: no-style-please by riggraz (heavily customized)
- **CMS**: TinaCMS for content management
- **Hosting**: Google Cloud Storage + Cloud CDN
- **Domain**: https://itsdanmanole.com (SSL enabled)
- **Deployment**: Custom `./deploy.sh` script

### Key Files & Their Purpose
```
├── _config.yml                    # Jekyll configuration (NEVER remove navigation items without permission)
├── _layouts/
│   ├── default.html              # Main layout with navigation (navigation structure is intentional)
│   ├── page.html                 # Page layout
│   └── post.html                 # Blog post layout
├── _sass/
│   └── no-style-please.scss      # MASTER STYLESHEET - contains all custom CSS (be very careful with changes)
├── assets/js/
│   ├── theme-toggle.js           # Dark/light mode toggle (iPhone-optimized with touch events)
│   ├── reading-experience.js     # TOC, progress bar, back-to-top (back-to-top is DISABLED by user request)
│   └── lightbox.js               # Image lightbox (close button is HIDDEN by user request)
├── _posts/                       # Blog posts managed by TinaCMS
├── deploy.sh                     # CRITICAL: Automated deployment script
└── CLAUDE.md                     # This reference file
```

## 🎨 Design System & User Preferences

### Theme Features (DO NOT BREAK)
1. **Premium Dark Mode**: Professional dark theme with enhanced code blocks
   - Light theme: Classic black code blocks with white text
   - Dark theme: Dark gray (#2d2d2d) code blocks with light gray text (#e6e6e6)
   - Subtle borders and shadows for depth in dark mode

2. **Navigation Structure**: User specifically requested
   - "Dan Manole" logo (clickable home link)
   - "Archive" button (professional black styling)
   - Theme toggle button
   - **NEVER add back "Home" button** - user removed it intentionally

3. **Mobile Optimization**: iPhone-specific fixes applied
   - Touch events for theme toggle (`touchend` + `click`)
   - Responsive TOC design
   - Professional button styling works on mobile

4. **Code Block Styling**: User specifically requested premium appearance
   - Both inline `code` and ```code blocks``` styled consistently
   - Enhanced padding, border-radius, and typography
   - VS Code-like appearance in dark mode

### Elements User REMOVED (DO NOT RE-ADD)
- ❌ Back-to-top button (disabled in reading-experience.js)
- ❌ Lightbox X button (hidden via CSS)
- ❌ "Home" navigation button (removed from _config.yml)

## 🚨 Critical "Do Not Break" Rules

### 1. NEVER Touch These Without User Permission
- **Navigation structure** in `_config.yml` or `_layouts/default.html`
- **Theme toggle functionality** in `assets/js/theme-toggle.js`
- **Core CSS variables** in `_sass/no-style-please.scss` (color scheme, code blocks)
- **Deploy script** `./deploy.sh` (handles GCP deployment)

### 2. Always Preserve These User Customizations
- **Professional navigation buttons** (black/white styling with hover effects)
- **Premium dark mode** code blocks with proper contrast
- **Mobile touch events** for iPhone theme toggle
- **Clean TOC design** (compact floating style)

### 3. Formatting & Code Standards
- **Original theme philosophy**: User reverted to riggraz's original approach after complex CSS caused issues
- **Code blocks**: Must maintain black/white simplicity in light mode, professional styling in dark mode
- **Mobile-first**: All features must work on iPhone/Android
- **No overlapping text**: Path formatting (like `/home/admin/kihei`) must not overlap

## 📝 Content Management System

### TinaCMS Integration
- **Admin URL**: https://itsdanmanole.com/admin
- **Local Dev**: `npx tinacms dev`
- **Content Sync**: TinaCMS saves to `_posts/` directory, commits to git
- **Deployment Flow**: User edits in TinaCMS → `git pull` → `./deploy.sh`

### Post Structure
```yaml
---
title: "Post Title"
date: YYYY-MM-DD
description: "SEO description"
---
Content in Markdown...
```

## 🚀 Deployment System

### Automated Deployment (`./deploy.sh`)
**CRITICAL**: This script handles the entire deployment pipeline:
1. Builds Jekyll site (`bundle exec jekyll build`)
2. Uploads to GCS (`gsutil -m rsync -r -d _site/ gs://blog.itsdanmanole.com/`)
3. Sets content types and security headers
4. Invalidates CDN cache (`gcloud compute url-maps invalidate-cdn-cache blog-lb --path="/*" --async`)
5. Applies bucket security policies

### Manual Deployment Commands
```bash
# Full deployment
./deploy.sh

# Emergency cache invalidation only
gcloud compute url-maps invalidate-cdn-cache blog-lb --path="/*" --async

# Build only (for testing)
bundle exec jekyll build
```

### Google Cloud Infrastructure
- **Storage Bucket**: `gs://blog.itsdanmanole.com/`
- **CDN**: Cloud CDN with global distribution
- **Load Balancer**: `blog-lb`
- **SSL**: Automatic HTTPS enforcement
- **Security**: CSP headers, admin protection

## 🔒 Security & Secrets

### Environment Variables
- **TinaCMS Token**: Stored in `.env` (NEVER commit to git)
- **GCP Authentication**: Via `gcloud auth` (service account)
- **Admin Access**: TinaCMS admin interface protected

### Security Measures Applied
- Content Security Policy headers
- HTTPS-only enforcement
- Bucket access controls
- Admin interface restrictions

## 🐛 Common Issues & Solutions

### Problem: "Text Overlapping" or "Path Formatting Issues"
**Root Cause**: Complex CSS overriding original theme
**Solution**: Revert to riggraz's original approach (black/white code blocks)
**NEVER**: Add complex CSS that might cause text overlap

### Problem: "Theme Toggle Not Working on iPhone"
**Root Cause**: Missing touch event handlers
**Solution**: Ensure both `click` and `touchend` events in `theme-toggle.js`

### Problem: "Navigation Shows 'Home' Button"
**Root Cause**: Jekyll cache or config issue
**Solution**: User intentionally removed it - check `_config.yml` navigation array

### Problem: "Dark Mode Code Blocks Unreadable"
**Root Cause**: Poor contrast in dark theme
**Solution**: Use established colors (#2d2d2d background, #e6e6e6 text)

## 📊 Performance Considerations

### Image Optimization
- All images processed through lightbox system
- Responsive sizing with `max-width: 100%`
- Lazy loading where applicable

### Code Highlighting
- Rouge syntax highlighter
- Minimal CSS for fast loading
- Mobile-optimized rendering

### CDN & Caching
- Global CDN distribution
- Automatic cache invalidation on deploy
- Asset versioning for cache busting

## 🔄 Version History Context

### Why Current Design Exists
1. **Original Attempt**: Complex CSS with multiple frameworks → caused text overlapping
2. **User Feedback**: "man both looks bad. think this through" → demanded simplicity
3. **Solution**: Reverted to original theme author's approach → fixed all issues
4. **Enhancement**: Added professional styling without breaking core functionality

### Major Improvements Made
- Premium dark mode without breaking light mode
- Professional navigation without losing functionality
- iPhone optimization without desktop issues
- Enhanced code blocks without text overlap

## 🤖 Claude Code Instructions

### Before Making ANY Changes
1. **Read this file** to understand current context
2. **Check user's specific requests** against "Do Not Break" rules
3. **Test mobile/iPhone compatibility** for UI changes
4. **Preserve user customizations** (navigation, theme, styling)

### When User Reports Issues
1. **First check** if it's a known pattern from this file
2. **Reference "Common Issues"** section for solutions
3. **Never break** working functionality to fix new issues
4. **Ask for confirmation** before major changes

### For New Features
1. **Follow existing patterns** (professional styling, mobile-first)
2. **Test in both** light and dark modes
3. **Ensure iPhone compatibility** (touch events, responsive design)
4. **Update this file** if adding new critical components

### For Troubleshooting
1. **Check deployment status**: `git status`, `./deploy.sh` logs
2. **Verify CDN cache**: Run cache invalidation if needed
3. **Test locally**: `bundle exec jekyll serve` before deploying
4. **Mobile testing**: Use browser dev tools or actual devices

## 📱 Mobile-Specific Considerations

### iPhone Optimizations Applied
- Touch event handling for theme toggle
- Responsive navigation design
- Compact TOC styling
- Professional button scaling

### Android Compatibility
- All features tested on Android Chrome
- Touch events work across both platforms
- Responsive design scales properly

## 🎯 Success Metrics

### User Satisfaction Indicators
- "Outstanding", "Perfect", "Great" responses to recent changes
- Specific positive feedback on premium dark mode
- No complaints about formatting issues after fixes

### Technical Success Metrics
- No text overlapping issues
- Theme toggle working on all devices
- Professional appearance maintained
- Fast deployment and CDN performance

---

## 🚨 EMERGENCY PROCEDURES

### Site Completely Broken
```bash
git log --oneline -10          # Find last working commit
git reset --hard <commit-hash> # Revert to working state
./deploy.sh                    # Deploy fixed version
```

### Deployment Failing
```bash
gcloud auth list               # Check authentication
gsutil ls gs://blog.itsdanmanole.com/  # Test bucket access
bundle exec jekyll build       # Test local build
```

### Cache Issues
```bash
gcloud compute url-maps invalidate-cdn-cache blog-lb --path="/*" --async
```

---

**Last Updated**: February 2025  
**Version**: 3.0.0  
**Status**: Production Ready ✅

> **Remember**: This website represents the user's professional brand. Every change should enhance, not detract from, the clean and professional appearance they've specifically requested.