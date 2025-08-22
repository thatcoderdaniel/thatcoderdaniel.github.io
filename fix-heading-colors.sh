#!/bin/bash

echo "🔧 Fixing heading colors in dark mode..."

# Update just the color variables for better contrast
sed -i '' '
/\[data-theme="dark"\]/,/^}/ {
  s/--heading-color: #f0f6fc;/--heading-color: #ffffff;/
  s/--text-color: #c9d1d9;/--text-color: #e4e6eb;/
}
' assets/css/style.scss

# If sed doesn't work, replace the whole dark theme section
cat > assets/css/style-temp.scss << 'CSS'
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

// Dark theme - Fixed heading visibility
[data-theme="dark"] {
  --bg-color: #0d1117;        
  --text-color: #e4e6eb;       // Brighter text
  --text-light: #8b949e;       
  --link-color: #58a6ff;       
  --border-color: #30363d;     
  --code-bg: #161b22;          
  --header-bg: #010409;        
  --selection: rgba(88, 166, 255, 0.3);
  --heading-color: #ffffff;    // Pure white for headings
}
CSS

# Append the rest of the CSS
tail -n +30 assets/css/style.scss >> assets/css/style-temp.scss
mv assets/css/style-temp.scss assets/css/style.scss

echo "✅ Heading colors fixed!"
echo ""
echo "Rebuilding site..."
bundle exec jekyll build
echo ""
echo "Refresh your browser to see the changes!"
