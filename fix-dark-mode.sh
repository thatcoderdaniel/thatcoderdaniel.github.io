#!/bin/bash

echo "🔧 Fixing Dark/Light Mode Toggle for Jekyll Blog"
echo "================================================"

# Backup current files
echo "📦 Creating backups..."
mkdir -p _backup_$(date +%Y%m%d_%H%M%S)
cp -r _layouts _sass assets _config.yml _backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null || true

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p assets/js assets/css _includes

# Fix the JavaScript toggle
echo "✨ Creating theme toggle JavaScript..."
cat > assets/js/theme-toggle.js << 'JS'
// Theme toggle with localStorage persistence
(function() {
  const STORAGE_KEY = 'theme-preference';
  
  function getTheme() {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) return stored;
    
    // Check config default or system preference
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }
    return 'light';
  }
  
  function setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    document.body.className = theme;
    localStorage.setItem(STORAGE_KEY, theme);
    
    // Update all toggle buttons
    document.querySelectorAll('.theme-toggle').forEach(toggle => {
      toggle.textContent = theme === 'dark' ? '☀️' : '🌙';
      toggle.setAttribute('aria-label', `Switch to ${theme === 'dark' ? 'light' : 'dark'} mode`);
    });
  }
  
  // Initialize on page load
  document.addEventListener('DOMContentLoaded', function() {
    const initialTheme = getTheme();
    setTheme(initialTheme);
    
    // Add click handlers to all toggle buttons
    document.querySelectorAll('.theme-toggle').forEach(toggle => {
      toggle.addEventListener('click', function(e) {
        e.preventDefault();
        const current = document.documentElement.getAttribute('data-theme') || 'light';
        const next = current === 'dark' ? 'light' : 'dark';
        setTheme(next);
      });
    });
  });
  
  // Also set theme immediately (before DOM ready)
  document.documentElement.setAttribute('data-theme', getTheme());
})();
JS

# Create the main CSS with dark mode support
echo "🎨 Creating main CSS with dark mode..."
cat > assets/css/style.scss << 'CSS'
---
---

// CSS Variables for theming
:root, [data-theme="light"] {
  --bg-color: #ffffff;
  --text-color: #000000;
  --text-light: #666666;
  --link-color: #0066cc;
  --border-color: #e0e0e0;
  --code-bg: #f7f7f7;
  --header-bg: #ffffff;
  --selection: rgba(0, 102, 204, 0.1);
}

[data-theme="dark"] {
  --bg-color: #1a1a1a;
  --text-color: #e0e0e0;
  --text-light: #999999;
  --link-color: #66b3ff;
  --border-color: #333333;
  --code-bg: #2a2a2a;
  --header-bg: #0d0d0d;
  --selection: rgba(102, 179, 255, 0.2);
}

// Smooth transitions
* {
  transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
}

// Base styles
html {
  font-size: 16px;
  height: 100%;
}

body {
  background-color: var(--bg-color);
  color: var(--text-color);
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
  line-height: 1.6;
  margin: 0;
  padding: 0;
  min-height: 100%;
  display: flex;
  flex-direction: column;
}

// Theme toggle button
.theme-toggle {
  background: transparent;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  color: var(--text-color);
  cursor: pointer;
  font-size: 1.2rem;
  padding: 0.4rem 0.6rem;
  margin-left: 1rem;
  outline: none;
}

.theme-toggle:hover {
  background-color: var(--code-bg);
}

// Header
header {
  background-color: var(--header-bg);
  border-bottom: 1px solid var(--border-color);
  padding: 1rem 0;
}

