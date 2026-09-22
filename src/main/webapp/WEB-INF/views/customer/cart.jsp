<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gruhu.model.Cart" %>
<%@ page import="com.gruhu.model.CartItem" %>
<%@ page import="com.gruhu.model.Product" %>
<%@ page import="java.math.BigDecimal" %>

<%
    Cart cart = (Cart) request.getAttribute("cart");
    String cartError = (String) session.getAttribute("cartError");
    if (cartError != null) session.removeAttribute("cartError");

    BigDecimal subtotal = (cart != null) ? cart.getTotalAmount() : BigDecimal.ZERO;
    boolean isFreeDelivery = true;
    BigDecimal shipping = BigDecimal.ZERO;
    BigDecimal grandTotal = subtotal;
    request.setAttribute("extraCss", "cart.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="cart-page">
    <div class="catalog-header">
        <div class="catalog-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <i class="fa-solid fa-chevron-right"></i>
            <span>Atelier Shopping Bag</span>
        </div>
        <h1 class="catalog-title">Your Atelier Bag</h1>
    </div>

    <% if (cartError != null) { %>
        <div class="alert alert-danger" style="margin-bottom: 24px;">
            <i class="fa-solid fa-circle-exclamation"></i> <span><%= cartError %></span>
        </div>
    <% } %>

    <% if (cart != null && !cart.isEmpty()) { %>
        <div class="cart-layout">

            <!-- Cart Items List Panel -->
            <div class="cart-items-panel">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding-bottom: 14px; border-bottom: 1px solid var(--border-subtle);">
                    <h3 style="font-family: var(--font-serif); font-size: 1.3rem;">Selected Objects (<%= cart.getTotalQuantity() %>)</h3>
                    <form action="${pageContext.request.contextPath}/cart" method="post" onsubmit="return confirm('Empty your shopping bag?');">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" style="background: none; border: none; font-size: 0.82rem; color: var(--status-danger); cursor: pointer;">
                            <i class="fa-solid fa-trash-can"></i> Clear Bag
                        </button>
                    </form>
                </div>

                <% for (CartItem item : cart.getItems()) {
                    Product p = item.getProduct();
                    if (p != null) { %>
                    <div class="cart-item-row">
                        <div class="cart-item-image">
                            <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>">
                                <img src="<%= p.getPrimaryImageUrl() != null ? p.getPrimaryImageUrl() : "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80" %>" 
                                     alt="<%= p.getProductName() %>">
                            </a>
                        </div>

                        <div class="cart-item-details">
                            <h4>
                                <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>">
                                    <%= p.getProductName() %>
                                </a>
                            </h4>
                            <div class="cart-item-price">
                                &#8377;<%= String.format("%,.0f", p.getDiscountedPrice()) %>
                            </div>

                            <div class="cart-item-controls">
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="display: flex; align-items: center;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                    
                                    <div class="qty-spinner" style="height: 38px;">
                                        <button type="button" class="qty-btn" style="height: 38px; width: 34px;" 
                                                onclick="submitQtyChange(this.form, <%= item.getQuantity() - 1 %>)">&minus;</button>
                                        <input type="text" readonly value="<%= item.getQuantity() %>" class="qty-input" style="height: 38px; width: 38px; font-size: 0.9rem;">
                                        <button type="button" class="qty-btn" style="height: 38px; width: 34px;" 
                                                onclick="submitQtyChange(this.form, <%= item.getQuantity() + 1 %>)">&plus;</button>
                                    </div>
                                    <input type="hidden" name="quantity" value="<%= item.getQuantity() %>">
                                </form>

                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                    <button type="submit" class="btn-remove-item">
                                        <i class="fa-solid fa-trash-can"></i> Remove
                                    </button>
                                </form>
                            </div>
                        </div>

                        <div class="cart-item-total">
                            <span class="line-subtotal">&#8377;<%= String.format("%,.0f", item.getSubtotal()) %></span>
                        </div>
                    </div>
                <%  }
                   } %>
            </div>

            <!-- Summary Panel -->
            <div class="cart-summary-box">
                <h3 class="summary-title">Order Summary</h3>

                <div class="summary-row">
                    <span>Objects Subtotal</span>
                    <strong>&#8377;<%= String.format("%,.0f", subtotal) %></strong>
                </div>

                <div class="summary-row">
                    <span>White Glove Assembly & Delivery</span>
                    <span>
                        <strong style="color: var(--status-success);">FREE</strong>
                    </span>
                </div>

                <div class="summary-row total-row">
                    <span>Estimated Total</span>
                    <span>&#8377;<%= String.format("%,.0f", grandTotal) %></span>
                </div>

                <div style="margin-top: 28px;">
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-block btn-lg" style="gap: 10px;">
                        <span>Proceed to Checkout</span>
                        <i class="fa-solid fa-arrow-right"></i>
                    </a>

                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-block" style="margin-top: 12px;">
                        <span>Continue Browsing Catalog</span>
                    </a>
                </div>

                <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid var(--border-subtle); font-size: 0.82rem; color: var(--text-muted); display: flex; flex-direction: column; gap: 8px;">
                    <div><i class="fa-solid fa-shield-halved" style="color: var(--accent-amber); margin-right: 6px;"></i> 256-bit Encrypted Bank Grade Checkout</div>
                    <div><i class="fa-solid fa-truck" style="color: var(--accent-amber); margin-right: 6px;"></i> Delivered with protective wooden crating</div>
                </div>
            </div>

        </div>
    <% } else { %>
        <div style="text-align: center; padding: 100px 20px; background: #fff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm);">
            <i class="fa-solid fa-bag-shopping" style="font-size: 3.5rem; color: var(--border-strong); margin-bottom: 20px;"></i>
            <h3 style="font-family: var(--font-serif); font-size: 2.2rem; margin-bottom: 12px;">Your Atelier Bag is Empty</h3>
            <p style="color: var(--text-muted); margin-bottom: 30px; max-width: 440px; margin-left: auto; margin-right: auto;">
                Explore our curated collections of beds, sculpted chairs, lamps, and woven textiles to discover pieces for your home.
            </p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg">Explore All Collections</a>
        </div>
    <% } %>
</main>

<script>
    function submitQtyChange(form, newQty) {
        if (newQty < 1) {
            if (confirm('Remove this item from your bag?')) {
                form.querySelector('input[name="quantity"]').value = 0;
                form.submit();
            }
        } else {
            form.querySelector('input[name="quantity"]').value = newQty;
            form.submit();
        }
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
