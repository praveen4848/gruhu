<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="site-footer">
    <div class="footer-container">
        <!-- Col 1: Brand Manifesto -->
        <div class="footer-col brand-col">
            <a href="${pageContext.request.contextPath}/home" class="footer-logo">
                <img src="${pageContext.request.contextPath}/assets/images/gruhu-logo-circle.png" 
                     alt="Gruhu Monogram" 
                     class="footer-logo-img">
                <span>GRUHU</span>
            </a>
            <p class="brand-desc">
                Gruhu crafts architectural furniture and mindful interior objects inspired by Scandinavian serenity and honest natural materiality. Built to be lived with, cherished, and passed down.
            </p>
            <div class="showroom-info">
                <span><i class="fa-solid fa-location-dot"></i> Studio & Atelier: Rajahmundry, 533102</span>
                <span><i class="fa-solid fa-clock"></i> Tuesday &ndash; Sunday: 10:00 AM &ndash; 8:00 PM (Mondays by appointment)</span>
                <span><i class="fa-solid fa-phone"></i> +91 9989055955</span>
                <span><i class="fa-solid fa-envelope"></i> praveena2z029@gmail.com</span>
            </div>
            <div class="social-links">
                <a href="#" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
                <a href="#" aria-label="Pinterest"><i class="fa-brands fa-pinterest-p"></i></a>
                <a href="#" aria-label="LinkedIn"><i class="fa-brands fa-linkedin-in"></i></a>
            </div>
        </div>

        <!-- Col 2: Collections -->
        <div class="footer-col">
            <h4 class="footer-heading">Collections</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/products?category=1">Furniture</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=2">Lights</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=3">Mirrors</a></li>
                <li><a href="${pageContext.request.contextPath}/products?category=4">Accessories</a></li>
                <li><a href="${pageContext.request.contextPath}/products?room=living_room">Living Room</a></li>
                <li><a href="${pageContext.request.contextPath}/products?room=bedroom">Bedroom Sanctuary</a></li>
            </ul>
        </div>

        <!-- Col 3: Atelier Care -->
        <div class="footer-col">
            <h4 class="footer-heading">Client Services</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/about">About Gruhu Atelier</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Complimentary Design Advice</a></li>
                <li><a href="${pageContext.request.contextPath}/my-orders">Order Tracking & History</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">White Glove Delivery</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/login" class="admin-portal-link" style="color: var(--accent-amber); font-weight: 500;"><i class="fa-solid fa-lock"></i> Curator / Admin Portal</a></li>
            </ul>
        </div>

        <!-- Col 4: Newsletter -->
        <div class="footer-col newsletter-col">
            <h4 class="footer-heading">The Gruhu Circle</h4>
            <p>Subscribe to receive seasonal collection previews, architectural essays, and private client invitations.</p>
            <form class="footer-subscribe-form" onsubmit="event.preventDefault(); alert('Thank you for subscribing to Gruhu Circle.');">
                <input type="email" placeholder="Enter your email" required>
                <button type="submit">Join</button>
            </form>
            <div class="payment-badges">
                <span><i class="fa-brands fa-cc-visa"></i> Visa</span>
                <span><i class="fa-brands fa-cc-mastercard"></i> Mastercard</span>
                <span><i class="fa-solid fa-shield-halved"></i> 256-Bit SSL Encrypted</span>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <div class="bottom-container">
            <p>&copy; <%= java.time.Year.now().getValue() %> Gruhu Atelier Private Limited. All rights reserved.</p>
            <div class="legal-links">
                <a href="#">Privacy Policy</a>
                <span>&bull;</span>
                <a href="#">Terms of Craftsmanship</a>
                <span>&bull;</span>
                <a href="#">Sustainability Report</a>
            </div>
        </div>
    </div>
</footer>

<!-- ==========================================================================
     GRUHU ATELIER — AI SPATIAL STYLIST CONCIERGE & ROOM SCAN HARMONY
     ========================================================================== -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ai-stylist.css?v=1.0">

<!-- 1. Floating Launcher Button -->
<button type="button" class="ai-stylist-trigger-btn" id="aiStylistTriggerBtn" aria-label="Open Atelier AI Spatial Stylist">
    <span class="ai-pulse-dot"></span>
    <i class="fa-solid fa-wand-magic-sparkles ai-icon-sparkle"></i>
    <span>Consult Atelier Stylist</span>
</button>

<!-- 2. Backdrop Overlay -->
<div class="ai-stylist-overlay" id="aiStylistOverlay"></div>