nav {
  max-width: 48rem;
  margin: 0 auto;
  padding: 0 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

nav a {
  color: var(--text-color);
  text-decoration: none;
  font-weight: 600;
  margin-right: 1.5rem;
}

nav a:hover {
  color: var(--link-color);
}

// Main content
main {
  flex: 1;
  max-width: 48rem;
  margin: 2rem auto;
  padding: 0 1rem;
  width: 100%;
}

// Typography
h1, h2, h3, h4, h5, h6 {
  color: var(--text-color);
  margin-top: 2rem;
  margin-bottom: 1rem;
}

a {
  color: var(--link-color);
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}

// Code blocks
pre, code {
  background-color: var(--code-bg);
  border: 1px solid var(--border-color);
  border-radius: 3px;
}

code {
  padding: 0.2em 0.4em;
  font-size: 0.9em;
}

pre {
  padding: 1rem;
  overflow-x: auto;
}

pre code {
  border: none;
  padding: 0;
}

// Posts list
.post-list {
  list-style: none;
  padding: 0;
}

.post-list li {
  margin-bottom: 1.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid var(--border-color);
}

.post-meta {
  color: var(--text-light);
  font-size: 0.9rem;
}

// Selection
::selection {
  background-color: var(--selection);
}

// Import existing Sass if available
@import "basic", "layout", "classes";
CSS

# Update the default layout
echo "📝 Updating default layout..."
cat > _layouts/default.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{% if page.title %}{{ page.title }} - {% endif %}{{ site.title }}</title>
  <meta name="description" content="{{ page.description | default: site.description }}">
  <link rel="stylesheet" href="{{ '/assets/css/style.css' | relative_url }}">
  <script src="{{ '/assets/js/theme-toggle.js' | relative_url }}"></script>
  <link rel="alternate" type="application/rss+xml" title="{{ site.title }}" href="{{ '/feed.xml' | relative_url }}">
</head>
<body>
  <header>
    <nav>
      <div>
        <a href="{{ '/' | relative_url }}">{{ site.title }}</a>
        {% for item in site.navigation %}
          {% unless item.url == '/' %}
            <a href="{{ item.url | relative_url }}">{{ item.title }}</a>
          {% endunless %}
        {% endfor %}
      </div>
      <button class="theme-toggle" aria-label="Toggle theme">🌙</button>
    </nav>
  </header>
  
  <main>
    {{ content }}
  </main>
  
  <footer style="text-align: center; padding: 2rem 0; color: var(--text-light);">
    <small>© {{ 'now' | date: '%Y' }} {{ site.author | default: site.title }}</small>
  </footer>
</body>
</html>
HTML

# Update the page layout
echo "📝 Updating page layout..."
cat > _layouts/page.html << 'HTML'
---
layout: default
---
<article>
  <header>
    <h1>{{ page.title }}</h1>
  </header>
  <div>
    {{ content }}
  </div>
</article>
HTML

# Update the post layout
echo "📝 Updating post layout..."
cat > _layouts/post.html << 'HTML'
---
layout: default
---
<article>
  <header>
    <h1>{{ page.title }}</h1>
    <p class="post-meta">
      <time datetime="{{ page.date | date_to_xmlschema }}">
        {{ page.date | date: "%B %-d, %Y" }}
      </time>
    </p>
  </header>
  <div>
    {{ content }}
  </div>
</article>
HTML

# Update index.html
echo "📝 Updating index.html..."
cat > index.html << 'HTML'
---
layout: default
---

<div class="home">
  <h1>Recent Posts</h1>
  
  <ul class="post-list">
    {% for post in site.posts limit:10 %}
      <li>
        <h2>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </h2>
        <p class="post-meta">
          <time datetime="{{ post.date | date_to_xmlschema }}">
            {{ post.date | date: "%B %-d, %Y" }}
          </time>
        </p>
        <p>{{ post.excerpt | strip_html | truncate: 200 }}</p>
      </li>
    {% endfor %}
  </ul>
  
  <p><a href="{{ '/archive.html' | relative_url }}">View all posts →</a></p>
</div>
HTML

# Update archive.html
echo "📝 Updating archive.html..."
cat > archive.html << 'HTML'
---
layout: page
title: Archive
---

{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}

{% for year in posts_by_year %}
  <h2>{{ year.name }}</h2>
  <ul>
    {% for post in year.items %}
      <li>
        <time datetime="{{ post.date | date_to_xmlschema }}">
          {{ post.date | date: "%b %-d" }}
        </time>
        —
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
  </ul>
{% endfor %}
HTML

# Clean up old files
echo "🧹 Cleaning up old theme files..."
rm -f assets/js/toggle-color.js 2>/dev/null || true

echo ""
echo "✅ Dark/Light mode fix complete!"
echo ""
echo "📋 Next steps:"
echo "1. Test locally: bundle exec jekyll serve"
echo "2. Open http://localhost:4000"
echo "3. Click the 🌙/☀️ button to toggle themes"
echo ""
echo "If everything works:"
echo "4. Commit changes: git add . && git commit -m 'Fix dark/light mode toggle'"
echo "5. Push to GitHub: git push"
echo "6. Deploy to GCP: gsutil -m rsync -d -r _site/ gs://blog.itsdanmanole.com/"
echo ""
echo "🎉 Done!"
