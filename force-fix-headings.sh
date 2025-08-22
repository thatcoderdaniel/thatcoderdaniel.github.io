#!/bin/bash

echo "🔨 Force-fixing ALL heading colors..."

# Add this CSS directly to the end of the current style.scss
# This will override EVERYTHING
cat >> assets/css/style.scss << 'CSS'

/* FORCE FIX - Override everything for dark mode headings */
body[class="dark"] h1,
body[class="dark"] h2,
body[class="dark"] h3,
body[class="dark"] h4,
body[class="dark"] h5,
body[class="dark"] h6,
html[data-theme="dark"] h1,
html[data-theme="dark"] h2,
html[data-theme="dark"] h3,
html[data-theme="dark"] h4,
html[data-theme="dark"] h5,
html[data-theme="dark"] h6,
.dark h1,
.dark h2,
.dark h3,
.dark h4,
.dark h5,
.dark h6 {
  color: #ffffff !important;
  opacity: 1 !important;
  filter: none !important;
}

/* Also fix any headings inside articles or main content */
[data-theme="dark"] article h1,
[data-theme="dark"] article h2,
[data-theme="dark"] article h3,
[data-theme="dark"] main h1,
[data-theme="dark"] main h2,
[data-theme="dark"] main h3,
body.dark article h1,
body.dark article h2,
body.dark article h3,
body.dark main h1,
body.dark main h2,
body.dark main h3 {
  color: #ffffff !important;
}

/* Debug - make absolutely sure */
[data-theme="dark"] * {
  & h1, & h2, & h3, & h4, & h5, & h6 {
    color: #ffffff !important;
  }
}
CSS

echo "✅ Applied nuclear option for heading colors"
echo ""
echo "Rebuilding..."
bundle exec jekyll build

echo ""
echo "Testing server..."
bundle exec jekyll serve
