// Code Block Enhancements
class CodeEnhancements {
  constructor() {
    this.init();
  }

  init() {
    this.addCopyButtons();
    this.addLanguageLabels();
    this.improveCodeBlocks();
  }

  addCopyButtons() {
    const preBlocks = document.querySelectorAll('pre');
    
    preBlocks.forEach((pre, index) => {
      if (pre.querySelector('code')) {
        const wrapper = document.createElement('div');
        wrapper.className = 'code-block-wrapper';
        
        // Wrap the pre element
        pre.parentNode.insertBefore(wrapper, pre);
        wrapper.appendChild(pre);
        
        // Create copy button
        const copyButton = document.createElement('button');
        copyButton.className = 'copy-code-btn';
        copyButton.innerHTML = `
          <svg width="16" height="16" viewBox="0 0 24 24">
            <path fill="currentColor" d="M19,21H8V7H19M19,5H8A2,2 0 0,0 6,7V21A2,2 0 0,0 8,23H19A2,2 0 0,0 21,21V7A2,2 0 0,0 19,5M16,1H4A2,2 0 0,0 2,3V17H4V3H16V1Z"/>
          </svg>
          <span class="copy-text">Copy</span>
        `;
        
        copyButton.addEventListener('click', () => this.copyCode(pre, copyButton));
        wrapper.appendChild(copyButton);
      }
    });
  }

  async copyCode(pre, button) {
    const code = pre.querySelector('code');
    const text = code.textContent;
    
    try {
      await navigator.clipboard.writeText(text);
      
      // Visual feedback
      const originalText = button.querySelector('.copy-text').textContent;
      button.querySelector('.copy-text').textContent = 'Copied!';
      button.classList.add('copied');
      
      setTimeout(() => {
        button.querySelector('.copy-text').textContent = originalText;
        button.classList.remove('copied');
      }, 2000);
      
    } catch (err) {
      // Fallback for older browsers
      this.fallbackCopyText(text, button);
    }
  }

  fallbackCopyText(text, button) {
    const textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.position = 'fixed';
    textArea.style.opacity = '0';
    document.body.appendChild(textArea);
    textArea.select();
    
    try {
      document.execCommand('copy');
      button.querySelector('.copy-text').textContent = 'Copied!';
      button.classList.add('copied');
      
      setTimeout(() => {
        button.querySelector('.copy-text').textContent = 'Copy';
        button.classList.remove('copied');
      }, 2000);
    } catch (err) {
      console.error('Failed to copy text: ', err);
    }
    
    document.body.removeChild(textArea);
  }

  addLanguageLabels() {
    const codeBlocks = document.querySelectorAll('pre code[class*="language-"]');
    
    codeBlocks.forEach(code => {
      const pre = code.parentElement;
      const wrapper = pre.parentElement;
      
      if (wrapper.className === 'code-block-wrapper') {
        const className = code.className;
        const language = className.match(/language-(\w+)/);
        
        if (language) {
          const label = document.createElement('div');
          label.className = 'code-language-label';
          label.textContent = language[1].toUpperCase();
          wrapper.insertBefore(label, pre);
        }
      }
    });
  }

  improveCodeBlocks() {
    // Add line numbers to code blocks
    const preBlocks = document.querySelectorAll('pre code');
    
    preBlocks.forEach(code => {
      const lines = code.textContent.split('\n');
      if (lines.length > 3) { // Only add line numbers for longer code blocks
        code.classList.add('line-numbers');
        
        // Create line numbers
        const lineNumbersDiv = document.createElement('div');
        lineNumbersDiv.className = 'line-numbers-rows';
        
        for (let i = 1; i <= lines.length; i++) {
          const span = document.createElement('span');
          span.textContent = i;
          lineNumbersDiv.appendChild(span);
        }
        
        const wrapper = code.closest('.code-block-wrapper');
        if (wrapper) {
          wrapper.classList.add('has-line-numbers');
          wrapper.insertBefore(lineNumbersDiv, code.parentElement);
        }
      }
    });
  }
}

// Smooth Scrolling Enhancement
class SmoothScrolling {
  constructor() {
    this.init();
  }

  init() {
    // Add smooth scrolling to all internal links
    document.addEventListener('click', (e) => {
      const link = e.target.closest('a[href^="#"]');
      if (link) {
        e.preventDefault();
        const targetId = link.getAttribute('href').substring(1);
        const target = document.getElementById(targetId);
        
        if (target) {
          target.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
          });
          
          // Update URL without jumping
          history.pushState(null, null, `#${targetId}`);
        }
      }
    });
  }
}

// Enhanced Theme Toggle with Transitions
class EnhancedThemeToggle {
  constructor() {
    this.init();
  }

  init() {
    const themeToggle = document.querySelector('.theme-toggle');
    if (!themeToggle) return;

    // Add enhanced transition class
    document.body.classList.add('theme-transition');
    
    // Improve theme toggle button
    themeToggle.innerHTML = `
      <div class="theme-toggle-icon">
        <svg class="sun-icon" viewBox="0 0 24 24" width="16" height="16">
          <circle cx="12" cy="12" r="4"/>
          <path d="m12 2v2m0 16v2M4.93 4.93l1.41 1.41m11.32 11.32l1.41 1.41M2 12h2m16 0h2M6.34 6.34l1.41-1.41m11.32 11.32l1.41 1.41"/>
        </svg>
        <svg class="moon-icon" viewBox="0 0 24 24" width="16" height="16">
          <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/>
        </svg>
      </div>
    `;

    // Add smooth transitions for theme changes
    const originalToggle = themeToggle.onclick;
    themeToggle.onclick = (e) => {
      document.body.style.transition = 'background-color 0.3s ease, color 0.3s ease';
      setTimeout(() => {
        document.body.style.transition = '';
      }, 300);
      
      if (originalToggle) originalToggle.call(themeToggle, e);
    };
  }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  new CodeEnhancements();
  new SmoothScrolling();
  new EnhancedThemeToggle();
});