#!/bin/bash

echo "🔧 Fixing Sass compilation error..."

# Remove the problematic import line from style.scss
echo "📝 Updating style.scss to remove conflicting imports..."
head -n -3 assets/css/style.scss > assets/css/style_temp.scss
mv assets/css/style_temp.scss assets/css/style.scss

# Add the necessary variables that basic.sass needs
echo "📝 Creating variables file..."
cat > _sass/_variables.sass << 'SASS'
$line-height: 1.6
$body-font-size: 16px
$font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif
$monospace: "SF Mono", Monaco, "Courier New", monospace
$border-radius: 4px
SASS

# Or alternatively, just remove all sass imports and use pure CSS
echo "🎨 Creating standalone CSS without Sass dependencies..."
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

nav div {
  display: flex;
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
  font-weight: 600;
}

h1 { font-size: 2rem; }
h2 { font-size: 1.5rem; }
h3 { font-size: 1.25rem; }

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
  font-family: "SF Mono", Monaco, "Courier New", monospace;
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

.post-list h2 {
  margin-top: 0;
  margin-bottom: 0.5rem;
}

.post-meta {
  color: var(--text-light);
  font-size: 0.9rem;
  margin: 0.5rem 0;
}

// Archive page
article ul {
  padding-left: 1.5rem;
}

article ul li {
  margin-bottom: 0.5rem;
}

// Footer
footer {
  text-align: center;
  padding: 2rem 0;
  color: var(--text-light);
  border-top: 1px solid var(--border-color);
}

// Selection
::selection {
  background-color: var(--selection);
}

// Mobile responsiveness
@media (max-width: 600px) {
  nav {
    flex-direction: column;
    align-items: flex-start;
  }
  
  nav div {
    width: 100%;
    justify-content: space-between;
    margin-bottom: 0.5rem;
  }
  
  .theme-toggle {
    margin-left: auto;
  }
}
CSS

echo "✅ Sass error fixed!"
echo ""
echo "Now testing the build..."
bundle exec jekyll serve
