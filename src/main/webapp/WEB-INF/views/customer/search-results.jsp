<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Product" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    String keyword = (String) request.getAttribute("keyword");
    request.setAttribute("extraCss", "product.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="catalog-page">
    <div class="catalog-header">
        <div class="catalog-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <i class="fa-solid fa-chevron-right"></i>
            <span>Search Results</span>
        </div>

        <h1 class="catalog-title">
            Search: &ldquo;<%= keyword != null ? keyword : "" %>&rdquo;
        </h1>
        <p class="catalog-desc">
            Found <strong><%= products != null ? products.size() : 0 %></strong> matching interior objects in our atelier catalog.
        </p>
    </div>

    <% if (products != null && !products.isEmpty()) { %>
        <div class="product-grid-v2">
            <% for (Product p : products) { %>
                <div class="product-card-v2">
                    <div class="card-v2-image-wrap">
                        <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>" class="card-v2-img-link">
                            <img src="<%= p.getPrimaryImageUrl() != null ? p.getPrimaryImageUrl() : "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80" %>" 
                                 alt="<%= p.getProductName() %>" class="card-v2-img" loading="lazy">
                        </a>

                        <div class="card-v2-badges">
                            <% if (p.hasDiscount()) { %>
                                <span class="badge-v2 badge-discount">-<%= p.getDiscountPercent().intValue() %>%</span>
                            <% } %>
                            <% if (p.isFeatured()) { %>
                                <span class="badge-v2 badge-featured">Atelier</span>
                            <% } %>
                        </div>

                        <form action="${pageContext.request.contextPath}/wishlist" method="post" class="card-v2-wishlist-form">
                            <input type="hidden" name="action" value="toggle">
                            <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                            <button type="submit" class="btn-card-v2-wishlist" title="Save to Wishlist">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </form>
                    </div>

                    <div class="card-v2-info">
                        <div class="card-v2-title-row">
                            <h3 class="card-v2-title">
                                <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>">
                                    <%= p.getProductName() %>
                                </a>
                            </h3>
                            <div class="card-v2-price">
                                <span class="price-val">&#8377;<%= String.format("%,.0f", p.getDiscountedPrice()) %></span>
                                <% if (p.hasDiscount()) { %>
                                    <span class="price-val-orig">&#8377;<%= String.format("%,.0f", p.getPrice()) %></span>
                                <% } %>
                            </div>
                        </div>

                        <div class="card-v2-meta-row">
                            <div class="card-v2-swatches">
                                <span class="swatch-dot dot-terracotta"></span>
                                <span class="swatch-dot dot-slate"></span>
                                <span class="swatch-label">2 Colors</span>
                            </div>
                            <span class="card-v2-material-tag"><%= p.getMaterial() != null ? p.getMaterial() : "Solid Wood" %></span>
                        </div>

                        <div class="card-v2-actions">
                            <form action="${pageContext.request.contextPath}/cart" method="post" class="card-v2-add-form">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn-card-v2-add" <%= !p.isInStock() ? "disabled" : "" %>>
                                    <i class="fa-solid fa-bag-shopping"></i>
                                    <span><%= p.isInStock() ? "Add to Bag" : "Sold Out" %></span>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div style="text-align: center; padding: 100px 20px; background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: 16px;">
            <i class="fa-solid fa-magnifying-glass" style="font-size: 3rem; color: var(--border-strong); margin-bottom: 20px;"></i>
            <h3 style="font-family: var(--font-serif); font-size: 2rem; margin-bottom: 12px; color: var(--dark-espresso);">No Objects Found for &ldquo;<%= keyword != null ? keyword : "" %>&rdquo;</h3>
            <p style="color: var(--text-muted); margin-bottom: 28px; max-width: 480px; margin-left: auto; margin-right: auto;">
                We could not find any products matching your search term. Try searching for &ldquo;sofa&rdquo;, &ldquo;chair&rdquo;, &ldquo;oak&rdquo;, &ldquo;lamp&rdquo;, or &ldquo;linen&rdquo;.
            </p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Browse Complete Catalog</a>
        </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
