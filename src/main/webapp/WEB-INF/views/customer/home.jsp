<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Category" %>
<%@ page import="com.gruhu.model.Product" %>

<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Product> featuredProducts = (List<Product>) request.getAttribute("featuredProducts");
    List<Product> homeProducts = (List<Product>) request.getAttribute("homeProducts");
    if (homeProducts == null || homeProducts.isEmpty()) {
        homeProducts = featuredProducts;
    }
    request.setAttribute("extraCss", "home.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="home-main">

    <!-- Full-Width Luxury Hero Banner with Video & Background Image Overlay -->
    <section class="hero-section hero-banner-fullscreen">
        <!-- Background Media Container: Looping Ambient Video & High-Res Poster Fallback -->
        <div class="hero-media-wrapper">
            <video class="hero-video-bg" id="heroBgVideo" autoplay muted loop playsinline
                   poster="https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=2000&q=88">
                <source src="${pageContext.request.contextPath}/assets/videos/hero-nordic.webm" type="video/webm">
                <source src="https://upload.wikimedia.org/wikipedia/commons/transcoded/e/e2/Trollstigen_Visitor_Centre.webm/Trollstigen_Visitor_Centre.webm.720p.vp9.webm" type="video/webm">
            </video>
            <!-- Fallback image layer ensures instant visual grounding -->
            <img src="https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=2000&q=88" 
                 alt="Gruhu Scandinavian Atelier Interior" 
                 class="hero-img-fallback">
        </div>

        <!-- Architectural Scrim / Gradient Overlay -->
        <div class="hero-scrim-overlay"></div>

        <!-- Overlaid Content Container -->
        <div class="hero-overlay-container">
            <div class="hero-overlay-content">
                <!-- Eyebrow Pill -->
                <div class="hero-eyebrow-pill">
                    <span class="eyebrow-dot"></span>
                    <span>Edition 2026 &bull; Scandinavian Living</span>
                </div>

                <!-- Primary Headline (Requested Replacement) -->
                <h1 class="hero-title hero-title-overlay">
                    Tailored to live in union with its atmosphere
                </h1>

                <!-- Architectural Description -->
                <p class="hero-desc hero-desc-overlay">
                    Rooted in Nordic serenity, honest joinery, and tactile materiality. Discover sculpted oak furniture, low-slung boucl&eacute; sofas, washi paper luminaires, and Belgian flax linens.
                </p>

                <!-- Actions: Explore Catalog & Consult AI Stylist -->
                <div class="hero-actions hero-actions-overlay">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-hero-primary">
                        <span>Explore Catalog</span>
                        <i class="fa-solid fa-arrow-right"></i>
                    </a>
                    <button type="button" class="btn btn-hero-secondary" onclick="if(window.toggleAiDrawer){window.toggleAiDrawer();}else{document.getElementById('aiStylistDrawer')?.classList.add('open');}">
                        <i class="fa-solid fa-wand-magic-sparkles"></i>
                        <span>Consult AI Stylist</span>
                    </button>
                </div>

                <!-- Overlaid Frosted Glass Highlights Ribbon -->
                <div class="hero-highlights hero-highlights-glass">
                    <div class="highlight-item">
                        <strong>100%</strong>
                        <span>FSC Hardwood</span>
                    </div>
                    <div class="highlight-separator"></div>
                    <div class="highlight-item">
                        <strong>10-Year</strong>
                        <span>Woodwork Warranty</span>
                    </div>
                    <div class="highlight-separator"></div>
                    <div class="highlight-item">
                        <strong>Free</strong>
                        <span>White-Glove Setup</span>
                    </div>
                    <div class="highlight-separator"></div>
                    <div class="highlight-item">
                        <strong>Pan-India</strong>
                        <span>Insured Transport</span>
                    </div>
                </div>
            </div>

            <!-- Floating Curated Space Badge -->
            <div class="hero-curated-badge-glass">
                <i class="fa-solid fa-compass-drafting"></i>
                <div>
                    <span class="curated-badge-label">Curated Space</span>
                    <span class="curated-badge-title">The Koto Living Series</span>
                </div>
            </div>

            <!-- Video Play / Pause Ambient Control -->
            <button type="button" class="hero-video-ctrl-btn" id="heroVideoCtrlBtn" aria-label="Toggle Background Video">
                <i class="fa-solid fa-pause"></i>
                <span class="video-ctrl-text">Motion</span>
            </button>
        </div>
    </section>

    <!-- "What are you looking for?" Horizontal Cards Slider (Reference: Image 2) -->
    <section class="looking-for-section">
        <div class="looking-for-container">
            <div class="looking-for-header">
                <div>
                    <span class="section-subtitle">Curated Categories</span>
                    <h2 class="looking-for-title">What are you looking for?</h2>
                </div>
            </div>

            <div class="carousel-outer">
                <button type="button" class="carousel-arrow prev-arrow" id="carouselPrevBtn" aria-label="Previous">
                    <i class="fa-solid fa-chevron-left"></i>
                </button>

                <div class="carousel-track" id="lookingForTrack">
                    <!-- 1. Storage -->
                    <a href="${pageContext.request.contextPath}/products?category=1&subcategory=5" class="slider-cat-card">
                        <div class="slider-cat-img">
                            <img src="https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=600&h=600&q=85" alt="Storage">
                        </div>
                        <span class="slider-cat-label">STORAGE</span>
                    </a>

                    <!-- 2. Beds -->
                    <a href="${pageContext.request.contextPath}/products?category=1&subcategory=3" class="slider-cat-card">
                        <div class="slider-cat-img">
                            <img src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&h=600&q=85" alt="Beds">
                        </div>
                        <span class="slider-cat-label">BEDS</span>
                    </a>

                    <!-- 3. Dining Tables -->
                    <a href="${pageContext.request.contextPath}/products?category=1&subcategory=4" class="slider-cat-card">
                        <div class="slider-cat-img">
                            <img src="https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=600&h=600&q=85" alt="Dining Tables">
                        </div>
                        <span class="slider-cat-label">DINING TABLES</span>
                    </a>

                    <!-- 4. Armchairs -->
                    <a href="${pageContext.request.contextPath}/products?category=1&subcategory=2" class="slider-cat-card">
                        <div class="slider-cat-img">
                            <img src="https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=600&h=600&q=85" alt="Armchairs">
                        </div>
                        <span class="slider-cat-label">ARMCHAIRS</span>
                    </a>

                    <!-- 5. Sofas -->
                    <a href="${pageContext.request.contextPath}/products?category=1&subcategory=1" class="slider-cat-card">
                        <div class="slider-cat-img">
                            <img src="https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=600&h=600&q=85" alt="Sofas">
                        </div>
                        <span class="slider-cat-label">SOFAS</span>
                    </a>

                    <!-- 6. Coffee Tables -->
                    <a href="${pageContext.request.contextPath}/products?category=1&subcategory=4" class="slider-cat-card">
                        <div class="slider-cat-img">
                            <img src="https://images.unsplash.com/photo-1530018607912-eff2daa1bac4?auto=format&fit=crop&w=600&h=600&q=85" alt="Coffee Tables">
                        </div>
                        <span class="slider-cat-label">COFFEE TABLES</span>
                    </a>

                    <!-- 7. Lights -->
                    <a href="${pageContext.request.contextPath}/products?category=2" class="slider-cat-card">
                        <div class="slider-cat-img">
                            <img src="https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=600&h=600&q=85" alt="Lights">
                        </div>
                        <span class="slider-cat-label">LIGHTS</span>
                    </a>

                    <!-- 8. Mirrors -->
                    <a href="${pageContext.request.contextPath}/products?category=3" class="slider-cat-card">
                        <div class="slider-cat-img">
                            <img src="https://images.unsplash.com/photo-1618220179428-22790b461013?auto=format&fit=crop&w=600&h=600&q=85" alt="Mirrors">
                        </div>
                        <span class="slider-cat-label">MIRRORS</span>
                    </a>

                    <!-- 9. Accessories -->
                    <a href="${pageContext.request.contextPath}/products?category=4" class="slider-cat-card">
                        <div class="slider-cat-img">
                            <img src="https://images.unsplash.com/photo-1581783342308-f792dbdd27c5?auto=format&fit=crop&w=600&h=600&q=85" alt="Accessories">
                        </div>
                        <span class="slider-cat-label">ACCESSORIES</span>
                    </a>
                </div>

                <button type="button" class="carousel-arrow next-arrow" id="carouselNextBtn" aria-label="Next">
                    <i class="fa-solid fa-chevron-right"></i>
                </button>
            </div>

            <!-- Progress Bar Indicator (Image 2) -->
            <div class="slider-progress-wrap">
                <div class="slider-progress-bar">
                    <div class="slider-progress-thumb" id="sliderProgressThumb"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- Curated Environments: Shop by Space -->
    <section class="home-section categories-showcase">
        <div class="section-container">
            <div class="section-header">
                <div>
                    <span class="section-subtitle">Architectural Environments</span>
                    <h2 class="section-title">Shop by Space</h2>
                </div>
                <a href="${pageContext.request.contextPath}/products" class="view-all-link">
                    <span>View All Collections</span>
                    <i class="fa-solid fa-arrow-right-long"></i>
                </a>
            </div>

            <div class="category-grid" style="grid-template-columns: repeat(4, 1fr);">
                <a href="${pageContext.request.contextPath}/products?room=living_room" class="category-card">
                    <div class="category-image-wrap">
                        <img src="https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=800&q=80" alt="Living Room">
                    </div>
                    <div class="category-content">
                        <span class="category-count">Living Room</span>
                        <h3 class="category-name">Living Room Sanctuary</h3>
                        <p class="category-desc">Architectural sofas, travertine coffee tables, lounge armchairs and sculptural ambient lighting.</p>
                        <span class="category-explore-link">Explore Living Room <i class="fa-solid fa-arrow-right"></i></span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/products?room=bedroom" class="category-card">
                    <div class="category-image-wrap">
                        <img src="https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&w=800&q=80" alt="Bedroom">
                    </div>
                    <div class="category-content">
                        <span class="category-count">Bedroom</span>
                        <h3 class="category-name">Restful Bedroom Atelier</h3>
                        <p class="category-desc">Solid European oak platform beds, mitered dressers, nightstands and cathedral full length mirrors.</p>
                        <span class="category-explore-link">Explore Bedroom <i class="fa-solid fa-arrow-right"></i></span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/products?room=dining_room" class="category-card">
                    <div class="category-image-wrap">
                        <img src="https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=800&q=80" alt="Dining Room">
                    </div>
                    <div class="category-content">
                        <span class="category-count">Dining Room</span>
                        <h3 class="category-name">Sculpted Dining Suite</h3>
                        <p class="category-desc">Solid wood communal dining tables, ergonomic dining chairs, credenzas and ceramic vessels.</p>
                        <span class="category-explore-link">Explore Dining <i class="fa-solid fa-arrow-right"></i></span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/products?room=hall" class="category-card">
                    <div class="category-image-wrap">
                        <img src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80" alt="Hall Area">
                    </div>
                    <div class="category-content">
                        <span class="category-count">Hall Area</span>
                        <h3 class="category-name">Grand Hall Collection</h3>
                        <p class="category-desc">Statement console credenzas, entryway mirrors, architectural wall clocks and iconic accents.</p>
                        <span class="category-explore-link">Explore Hall Area <i class="fa-solid fa-arrow-right"></i></span>
                    </div>
                </a>
            </div>
        </div>
    </section>

    <!-- Value Assurance Banner -->
    <section class="trust-banner-section">
        <div class="trust-container">
            <div class="trust-card">
                <i class="fa-solid fa-truck-fast"></i>
                <div>
                    <h4>Pan-India Delivery</h4>
                    <p>Free white-glove transport on every curated order.</p>
                </div>
            </div>

            <div class="trust-card">
                <i class="fa-solid fa-rotate-left"></i>
                <div>
                    <h4>30-Day In-Home Trial</h4>
                    <p>Experience pieces in your personal light with zero return fees.</p>
                </div>
            </div>

            <div class="trust-card">
                <i class="fa-solid fa-gem"></i>
                <div>
                    <h4>Architectural Authenticity</h4>
                    <p>Original certified designs direct from master Nordic workshops.</p>
                </div>
            </div>

            <div class="trust-card">
                <i class="fa-solid fa-headset"></i>
                <div>
                    <h4>Design Concierge</h4>
                    <p>Complimentary interior advice and finish sampling by phone.</p>
                </div>
            </div>
        </div>
    </section>

</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>