#!/bin/bash

echo "🎯 Final fix based on actual HTML structure..."

# Clear any duplicate CSS and start fresh with the heading fix
cat > assets/css/style.scss << 'CSS'
---
---

// Light theme (default)
:root, [data-theme="light"] {
  --bg-color: #ffffff;
  --text-color: #111111;
  --text-light: #6a6a6a;
  --link-color: #0066cc;
  --border-color: #e5e5e5;
  --code-bg: #f6f8fa;
  --header-bg: #ffffff;
  --selection: rgba(0, 102, 204, 0.1);
}

// Dark theme 
[data-theme="dark"] {
  --bg-color: #0d1117;        
  --text-color: #e4e6eb;       
  --text-light: #8b949e;       
  --link-color: #58a6ff;       
  --border-color: #30363d;     
  --code-bg: #161b22;          
  --header-bg: #010409;        
  --selection: rgba(88, 166, 255, 0.3);
}

// Base styles
* {
  transition: background-color 0.2s ease, color 0.2s ease;
}

html {
  font-size: 16px;
  height: 100%;
}

body {
  background-color: var(--bg-color);
  color: var(--text-color);
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
  line-height: 1.7;
  margin: 0;
  padding: 0;
  min-height: 100%;
  display: flex;
  flex-direction: column;
}

// HEADING STYLES - DEFAULT
h1, h2, h3, h4, h5, h6 {
  color: #000000;
  margin-top: 2rem;
  margin-bottom: 1rem;
  font-weight: 700;
  line-height: 1.3;
}

// DARK MODE HEADINGS - This is the correct selector!
body.dark h1,
body.dark h2,
body.dark h3,
body.dark h4,
body.dark h5,
body.dark h6 {
  color: #ffffff !important;
}

// Also catch any that might be in articles
body.dark article h1,
body.dark article h2,
body.dark article h3,
body.dark article h4,
body.dark article h5,
body.dark article h6,
body.dark main h1,
body.dark main h2,
body.dark main h3,
body.dark main h4,
body.dark main h5,
body.dark main h6 {
  color: #ffffff !important;
}

h1 { font-size: 2.5rem; }
h2 { font-size: 1.875rem; }
h3 { font-size: 1.5rem; }

// Theme toggle
.theme-toggle {
  background: transparent;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  color: var(--text-color);
  cursor: pointer;
  font-size: 1.1rem;
  padding: 0.35rem 0.55rem;
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
  padding: 1.25rem 0;
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
  margin-right: 1.75rem;
  font-size: 0.95rem;
}

nav a:hover {
  color: var(--link-color);
}

// Main
main {
  flex: 1;
  max-width: 48rem;
  margin: 3rem auto;
  padding: 0 1rem;
  width: 100%;
}

// Links
a {
  color: var(--link-color);
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}

// Code
pre, code {
  font-family: "SF Mono", Monaco, monospace;
}

code {
  background-color: var(--code-bg);
  border: 1px solid var(--border-color);
  border-radius: 4px;
  padding: 0.125em 0.375em;
  font-size: 0.875em;
}

pre {
  background-color: var(--code-bg);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 1.25rem;
  overflow-x: auto;
  margin: 1.5rem 0;
}

pre code {
  border: none;
  padding: 0;
  background: transparent;
}

// Post list
.post-list {
  list-style: none;
  padding: 0;
}

.post-list li {
  margin-bottom: 2rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid var(--border-color);
}

.post-list h2 {
  margin-top: 0;
  margin-bottom: 0.5rem;
}

// Make sure post list h2s are also white in dark mode
body.dark .post-list h2,
body.dark .post-list h2 a {
  color: #ffffff !important;
}

.post-meta {
  color: var(--text-light);
  font-size: 0.875rem;
  margin: 0.5rem 0;
}

// Archive
article ul {
  padding-left: 1.5rem;
}

article ul li {
  margin-bottom: 0.75rem;
}

article ul li time {
  color: var(--text-light);
  font-family: monospace;
  font-size: 0.875rem;
}

// Footer
footer {
  text-align: center;
  padding: 3rem 0 2rem;
  color: var(--text-light);
  border-top: 1px solid var(--border-color);
  font-size: 0.875rem;
}

// Selection
::selection {
  background-color: var(--selection);
}

// Mobile
@media (max-width: 600px) {
  nav a {
    margin-right: 1rem;
  }
  
  h1 { font-size: 2rem; }
  h2 { font-size: 1.5rem; }
}
CSS

echo "✅ Fixed with correct selectors for body.dark"
echo ""
echo "Building and serving..."
bundle exec jekyll build
bundle exec jekyll serve
