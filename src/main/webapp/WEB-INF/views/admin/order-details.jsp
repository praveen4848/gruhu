<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gruhu.model.Order" %>
<%@ page import="com.gruhu.model.OrderItem" %>
<%@ page import="com.gruhu.model.Address" %>
<%@ page import="com.gruhu.model.Customer" %>

<%
    Order order = (Order) request.getAttribute("order");
    Address addr = (order != null) ? order.getAddress() : null;
    Customer customer = (order != null) ? order.getCustomer() : null;
    String success = request.getParameter("success");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Acquisition Dossier #ORD-<%= order != null ? order.getOrderId() : 0 %></h1>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn-admin btn-admin-secondary">
                <i class="fa-solid fa-arrow-left"></i> All Acquisitions
            </a>
        </div>
    </header>

    <main class="admin-content">

        <% if ("statusUpdated".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Order workflow and logistics state updated.</span>
            </div>
        <% } %>

        <% if (order != null) { %>
            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px;">

                <!-- Left: Items & Financial Breakdown -->
                <div>
                    <div class="admin-card">
                        <div class="admin-card-header">
                            <h2 class="admin-card-title">Curated Pieces Acquired</h2>
                            <span style="font-size: 0.85rem; color: var(--admin-text-muted);">
                                Placed on <%= order.getOrderDate() != null ? order.getOrderDate().toString().substring(0, 16) : "" %>
                            </span>
                        </div>
                        <div class="admin-table-container">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>Piece</th>
                                        <th>Unit Price</th>
                                        <th>Quantity</th>
                                        <th>Settlement</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (order.getItems() != null) {
                                        for (OrderItem item : order.getItems()) {
                                            String img = (item.getProduct() != null && item.getProduct().getPrimaryImage() != null)
                                                ? item.getProduct().getPrimaryImage()
                                                : "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=200&q=80";
                                    %>
                                        <tr>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 12px;">
                                                    <img src="<%= img %>" alt="<%= item.getProductName() %>" class="product-thumb">
                                                    <div>
                                                        <div style="font-weight: 600;"><%= item.getProductName() %></div>
                                                        <small style="color: var(--admin-text-muted);">Ref: #PRD-<%= item.getProductId() %></small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>&#8377;<%= String.format("%,.0f", item.getPrice()) %></td>
                                            <td>&times; <%= item.getQuantity() %></td>
                                            <td><strong>&#8377;<%= String.format("%,.0f", item.getSubtotal()) %></strong></td>
                                        </tr>
                                    <%  }
                                    } %>
                                </tbody>
                            </table>
                        </div>
                        <div class="admin-card-body" style="background: #faf8f5; border-top: 1px solid var(--admin-border);">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem;">
                                <span style="color: var(--admin-text-muted);">Objects Subtotal:</span>
                                <span>&#8377;<%= String.format("%,.0f", order.getTotalAmount().subtract(order.getDeliveryCharge())) %></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 0.9rem;">
                                <span style="color: var(--admin-text-muted);">White-Glove Transport & Assembly:</span>
                                <span><%= order.getDeliveryCharge().compareTo(java.math.BigDecimal.ZERO) == 0 ? "Complimentary" : "&#8377;" + order.getDeliveryCharge() %></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; font-size: 1.25rem; font-weight: 700; font-family: var(--admin-font-serif); border-top: 1px solid var(--admin-border); padding-top: 12px;">
                                <span>Total Paid / Payable:</span>
                                <span style="color: var(--admin-accent);">&#8377;<%= String.format("%,.0f", order.getTotalAmount()) %></span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Client, Shipping & Status Controls -->
                <div>
                    <!-- Status Adjustment Controls -->
                    <div class="admin-card">
                        <div class="admin-card-header">
                            <h2 class="admin-card-title">Fulfillment Workflow</h2>
                        </div>
                        <div class="admin-card-body">
                            <!-- Order Status Form -->
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="margin-bottom: 24px;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">

                                <div class="form-group-admin">
                                    <label class="form-label-admin">Logistics Fulfillment State</label>
                                    <select name="orderStatus" class="form-control-admin" style="margin-bottom: 12px;">
                                        <option value="PLACED" <%= "PLACED".equalsIgnoreCase(order.getOrderStatus()) ? "selected" : "" %>>PLACED (Awaiting Preparation)</option>
                                        <option value="CONFIRMED" <%= "CONFIRMED".equalsIgnoreCase(order.getOrderStatus()) ? "selected" : "" %>>CONFIRMED (In Workshop Inspection)</option>
                                        <option value="SHIPPED" <%= "SHIPPED".equalsIgnoreCase(order.getOrderStatus()) ? "selected" : "" %>>SHIPPED (En Route via White Glove)</option>
                                        <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(order.getOrderStatus()) ? "selected" : "" %>>DELIVERED (Signed & Handed Over)</option>
                                        <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(order.getOrderStatus()) ? "selected" : "" %>>CANCELLED</option>
                                    </select>
                                    <button type="submit" class="btn-admin btn-admin-primary btn-admin-sm" style="width: 100%; justify-content: center;">
                                        Update Fulfillment State
                                    </button>
                                </div>
                            </form>

                            <!-- Payment Status Form -->
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                <input type="hidden" name="action" value="updatePayment">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">

                                <div class="form-group-admin" style="margin-bottom: 0;">
                                    <label class="form-label-admin">Payment Status (<%= order.getPaymentMethod() %>)</label>
                                    <select name="paymentStatus" class="form-control-admin" style="margin-bottom: 12px;">
                                        <option value="PENDING" <%= "PENDING".equalsIgnoreCase(order.getPaymentStatus()) ? "selected" : "" %>>PENDING</option>
                                        <option value="PAID" <%= "PAID".equalsIgnoreCase(order.getPaymentStatus()) ? "selected" : "" %>>PAID / SETTLED</option>
                                        <option value="FAILED" <%= "FAILED".equalsIgnoreCase(order.getPaymentStatus()) ? "selected" : "" %>>FAILED</option>
                                        <option value="REFUNDED" <%= "REFUNDED".equalsIgnoreCase(order.getPaymentStatus()) ? "selected" : "" %>>REFUNDED</option>
                                    </select>
                                    <button type="submit" class="btn-admin btn-admin-secondary btn-admin-sm" style="width: 100%; justify-content: center;">
                                        Update Payment State
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Client & Shipping Details -->
                    <div class="admin-card">
                        <div class="admin-card-header">
                            <h2 class="admin-card-title">Client & Destination</h2>
                        </div>
                        <div class="admin-card-body">
                            <% if (customer != null) { %>
                                <div style="margin-bottom: 16px;">
                                    <div style="font-size: 0.75rem; text-transform: uppercase; color: var(--admin-text-muted); font-weight: 600;">Patron</div>
                                    <div style="font-weight: 600; color: var(--admin-text-main);"><%= customer.getFullName() %></div>
                                    <div style="font-size: 0.85rem; color: var(--admin-text-muted);"><%= customer.getEmail() %></div>
                                    <div style="font-size: 0.85rem; color: var(--admin-text-muted);">+91 <%= customer.getPhone() %></div>
                                </div>
                            <% } %>

                            <% if (addr != null) { %>
                                <div>
                                    <div style="font-size: 0.75rem; text-transform: uppercase; color: var(--admin-text-muted); font-weight: 600;">Delivery Destination</div>
                                    <div style="font-weight: 600;"><%= addr.getReceiverName() %> (<%= addr.getAddressType() %>)</div>
                                    <div style="font-size: 0.85rem; color: var(--admin-text-muted); line-height: 1.5; margin-top: 4px;">
                                        <%= addr.getHouseAddress() %><br>
                                        <%= addr.getCity() %>, <%= addr.getState() %> - <%= addr.getPincode() %><br>
                                        Contact: +91 <%= addr.getPhone() %>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>

            </div>
        <% } %>

    </main>
</div>

<%@ include file="/WEB-INF/views/admin/common/admin-footer.jsp" %>