<!-- 3. Slide-Out Concierge Drawer -->
<aside class="ai-stylist-drawer" id="aiStylistDrawer" aria-label="Atelier AI Spatial Stylist Drawer">
    <!-- Header -->
    <div class="ai-drawer-header">
        <div class="ai-header-left">
            <span class="ai-atelier-tag"><i class="fa-solid fa-gem"></i> Gruhu Atelier &bull; Spatial AI</span>
            <h3 class="ai-header-title">Atelier Spatial Stylist</h3>
            <p class="ai-header-subtitle">Scandinavian architectural concierge & room harmony</p>
        </div>
        <button type="button" class="ai-drawer-close-btn" id="aiDrawerCloseBtn" aria-label="Close Stylist">&times;</button>
    </div>

    <!-- Mode Tabs -->
    <div class="ai-mode-tabs">
        <button type="button" class="ai-mode-tab active" data-mode="chat">
            <i class="fa-solid fa-comments"></i> Concierge Consult
        </button>
        <button type="button" class="ai-mode-tab" data-mode="photo">
            <i class="fa-solid fa-camera-retro"></i> Scan My Space
        </button>
    </div>

    <!-- Filters Bar -->
    <div class="ai-filters-bar">
        <div class="ai-filter-group">
            <label class="ai-filter-label" for="aiRoomSelect">Room:</label>
            <select class="ai-filter-select" id="aiRoomSelect">
                <option value="living_room">Living Room</option>
                <option value="bedroom">Bedroom Sanctuary</option>
                <option value="dining">Dining Studio</option>
                <option value="study">Architectural Study</option>
                <option value="hall">Entryway & Hall</option>
            </select>
        </div>
        <div class="ai-filter-group">
            <label class="ai-filter-label" for="aiBudgetSelect">Budget:</label>
            <select class="ai-filter-select" id="aiBudgetSelect">
                <option value="0">Flexible / Curated</option>
                <option value="40000">Under ₹40,000</option>
                <option value="75000">Under ₹75,000</option>
                <option value="150000">Under ₹1,50,000</option>
            </select>
        </div>
    </div>

    <!-- Photo Dropzone Section (for Scan My Space) -->
    <div class="ai-photo-dropzone-section" id="aiPhotoDropzoneSection">
        <div class="ai-dropzone-box" id="aiDropzoneBox">
            <i class="fa-solid fa-cloud-arrow-up"></i>
            <div class="ai-dropzone-title">Upload or Drop Room Photo</div>
            <p class="ai-dropzone-desc">Instant spatial lighting, volume & color harmony analysis</p>
            <input type="file" id="aiFileInput" class="ai-file-input" accept="image/*">
        </div>
        <div class="ai-scan-preview-box" id="aiScanPreviewBox">
            <img id="aiPreviewImage" src="" alt="Space Preview">
            <div class="ai-scan-laser-line"></div>
            <div class="ai-scan-status-badge">
                <i class="fa-solid fa-circle-notch fa-spin"></i> Analyzing daylight & materials...
            </div>
        </div>
    </div>

    <!-- Inspiration Prompt Chips -->
    <div class="ai-prompt-chips">
        <button type="button" class="ai-chip" data-prompt="Warm Japandi living room with solid oak and textural bouclé">✨ Warm Japandi Living</button>
        <button type="button" class="ai-chip" data-prompt="Serene bedroom sanctuary with low-slung platform styling under ₹50,000">🛏️ Serene Bedroom</button>
        <button type="button" class="ai-chip" data-prompt="Sculptural dining studio with diffuse pendant illumination">🍽️ Dining Studio</button>
        <button type="button" class="ai-chip" data-prompt="Tactile architectural reading corner with arch brass mirror">🪞 Reading Nook</button>
    </div>

    <!-- Chat & Stream Container -->
    <div class="ai-stream-container" id="aiStreamContainer">
        <!-- Initial Welcome Message -->
        <div class="ai-msg ai-msg-stylist">
            <div class="ai-avatar ai-avatar-stylist"><i class="fa-solid fa-wand-magic-sparkles"></i></div>
            <div class="ai-msg-bubble">
                <p style="margin: 0 0 6px; font-weight: 600; font-family: 'Playfair Display', serif; font-size: 1.05rem;">
                    Welcome to Gruhu Atelier Spatial Consultation.
                </p>
                <p style="margin: 0; font-size: 0.84rem; color: #555047;">
                    I am your Atelier AI Spatial Stylist. Upload a photo of your room to harmonize lighting and proportions, or share your interior vision below. I will curate a balanced, authentic Scandinavian ensemble tailored specifically to your home.
                </p>
            </div>
        </div>

        <!-- Typing Indicator -->
        <div class="ai-typing-indicator" id="aiTypingIndicator">
            <div class="ai-typing-dot"></div>
            <div class="ai-typing-dot"></div>
            <div class="ai-typing-dot"></div>
            <span>Atelier Stylist is analyzing spatial lighting & materials...</span>
        </div>
    </div>

    <!-- Footer Input Bar -->
    <div class="ai-drawer-footer">
        <button type="button" class="ai-upload-quick-btn" id="aiQuickUploadBtn" title="Upload Room Photo">
            <i class="fa-solid fa-camera"></i>
        </button>
        <form class="ai-input-form" id="aiInputForm">
            <input type="text" class="ai-text-input" id="aiTextInput" placeholder="Describe your room or styling wish..." autocomplete="off">
            <button type="submit" class="ai-send-btn" aria-label="Send to Stylist">
                <i class="fa-solid fa-arrow-up"></i>
            </button>
        </form>
    </div>
</aside>

<!-- Toast Notification -->
<div class="ai-toast-notification" id="aiToast"></div>

<!-- Global Scripts -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/ai-stylist.js?v=1.0"></script>
</body>
</html>