#!/bin/bash

echo "🎨 Fixing background color consistency..."

# Add CSS to ensure all backgrounds match
cat >> assets/css/style.scss << 'CSS'

/* Fix background consistency in dark mode */
body.dark article,
body.dark main,
body.dark .post-content,
body.dark .content,
[data-theme="dark"] article,
[data-theme="dark"] main,
[data-theme="dark"] .post-content,
[data-theme="dark"] .content {
  background-color: transparent !important;
  background: none !important;
}

/* Ensure the body background is consistent everywhere */
body.dark,
body.dark main,
body.dark article {
  background-color: #0d1117 !important;
}

/* Remove any box shadows or borders that might create visual separation */
body.dark article,
body.dark main > *,
body.dark .post-content {
  box-shadow: none !important;
  border: none !important;
}

/* If there's a container with different background, fix it */
body.dark .container,
body.dark .wrapper,
body.dark .page-content {
  background-color: transparent !important;
}
CSS

echo "✅ Background colors unified"
echo ""
echo "Rebuilding..."
bundle exec jekyll build
bundle exec jekyll serve
