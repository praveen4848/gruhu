<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Order" %>
<%@ page import="com.gruhu.model.OrderItem" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    request.setAttribute("extraCss", "auth.css,cart.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="account-page">
    <div class="account-header">
        <div>
            <span class="auth-tag">Client Account</span>
            <h1 style="font-family: var(--font-serif); font-size: 2.4rem; color: var(--dark-espresso); margin-top: 4px;">My Order History</h1>
        </div>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-sm">
            <span>Browse Catalog</span>
        </a>
    </div>

    <!-- Account Navigation Tabs -->
    <div class="account-tabs-nav">
        <a href="${pageContext.request.contextPath}/profile" class="account-tab-item">
            <i class="fa-regular fa-id-card"></i> Personal Profile
        </a>
        <a href="${pageContext.request.contextPath}/addresses" class="account-tab-item">
            <i class="fa-solid fa-location-dot"></i> Delivery Addresses
        </a>
        <a href="${pageContext.request.contextPath}/my-orders" class="account-tab-item active">
            <i class="fa-solid fa-box-archive"></i> Order History
        </a>
        <a href="${pageContext.request.contextPath}/wishlist" class="account-tab-item">
            <i class="fa-regular fa-heart"></i> Saved Wishlist
        </a>
    </div>

    <!-- Orders List -->
    <% if (orders != null && !orders.isEmpty()) { %>
        <div style="display: flex; flex-direction: column; gap: 24px;">
            <% for (Order o : orders) { %>
                <div style="background: #ffffff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); padding: 28px; transition: var(--transition-smooth);">
                    <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 16px; border-bottom: 1px solid var(--border-subtle); margin-bottom: 18px; flex-wrap: wrap; gap: 12px;">
                        <div>
                            <span style="font-family: var(--font-serif); font-size: 1.25rem; font-weight: 700; color: var(--dark-espresso);">
                                Order #<%= o.getOrderId() %>
                            </span>
                            <span style="color: var(--text-muted); font-size: 0.85rem; margin-left: 10px;">
                                Placed on <%= o.getOrderDate() != null ? o.getOrderDate().toString().substring(0, 10) : "Recently" %>
                            </span>
                        </div>

                        <div style="display: flex; align-items: center; gap: 12px;">
                            <span class="badge" style="background: var(--bg-sand-dark); color: var(--dark-espresso); font-weight: 700;">
                                <%= o.getOrderStatus() %>
                            </span>
                            <span class="badge badge-featured">
                                <%= o.getPaymentStatus() %>
                            </span>
                        </div>
                    </div>

                    <!-- Items snapshot -->
                    <div style="margin-bottom: 18px;">
                        <% if (o.getItems() != null) {
                            for (OrderItem item : o.getItems()) { %>
                                <div style="display: flex; justify-content: space-between; font-size: 0.92rem; color: var(--text-secondary); margin-bottom: 6px;">
                                    <span>&bull; <%= item.getProductName() %> (&times;<%= item.getQuantity() %>)</span>
                                    <strong>&#8377;<%= String.format("%,.0f", item.getSubtotal()) %></strong>
                                </div>
                        <%  }
                           } %>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 14px; border-top: 1px solid var(--border-subtle); flex-wrap: wrap; gap: 12px;">
                        <span style="font-size: 1.1rem; color: var(--dark-espresso); font-weight: 700;">
                            Grand Total: &#8377;<%= String.format("%,.0f", o.getGrandTotal()) %>
                        </span>

                        <a href="${pageContext.request.contextPath}/order-details?id=<%= o.getOrderId() %>" class="btn btn-outline btn-sm">
                            <span>View Full Details & Invoice</span>
                            <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div style="text-align: center; padding: 80px 20px; background: #fff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm);">
            <i class="fa-solid fa-box-open" style="font-size: 3rem; color: var(--border-strong); margin-bottom: 18px;"></i>
            <h3 style="font-family: var(--font-serif); font-size: 1.8rem; margin-bottom: 10px;">No Orders Placed Yet</h3>
            <p style="color: var(--text-muted); margin-bottom: 24px;">Browse our Scandinavian interior catalog to acquire your first architectural piece.</p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Start Exploring</a>
        </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
