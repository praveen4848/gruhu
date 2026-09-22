<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Product" %>
<%@ page import="com.gruhu.model.ProductImage" %>

<%
    Product product = (Product) request.getAttribute("product");
    List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");
    request.setAttribute("extraCss", "product.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="product-details-page">

    <!-- Breadcrumb -->
    <div class="catalog-breadcrumb" style="margin-bottom: 32px;">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <i class="fa-solid fa-chevron-right"></i>
        <a href="${pageContext.request.contextPath}/products">Catalog</a>
        <% if (product.getCategoryName() != null) { %>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="${pageContext.request.contextPath}/products?category=<%= product.getCategoryId() %>"><%= product.getCategoryName() %></a>
        <% } %>
        <i class="fa-solid fa-chevron-right"></i>
        <span><%= product.getProductName() %></span>
    </div>

    <!-- Main Detail Section -->
    <div class="product-details-main">

        <!-- Image Gallery -->
        <div class="product-gallery">
            <div class="main-image-frame">
                <img id="mainProductImage" 
                     src="<%= product.getPrimaryImageUrl() != null ? product.getPrimaryImageUrl() : "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=85" %>" 
                     alt="<%= product.getProductName() %>">
            </div>

            <% if (product.getImages() != null && product.getImages().size() > 1) { 
                String[] viewTitles = {"Studio Full View", "Front Elevation", "Material Texture Detail", "Joinery & Craft Detail", "Ambient Room Perspective"};
            %>
                <div class="gallery-thumbs">
                    <% for (int i = 0; i < product.getImages().size(); i++) {
                        ProductImage img = product.getImages().get(i); 
                        String viewName = i < viewTitles.length ? viewTitles[i] : ("View " + (i + 1));
                    %>
                        <div class="thumb-item <%= img.isPrimary() || i == 0 ? "active" : "" %>" 
                             title="<%= viewName %> — <%= product.getProductName() %>"
                             onclick="changeMainImage('<%= img.getImagePath() %>', this)">
                            <img src="<%= img.getImagePath() %>" alt="<%= viewName %>">
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <!-- Product Summary & Actions -->
        <div class="product-summary">
            <div class="product-meta-top">
                <span class="product-brand"><%= product.getBrand() != null ? product.getBrand() : "Gruhu Atelier" %></span>
                <span class="badge <%= product.isInStock() ? "badge-stock-in" : "badge-stock-out" %>">
                    <%= product.isInStock() ? "In Stock (" + product.getStockQuantity() + " Units)" : "Sold Out" %>
                </span>
                <% if (product.hasDiscount()) { %>
                    <span class="badge badge-discount">Save <%= product.getDiscountPercent().intValue() %>%</span>
                <% } %>
            </div>

            <h1 class="product-title-large"><%= product.getProductName() %></h1>

            <div class="product-rating-row">
                <div style="color: #f59e0b;">
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star-half-stroke"></i>
                </div>
                <strong><%= product.getRating() %></strong>
                <span>(34 Verified Architect Reviews)</span>
            </div>

            <div class="product-price-box">
                <span class="price-main">&#8377;<%= String.format("%,.0f", product.getDiscountedPrice()) %></span>
                <% if (product.hasDiscount()) { %>
                    <span class="price-strike">&#8377;<%= String.format("%,.0f", product.getPrice()) %></span>
                <% } %>
            </div>

            <p class="product-desc-lead"><%= product.getDescription() %></p>

            <!-- Key Attributes Table -->
            <div class="product-attributes-table">
                <div class="attr-item">
                    <span class="attr-label">Primary Material</span>
                    <span class="attr-val"><%= product.getMaterial() != null ? product.getMaterial() : "European Solid Hardwood" %></span>
                </div>
                <div class="attr-item">
                    <span class="attr-label">Color / Finish</span>
                    <span class="attr-val"><%= product.getColor() != null ? product.getColor() : "Natural Matte Oil" %></span>
                </div>
                <div class="attr-item">
                    <span class="attr-label">Dimensions</span>
                    <span class="attr-val"><%= product.getDimensions() != null ? product.getDimensions() : "Standard Atelier Size" %></span>
                </div>
                <div class="attr-item">
                    <span class="attr-label">Design Aesthetic</span>
                    <span class="attr-val"><%= product.getStyle() != null ? product.getStyle() : "Scandinavian Modern" %></span>
                </div>
                <div class="attr-item">
                    <span class="attr-label">Suitable Spaces</span>
                    <span class="attr-val"><%= product.getRooms() != null ? product.getRooms().replace("_", " ").replace(",", " • ") : "Living Room • Hall" %></span>
                </div>
            </div>

            <!-- Add to Cart & Wishlist Form -->
            <form action="${pageContext.request.contextPath}/cart" method="post" class="purchase-form">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="productId" value="<%= product.getProductId() %>">

                <div class="quantity-row">
                    <div class="qty-spinner">
                        <button type="button" class="qty-btn" onclick="decrementQty()">&minus;</button>
                        <input type="number" id="detailQtyInput" name="quantity" value="1" min="1" max="<%= product.getStockQuantity() %>" class="qty-input">
                        <button type="button" class="qty-btn" onclick="incrementQty(<%= product.getStockQuantity() %>)">&plus;</button>
                    </div>

                    <button type="submit" class="btn btn-primary btn-add-cart-large" <%= !product.isInStock() ? "disabled" : "" %>>
                        <i class="fa-solid fa-bag-shopping"></i>
                        <span><%= product.isInStock() ? "Add to Atelier Bag" : "Currently Unavailable" %></span>
                    </button>
                </div>
            </form>

            <form action="${pageContext.request.contextPath}/wishlist" method="post" style="display: inline-block;">
                <input type="hidden" name="action" value="toggle">
                <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                <button type="submit" class="btn btn-outline" style="width: 100%; gap: 10px;">
                    <i class="fa-regular fa-heart"></i>
                    <span>Save to Private Wishlist</span>
                </button>
            </form>

            <!-- Delivery Guarantees -->
            <div class="product-perks-list">
                <div class="perk-item" style="font-weight: 600; color: var(--dark-espresso);">
                    <i class="fa-solid fa-truck-fast" style="color: var(--accent-amber);"></i>
                    <span><%= product.getDeliveryOption() %></span>
                </div>
                <div class="perk-item">
                    <i class="fa-solid fa-truck-ramp-box"></i>
                    <span>White-Glove In-Home Placement & packaging removal included across India.</span>
                </div>
                <div class="perk-item">
                    <i class="fa-solid fa-shield-halved"></i>
                    <span>10-Year Craftsmanship Structural Guarantee against wood fatigue.</span>
                </div>
                <div class="perk-item">
                    <i class="fa-solid fa-rotate-left"></i>
                    <span>Complimentary 30-Day in-home trial period with hassle-free returns.</span>
                </div>
            </div>

        </div>
    </div>

    <!-- Related Products -->
    <% if (relatedProducts != null && !relatedProducts.isEmpty()) { %>
        <section class="related-products-section" style="padding-top: 50px; border-top: 1px solid var(--border-subtle);">
            <div class="section-header">
                <div>
                    <span class="section-subtitle">Complementary Styling</span>
                    <h2 class="section-title" style="font-size: 2rem;">Frequently Paired Pieces</h2>
                </div>
            </div>

            <div class="product-grid" style="grid-template-columns: repeat(4, 1fr);">
                <% for (Product rp : relatedProducts) { %>
                    <div class="product-card">
                        <div class="product-image-wrap">
                            <a href="${pageContext.request.contextPath}/product-details?id=<%= rp.getProductId() %>">
                                <img src="<%= rp.getPrimaryImageUrl() != null ? rp.getPrimaryImageUrl() : "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80" %>" 
                                     alt="<%= rp.getProductName() %>">
                            </a>
                        </div>
                        <div class="product-card-info">
                            <span class="product-card-category"><%= rp.getCategoryName() != null ? rp.getCategoryName() : "Interior" %></span>
                            <h3 class="product-card-title">
                                <a href="${pageContext.request.contextPath}/product-details?id=<%= rp.getProductId() %>">
                                    <%= rp.getProductName() %>
                                </a>
                            </h3>
                            <div class="product-card-price-row">
                                <span class="price-current">&#8377;<%= String.format("%,.0f", rp.getDiscountedPrice()) %></span>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </section>
    <% } %>

</main>

<script>
    function changeMainImage(src, element) {
        document.getElementById('mainProductImage').src = src;
        document.querySelectorAll('.thumb-item').forEach(el => el.classList.remove('active'));
        element.classList.add('active');
    }

    function incrementQty(max) {
        const input = document.getElementById('detailQtyInput');
        let current = parseInt(input.value) || 1;
        if (current < max) {
            input.value = current + 1;
        }
    }

    function decrementQty() {
        const input = document.getElementById('detailQtyInput');
        let current = parseInt(input.value) || 1;
        if (current > 1) {
            input.value = current - 1;
        }
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
