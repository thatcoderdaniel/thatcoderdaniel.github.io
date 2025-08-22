#!/bin/bash

echo "☢️ NUCLEAR OPTION - Override everything!"

# First, let's see what's actually being compiled
echo "Checking compiled CSS..."
grep -n "background" _site/assets/css/style.css | head -20

# Now completely override with maximum specificity
cat >> assets/css/style.scss << 'CSS'

/* NUCLEAR OVERRIDE - This WILL work */
html, body, main, article, div, section, header, footer,
html *, body *, main *, article * {
  background: transparent !important;
  background-color: transparent !important;
  background-image: none !important;
}

/* Set background only on body */
body {
  background-color: #ffffff !important;
}

body.dark,
[data-theme="dark"] body {
  background-color: #0d1117 !important;
}

/* Extra nuclear - target any possible container */
.dark main,
.dark article,
.dark .content,
.dark .post-content,
.dark .page-content,
.dark .wrapper,
.dark .container,
.dark div,
[data-theme="dark"] main,
[data-theme="dark"] article,
[data-theme="dark"] div {
  background: none !important;
  background-color: transparent !important;
  box-shadow: none !important;
}

/* If something STILL has a background, this will show it in red for debugging */
/* Uncomment to debug: */
/* 
.dark *:not(body):not(code):not(pre) {
  background-color: red !important;
}
*/
CSS

echo "✅ Nuclear override applied"
echo ""
echo "Rebuilding..."
rm -rf _site
bundle exec jekyll build
bundle exec jekyll serve
