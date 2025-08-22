#!/bin/bash

echo "🔧 Direct fix for ALL heading visibility..."

# Create a clean CSS file with explicit heading colors
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

// EXPLICIT HEADING COLORS - This is the key fix
h1, h2, h3, h4, h5, h6 {
  margin-top: 2rem;
  margin-bottom: 1rem;
  font-weight: 700;
  line-height: 1.3;
}

// Light mode headings
[data-theme="light"] h1,
[data-theme="light"] h2,
[data-theme="light"] h3,
[data-theme="light"] h4,
[data-theme="light"] h5,
[data-theme="light"] h6,
:root h1,
:root h2,
:root h3,
:root h4,
:root h5,
:root h6 {
  color: #000000;
}

// Dark mode headings - FORCE WHITE
[data-theme="dark"] h1,
[data-theme="dark"] h2,
[data-theme="dark"] h3,
[data-theme="dark"] h4,
[data-theme="dark"] h5,
[data-theme="dark"] h6 {
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

echo "✅ All headings should now be white in dark mode!"
echo ""
echo "Building site..."
bundle exec jekyll build

echo ""
echo "Starting server..."
bundle exec jekyll serve
