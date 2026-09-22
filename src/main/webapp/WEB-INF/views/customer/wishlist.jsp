<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Wishlist" %>
<%@ page import="com.gruhu.model.Product" %>

<%
    List<Wishlist> wishlistItems = (List<Wishlist>) request.getAttribute("wishlistItems");
    request.setAttribute("extraCss", "product.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="catalog-page">
    <div class="catalog-header">
        <div class="catalog-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <i class="fa-solid fa-chevron-right"></i>
            <span>My Wishlist</span>
        </div>

        <h1 class="catalog-title">Curated Wishlist</h1>
        <p class="catalog-desc">
            Your privately saved pieces. Return anytime to review dimensions or add directly to your atelier bag.
        </p>
    </div>

    <% if (wishlistItems != null && !wishlistItems.isEmpty()) { %>
        <div class="product-grid" style="grid-template-columns: repeat(4, 1fr);">
            <% for (Wishlist item : wishlistItems) {
                Product p = item.getProduct();
                if (p != null) { %>
                <div class="product-card">
                    <div class="product-image-wrap">
                        <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>">
                            <img src="<%= p.getPrimaryImageUrl() != null ? p.getPrimaryImageUrl() : "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80" %>" 
                                 alt="<%= p.getProductName() %>">
                        </a>

                        <div class="product-card-actions">
                            <form action="${pageContext.request.contextPath}/wishlist" method="post">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                <button type="submit" class="btn-action-wishlist active" title="Remove from Wishlist">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="product-card-info">
                        <h3 class="product-card-title">
                            <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>">
                                <%= p.getProductName() %>
                            </a>
                        </h3>

                        <div class="product-card-price-row">
                            <span class="price-current">&#8377;<%= String.format("%,.0f", p.getDiscountedPrice()) %></span>
                            <% if (p.hasDiscount()) { %>
                                <span class="price-original">&#8377;<%= String.format("%,.0f", p.getPrice()) %></span>
                            <% } %>
                        </div>

                        <form action="${pageContext.request.contextPath}/cart" method="post" class="quick-add-form">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn-quick-add" <%= !p.isInStock() ? "disabled" : "" %>>
                                <i class="fa-solid fa-bag-shopping"></i>
                                <span><%= p.isInStock() ? "Move to Bag" : "Out of Stock" %></span>
                            </button>
                        </form>
                    </div>
                </div>
            <%  }
               } %>
        </div>
    <% } else { %>
        <div style="text-align: center; padding: 100px 20px; background: #fff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm);">
            <i class="fa-regular fa-heart" style="font-size: 3rem; color: var(--border-strong); margin-bottom: 20px;"></i>
            <h3 style="font-family: var(--font-serif); font-size: 2rem; margin-bottom: 12px;">Your Wishlist is Empty</h3>
            <p style="color: var(--text-muted); margin-bottom: 28px;">
                Save items you are interested in while exploring our architectural furniture and lighting collections.
            </p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Explore Collections</a>
        </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
