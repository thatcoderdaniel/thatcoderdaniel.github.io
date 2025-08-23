// Reading Progress Indicator
class ReadingProgress {
  constructor() {
    this.init();
  }

  init() {
    this.createProgressBar();
    this.calculateProgress();
    this.addScrollListener();
    this.addEstimatedReadTime();
  }

  createProgressBar() {
    const progressBar = document.createElement('div');
    progressBar.id = 'reading-progress';
    progressBar.innerHTML = '<div id="reading-progress-fill"></div>';
    document.body.insertBefore(progressBar, document.body.firstChild);
  }

  calculateProgress() {
    const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
    const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    const scrolled = (winScroll / height) * 100;
    
    const progressFill = document.getElementById('reading-progress-fill');
    if (progressFill) {
      progressFill.style.width = scrolled + '%';
    }
  }

  addScrollListener() {
    let ticking = false;
    window.addEventListener('scroll', () => {
      if (!ticking) {
        requestAnimationFrame(() => {
          this.calculateProgress();
          ticking = false;
        });
        ticking = true;
      }
    });
  }

  addEstimatedReadTime() {
    const article = document.querySelector('article');
    if (!article) return;

    const text = article.innerText;
    const wordsPerMinute = 200;
    const wordCount = text.trim().split(/\s+/).length;
    const readTime = Math.ceil(wordCount / wordsPerMinute);

    // Add read time to post meta
    const postMeta = document.querySelector('.post-meta');
    if (postMeta) {
      const readTimeElement = document.createElement('span');
      readTimeElement.innerHTML = ` • ${readTime} min read • ${wordCount} words`;
      readTimeElement.className = 'read-time';
      postMeta.appendChild(readTimeElement);
    }
  }
}

// Table of Contents Generator
class TableOfContents {
  constructor() {
    this.init();
  }

  init() {
    const article = document.querySelector('article');
    if (!article) return;

    // Get headings from content div only, not the header
    const contentDiv = article.querySelector('div');
    if (!contentDiv) return;
    
    const headings = contentDiv.querySelectorAll('h1, h2, h3, h4, h5, h6');
    if (headings.length < 3) return; // Show TOC for posts with 3+ headings

    this.generateTOC(headings);
  }

  generateTOC(headings) {
    const toc = document.createElement('div');
    toc.id = 'table-of-contents';
    toc.innerHTML = `
      <div class="toc-toggle">
        <button class="toc-toggle-btn" aria-expanded="false">
          <svg width="16" height="16" viewBox="0 0 24 24">
            <path fill="currentColor" d="M3,6H21V8H3V6M3,11H21V13H3V11M3,16H21V18H3V16Z"/>
          </svg>
          <span>Contents</span>
          <svg class="toc-chevron" width="16" height="16" viewBox="0 0 24 24">
            <path fill="currentColor" d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z"/>
          </svg>
        </button>
        <ul id="toc-list" class="toc-collapsed"></ul>
      </div>
    `;

    const tocList = toc.querySelector('#toc-list');
    const toggleBtn = toc.querySelector('.toc-toggle-btn');
    
    headings.forEach((heading, index) => {
      // Add ID to heading if it doesn't have one
      if (!heading.id) {
        heading.id = `heading-${index}`;
      }

      const li = document.createElement('li');
      li.className = `toc-${heading.tagName.toLowerCase()}`;
      
      const link = document.createElement('a');
      link.href = `#${heading.id}`;
      link.textContent = heading.textContent;
      link.addEventListener('click', this.smoothScrollToHeading);
      
      li.appendChild(link);
      tocList.appendChild(li);
    });

    // Add toggle functionality
    toggleBtn.addEventListener('click', () => {
      const isExpanded = toggleBtn.getAttribute('aria-expanded') === 'true';
      toggleBtn.setAttribute('aria-expanded', !isExpanded);
      tocList.classList.toggle('toc-collapsed');
      tocList.classList.toggle('toc-expanded');
    });

    // Insert TOC at the end of the article, not at the beginning
    const articleContent = document.querySelector('article div');
    if (articleContent) {
      articleContent.appendChild(toc);
    }
  }

  smoothScrollToHeading(e) {
    e.preventDefault();
    const target = document.querySelector(e.target.getAttribute('href'));
    if (target) {
      target.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
      });
    }
  }
}

// Back to Top Button with Progress
class BackToTop {
  constructor() {
    this.init();
  }

  init() {
    this.createButton();
    this.addScrollListener();
  }

  createButton() {
    const button = document.createElement('button');
    button.id = 'back-to-top';
    
    // Calculate the circumference for proper stroke-dasharray
    const radius = 16;
    const circumference = 2 * Math.PI * radius;
    
    button.innerHTML = `
      <svg viewBox="0 0 24 24" width="20" height="20" class="back-to-top-icon">
        <path fill="currentColor" d="M7.41,15.41L12,10.83L16.59,15.41L18,14L12,8L6,14L7.41,15.41Z"/>
      </svg>
      <div class="progress-ring">
        <svg viewBox="0 0 36 36" width="100%" height="100%">
          <circle cx="18" cy="18" r="16" fill="none" stroke="var(--border-color)" stroke-width="2"/>
          <circle id="progress-circle" cx="18" cy="18" r="16" fill="none" stroke="var(--link-color)" 
                  stroke-width="2" stroke-dasharray="${circumference}" stroke-dashoffset="${circumference}"/>
        </svg>
      </div>
    `;
    button.addEventListener('click', this.scrollToTop);
    document.body.appendChild(button);
  }

  addScrollListener() {
    let ticking = false;
    window.addEventListener('scroll', () => {
      if (!ticking) {
        requestAnimationFrame(() => {
          this.updateButton();
          ticking = false;
        });
        ticking = true;
      }
    });
  }

  updateButton() {
    const button = document.getElementById('back-to-top');
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    const docHeight = document.documentElement.scrollHeight - window.innerHeight;
    const progress = (scrollTop / docHeight) * 100;

    // Show button after scrolling 20% of the page
    if (progress > 20) {
      button.classList.add('visible');
    } else {
      button.classList.remove('visible');
    }

    // Update circular progress
    const circle = document.getElementById('progress-circle');
    if (circle) {
      const radius = 16;
      const circumference = 2 * Math.PI * radius;
      const offset = circumference - (progress / 100) * circumference;
      circle.style.strokeDashoffset = Math.max(0, offset);
    }
  }

  scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  new ReadingProgress();
  new TableOfContents();
  new BackToTop();
});