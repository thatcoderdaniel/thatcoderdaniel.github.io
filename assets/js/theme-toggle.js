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
      const icon = toggle.querySelector('.theme-icon');
      const text = toggle.querySelector('.theme-text');
      
      if (icon) {
        icon.textContent = theme === 'dark' ? '☀️' : '🌙';
      }
      if (text) {
        text.textContent = theme === 'dark' ? 'Light' : 'Dark';
      }
      
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
