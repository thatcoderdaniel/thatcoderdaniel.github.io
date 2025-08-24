#!/bin/bash

echo "🎨 Optimizing Dark Mode Colors..."

# Update the CSS with better dark mode colors
cat > assets/css/style.scss << 'CSS'
---
---

// Light theme (default) - Keep this clean
:root, [data-theme="light"] {
  --bg-color: #ffffff;
  --text-color: #111111;
  --text-light: #6a6a6a;
  --link-color: #0066cc;
  --border-color: #e5e5e5;
  --code-bg: #f6f8fa;
  --header-bg: #ffffff;
  --selection: rgba(0, 102, 204, 0.1);
  --heading-color: #000000;
}

// Dark theme - Optimized for readability
[data-theme="dark"] {
  --bg-color: #0d1117;        // GitHub dark blue-black
  --text-color: #c9d1d9;       // Softer white
  --text-light: #8b949e;       // Muted gray
  --link-color: #58a6ff;       // Bright blue
  --border-color: #30363d;     // Subtle border
  --code-bg: #161b22;          // Slightly lighter than bg
  --header-bg: #010409;        // Darker header
  --selection: rgba(88, 166, 255, 0.3);
  --heading-color: #f0f6fc;    // Bright white for headings
}

// Alternative dark theme options - uncomment the one you prefer:

// Option 2: Warmer dark (like VS Code)
/*
[data-theme="dark"] {
  --bg-color: #1e1e1e;
  --text-color: #d4d4d4;
  --text-light: #858585;
  --link-color: #4fc1ff;
  --border-color: #333333;
  --code-bg: #2d2d2d;
  --header-bg: #161616;
  --selection: rgba(79, 193, 255, 0.25);
  --heading-color: #ffffff;
}
*/

// Option 3: Pure dark (high contrast)
/*
[data-theme="dark"] {
  --bg-color: #000000;
  --text-color: #e0e0e0;
  --text-light: #999999;
  --link-color: #4da6ff;
  --border-color: #2a2a2a;
  --code-bg: #0a0a0a;
  --header-bg: #000000;
  --selection: rgba(77, 166, 255, 0.3);
  --heading-color: #ffffff;
}
*/

// Smooth transitions (faster)
* {
  transition: background-color 0.2s ease, color 0.2s ease, border-color 0.2s ease;
}

// Base styles
html {
  font-size: 16px;
  height: 100%;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
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
  font-weight: 400;
}

// Better dark mode font rendering
[data-theme="dark"] body {
  font-weight: 300;
  letter-spacing: 0.01em;
}

// Theme toggle button - more refined
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
  position: relative;
  top: -1px;
}

.theme-toggle:hover {
  background-color: var(--code-bg);
  border-color: var(--link-color);
}

// Header - cleaner
header {
  background-color: var(--header-bg);
  border-bottom: 1px solid var(--border-color);
  padding: 1.25rem 0;
  backdrop-filter: blur(10px);
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
  letter-spacing: -0.01em;
}

nav a:hover {
  color: var(--link-color);
}

// Main content
main {
  flex: 1;
  max-width: 48rem;
  margin: 3rem auto;
  padding: 0 1rem;
  width: 100%;
}

// Typography - improved
h1, h2, h3, h4, h5, h6 {
  color: var(--heading-color);
  margin-top: 2.5rem;
  margin-bottom: 1rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  line-height: 1.3;
}

h1 { 
  font-size: 2.5rem; 
  margin-top: 0;
}
h2 { font-size: 1.875rem; }
h3 { font-size: 1.5rem; }

p {
  margin-bottom: 1.25rem;
}

a {
  color: var(--link-color);
  text-decoration: none;
  font-weight: 500;
}

a:hover {
  text-decoration: underline;
  text-decoration-thickness: 2px;
  text-underline-offset: 2px;
}

// Code blocks - better styling
pre, code {
  font-family: "SF Mono", "Monaco", "Inconsolata", "Fira Code", monospace;
}

code {
  background-color: var(--code-bg);
  border: 1px solid var(--border-color);
  border-radius: 4px;
  padding: 0.125em 0.375em;
  font-size: 0.875em;
  font-weight: 500;
}

pre {
  background-color: var(--code-bg);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 1.25rem;
  overflow-x: auto;
  line-height: 1.6;
  margin: 1.5rem 0;
}

pre code {
  border: none;
  padding: 0;
  background: transparent;
  font-weight: 400;
}

// Posts list - refined
.post-list {
  list-style: none;
  padding: 0;
}

.post-list li {
  margin-bottom: 2rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid var(--border-color);
}

.post-list li:last-child {
  border-bottom: none;
}

.post-list h2 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  font-size: 1.5rem;
}

.post-list h2 a {
  color: var(--heading-color);
  font-weight: 700;
}

.post-list h2 a:hover {
  color: var(--link-color);
  text-decoration: none;
}

.post-meta {
  color: var(--text-light);
  font-size: 0.875rem;
  margin: 0.5rem 0;
  font-weight: 500;
  letter-spacing: 0.01em;
}

// Archive page
article ul {
  padding-left: 1.5rem;
}

article ul li {
  margin-bottom: 0.75rem;
  color: var(--text-color);
}

article ul li time {
  color: var(--text-light);
  font-family: "SF Mono", monospace;
  font-size: 0.875rem;
}

// Footer
footer {
  text-align: center;
  padding: 3rem 0 2rem;
  color: var(--text-light);
  border-top: 1px solid var(--border-color);
  margin-top: 4rem;
  font-size: 0.875rem;
}

// Selection color
::selection {
  background-color: var(--selection);
}

// Mobile responsiveness
@media (max-width: 600px) {
  nav {
    padding: 0 1rem;
  }
  
  nav a {
    margin-right: 1rem;
    font-size: 0.9rem;
  }
  
  h1 { font-size: 2rem; }
  h2 { font-size: 1.5rem; }
  h3 { font-size: 1.25rem; }
  
  main {
    margin: 2rem auto;
  }
}

// Add subtle animation to the theme toggle
.theme-toggle {
  transition: transform 0.2s ease;
}

.theme-toggle:active {
  transform: scale(0.95);
}
CSS

echo "✅ Dark mode optimized!"
echo ""
echo "Testing the new design..."
bundle exec jekyll serve
