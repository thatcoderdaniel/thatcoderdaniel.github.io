#!/bin/bash

echo "🖼️ Adding image lightbox feature..."

# Create the JavaScript for the lightbox
cat > assets/js/lightbox.js << 'JS'
// Simple Lightbox for Images
(function() {
  // Create lightbox elements
  function createLightbox() {
    const lightbox = document.createElement('div');
    lightbox.id = 'lightbox';
    lightbox.innerHTML = `
      <span class="lightbox-close">&times;</span>
      <img class="lightbox-content" id="lightbox-img">
      <div class="lightbox-caption"></div>
    `;
    document.body.appendChild(lightbox);
    return lightbox;
  }

  // Initialize lightbox functionality
  document.addEventListener('DOMContentLoaded', function() {
    const lightbox = createLightbox();
    const lightboxImg = document.getElementById('lightbox-img');
    const lightboxCaption = lightbox.querySelector('.lightbox-caption');
    const closeBtn = lightbox.querySelector('.lightbox-close');
    
    // Add click handler to all images in articles
    const images = document.querySelectorAll('article img, main img');
    
    images.forEach(img => {
      // Add cursor pointer to indicate clickable
      img.style.cursor = 'pointer';
      
      img.addEventListener('click', function(e) {
        e.preventDefault();
        lightbox.style.display = 'flex';
        lightboxImg.src = this.src;
        lightboxCaption.textContent = this.alt || '';
        
        // Add zoom effect
        setTimeout(() => {
          lightbox.classList.add('active');
        }, 10);
      });
    });
    
    // Close lightbox when clicking X
    closeBtn.addEventListener('click', closeLightbox);
    
    // Close lightbox when clicking outside image
    lightbox.addEventListener('click', function(e) {
      if (e.target === lightbox) {
        closeLightbox();
      }
    });
    
    // Close on ESC key
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        closeLightbox();
      }
    });
    
    function closeLightbox() {
      lightbox.classList.remove('active');
      setTimeout(() => {
        lightbox.style.display = 'none';
      }, 300);
    }
  });
})();
JS

# Add lightbox CSS to the main stylesheet
cat >> assets/css/style.scss << 'CSS'

/* ==================== LIGHTBOX STYLES ==================== */
#lightbox {
  display: none;
  position: fixed;
  z-index: 9999;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.95);
  justify-content: center;
  align-items: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

#lightbox.active {
  opacity: 1;
}

.lightbox-content {
  max-width: 90%;
  max-height: 90%;
  object-fit: contain;
  transform: scale(0.9);
  transition: transform 0.3s ease;
  border-radius: 4px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.5);
}

#lightbox.active .lightbox-content {
  transform: scale(1);
}

.lightbox-close {
  position: absolute;
  top: 20px;
  right: 40px;
  color: #ffffff;
  font-size: 40px;
  font-weight: 300;
  cursor: pointer;
  z-index: 10000;
  transition: color 0.2s ease, transform 0.2s ease;
  user-select: none;
}

.lightbox-close:hover {
  color: var(--link-color);
  transform: scale(1.1);
}

.lightbox-caption {
  position: absolute;
  bottom: 30px;
  left: 50%;
  transform: translateX(-50%);
  color: #ffffff;
  text-align: center;
  padding: 10px 20px;
  background: rgba(0, 0, 0, 0.7);
  border-radius: 4px;
  max-width: 80%;
  font-size: 0.9rem;
  backdrop-filter: blur(10px);
}

/* Make images in posts look clickable */
article img:hover,
main img:hover {
  opacity: 0.9;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
  transform: scale(1.02);
  transition: all 0.2s ease;
}

article img,
main img {
  transition: all 0.2s ease;
}

/* Mobile responsiveness for lightbox */
@media (max-width: 600px) {
  .lightbox-close {
    top: 10px;
    right: 20px;
    font-size: 30px;
  }
  
  .lightbox-content {
    max-width: 95%;
    max-height: 80%;
  }
  
  .lightbox-caption {
    bottom: 20px;
    font-size: 0.8rem;
  }
}

/* Loading animation for large images */
#lightbox.loading .lightbox-content {
  opacity: 0.5;
}

/* Dark mode specific adjustments */
body.dark #lightbox {
  background-color: rgba(0, 0, 0, 0.98);
}

body.dark .lightbox-caption {
  background: rgba(22, 27, 34, 0.9);
}
CSS

# Update the default layout to include the lightbox script
sed -i '' '/<\/body>/i\
  <script src="{{ "/assets/js/lightbox.js" | relative_url }}"></script>' _layouts/default.html

echo "✅ Lightbox feature added!"
echo ""
echo "📝 How to use:"
echo "1. Any image in your posts will now be clickable"
echo "2. Click an image to open it in fullscreen"
echo "3. Click the X, press ESC, or click outside to close"
echo "4. Images will show their alt text as captions"
echo ""
echo "Rebuilding site..."
bundle exec jekyll build
bundle exec jekyll serve
