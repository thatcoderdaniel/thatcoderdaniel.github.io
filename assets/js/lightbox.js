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
