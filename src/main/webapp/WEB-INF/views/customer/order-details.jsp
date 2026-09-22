<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gruhu.model.Order" %>
<%@ page import="com.gruhu.model.OrderItem" %>
<%@ page import="com.gruhu.model.Address" %>

<%
    Order order = (Order) request.getAttribute("order");
    Address address = (order != null) ? order.getAddress() : null;
    request.setAttribute("extraCss", "auth.css,cart.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="account-page">
    <div class="catalog-breadcrumb" style="margin-bottom: 24px;">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <i class="fa-solid fa-chevron-right"></i>
        <a href="${pageContext.request.contextPath}/my-orders">My Orders</a>
        <i class="fa-solid fa-chevron-right"></i>
        <span>Order #<%= order.getOrderId() %></span>
    </div>

    <!-- Printable Invoice Panel -->
    <div style="background: #ffffff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); padding: 44px; box-shadow: var(--shadow-subtle);">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; padding-bottom: 24px; border-bottom: 1px solid var(--border-subtle); margin-bottom: 30px; flex-wrap: wrap; gap: 20px;">
            <div>
                <span class="auth-tag">Gruhu Atelier Invoice</span>
                <h1 style="font-family: var(--font-serif); font-size: 2.2rem; color: var(--dark-espresso); margin-top: 4px;">
                    Order #<%= order.getOrderId() %>
                </h1>
                <p style="color: var(--text-muted); font-size: 0.88rem;">
                    Placed on <%= order.getOrderDate() != null ? order.getOrderDate().toString() : "Recent" %>
                </p>
            </div>

            <div style="display: flex; gap: 12px; align-items: center;">
                <button onclick="window.print()" class="btn btn-outline btn-sm">
                    <i class="fa-solid fa-print"></i> Print Invoice
                </button>
                <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-primary btn-sm">
                    <i class="fa-solid fa-arrow-left"></i> Back to Orders
                </a>
            </div>
        </div>

        <!-- Timeline -->
        <div class="order-timeline" style="margin: 30px 0 40px;">
            <div class="timeline-step <%= "PLACED".equalsIgnoreCase(order.getOrderStatus()) || "CONFIRMED".equalsIgnoreCase(order.getOrderStatus()) || "SHIPPED".equalsIgnoreCase(order.getOrderStatus()) || "DELIVERED".equalsIgnoreCase(order.getOrderStatus()) ? "completed" : "" %>">
                <div class="timeline-step-icon"><i class="fa-solid fa-receipt"></i></div>
                <span class="timeline-step-label">Order Placed</span>
            </div>
            <div class="timeline-step <%= "CONFIRMED".equalsIgnoreCase(order.getOrderStatus()) || "SHIPPED".equalsIgnoreCase(order.getOrderStatus()) || "DELIVERED".equalsIgnoreCase(order.getOrderStatus()) ? "completed" : ("PLACED".equalsIgnoreCase(order.getOrderStatus()) ? "active" : "") %>">
                <div class="timeline-step-icon"><i class="fa-solid fa-hammer"></i></div>
                <span class="timeline-step-label">Atelier Workshop</span>
            </div>
            <div class="timeline-step <%= "SHIPPED".equalsIgnoreCase(order.getOrderStatus()) || "DELIVERED".equalsIgnoreCase(order.getOrderStatus()) ? "completed" : ("CONFIRMED".equalsIgnoreCase(order.getOrderStatus()) ? "active" : "") %>">
                <div class="timeline-step-icon"><i class="fa-solid fa-truck-fast"></i></div>
                <span class="timeline-step-label">In Transit</span>
            </div>
            <div class="timeline-step <%= "DELIVERED".equalsIgnoreCase(order.getOrderStatus()) ? "completed" : ("SHIPPED".equalsIgnoreCase(order.getOrderStatus()) ? "active" : "") %>">
                <div class="timeline-step-icon"><i class="fa-solid fa-house-chimney-check"></i></div>
                <span class="timeline-step-label">Delivered & Assembled</span>
            </div>
        </div>

        <!-- Address & Payment Meta -->
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 36px; background: var(--bg-sand-light); border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); padding: 24px; margin-bottom: 36px;">
            <div>
                <strong style="font-size: 0.82rem; text-transform: uppercase; letter-spacing: 0.1em; color: var(--accent-amber); display: block; margin-bottom: 8px;">Delivery Destination</strong>
                <% if (address != null) { %>
                    <h4 style="font-size: 1.05rem; color: var(--dark-espresso); margin-bottom: 4px;"><%= address.getReceiverName() %></h4>
                    <p style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.5;">
                        <%= address.getHouseAddress() %><br>
                        <%= address.getCity() %>, <%= address.getState() %> &ndash; <%= address.getPincode() %>
                    </p>
                    <small style="color: var(--text-muted);">Phone: +91 <%= address.getPhone() %></small>
                <% } %>
            </div>

            <div>
                <strong style="font-size: 0.82rem; text-transform: uppercase; letter-spacing: 0.1em; color: var(--accent-amber); display: block; margin-bottom: 8px;">Billing & Payment Status</strong>
                <p style="font-size: 0.92rem; color: var(--text-secondary); margin-bottom: 6px;">
                    Method: <strong><%= order.getPaymentMethod() %></strong>
                </p>
                <p style="font-size: 0.92rem; color: var(--text-secondary); margin-bottom: 6px;">
                    Payment Status: <span class="badge badge-featured"><%= order.getPaymentStatus() %></span>
                </p>
                <p style="font-size: 0.92rem; color: var(--text-secondary);">
                    Order Status: <span class="badge" style="background: var(--dark-espresso); color: #fff;"><%= order.getOrderStatus() %></span>
                </p>
            </div>
        </div>

        <!-- Items Table -->
        <h3 style="font-family: var(--font-serif); font-size: 1.4rem; color: var(--dark-espresso); margin-bottom: 16px;">Acquired Pieces</h3>
        <table style="width: 100%; border-collapse: collapse; margin-bottom: 28px;">
            <thead>
                <tr style="border-bottom: 2px solid var(--border-subtle); text-align: left; font-size: 0.82rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--text-muted);">
                    <th style="padding: 12px 8px;">Piece</th>
                    <th style="padding: 12px 8px; text-align: right;">Unit Price</th>
                    <th style="padding: 12px 8px; text-align: center;">Quantity</th>
                    <th style="padding: 12px 8px; text-align: right;">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <% if (order.getItems() != null) {
                    for (OrderItem item : order.getItems()) { %>
                    <tr style="border-bottom: 1px solid var(--border-subtle); font-size: 0.92rem;">
                        <td style="padding: 16px 8px;">
                            <strong style="color: var(--dark-espresso); display: block;"><%= item.getProductName() %></strong>
                            <small style="color: var(--text-muted);">ID: #<%= item.getProductId() %></small>
                        </td>
                        <td style="padding: 16px 8px; text-align: right;">&#8377;<%= String.format("%,.0f", item.getPrice()) %></td>
                        <td style="padding: 16px 8px; text-align: center;"><%= item.getQuantity() %></td>
                        <td style="padding: 16px 8px; text-align: right; font-weight: 700;">&#8377;<%= String.format("%,.0f", item.getSubtotal()) %></td>
                    </tr>
                <%  }
                   } %>
            </tbody>
        </table>

        <!-- Totals Row -->
        <div style="max-width: 360px; margin-left: auto;">
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.92rem; color: var(--text-secondary);">
                <span>Items Subtotal:</span>
                <strong>&#8377;<%= String.format("%,.0f", order.getTotalAmount()) %></strong>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 0.92rem; color: var(--text-secondary);">
                <span>White Glove Transport:</span>
                <strong><%= order.getDeliveryCharge().compareTo(java.math.BigDecimal.ZERO) == 0 ? "FREE" : "&#8377;" + order.getDeliveryCharge() %></strong>
            </div>
            <div style="display: flex; justify-content: space-between; padding-top: 12px; border-top: 2px solid var(--dark-espresso); font-size: 1.3rem; font-weight: 700; color: var(--dark-espresso);">
                <span>Grand Total:</span>
                <span>&#8377;<%= String.format("%,.0f", order.getGrandTotal()) %></span>
            </div>
        </div>

    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
