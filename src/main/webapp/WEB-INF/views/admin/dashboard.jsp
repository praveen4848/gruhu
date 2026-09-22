<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.gruhu.model.Order" %>
<%@ page import="com.gruhu.model.Product" %>

<%
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    BigDecimal totalRevenue = (stats != null && stats.get("totalRevenue") != null) ? (BigDecimal) stats.get("totalRevenue") : BigDecimal.ZERO;
    int totalOrders = (stats != null && stats.get("totalOrders") != null) ? (Integer) stats.get("totalOrders") : 0;
    int totalProducts = (stats != null && stats.get("totalProducts") != null) ? (Integer) stats.get("totalProducts") : 0;
    int totalCustomers = (stats != null && stats.get("totalCustomers") != null) ? (Integer) stats.get("totalCustomers") : 0;
    int unreadMessages = (stats != null && stats.get("unreadMessages") != null) ? (Integer) stats.get("unreadMessages") : 0;
    List<Order> recentOrders = (stats != null) ? (List<Order>) stats.get("recentOrders") : null;
    List<Product> lowStockProducts = (stats != null) ? (List<Product>) stats.get("lowStockProducts") : null;
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Curator Overview</h1>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn-admin btn-admin-primary btn-admin-sm">
                <i class="fa-solid fa-plus"></i> New Product
            </a>
            <a href="${pageContext.request.contextPath}/home" target="_blank" class="store-preview-btn">
                <i class="fa-solid fa-arrow-up-right-from-square"></i> View Storefront
            </a>
        </div>
    </header>

    <main class="admin-content">
        <!-- Metric Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-content">
                    <h3>Gross Acquisitions</h3>
                    <div class="stat-number">&#8377;<%= String.format("%,.0f", totalRevenue) %></div>
                    <div class="stat-note">Lifetime revenue generated</div>
                </div>
                <div class="stat-icon icon-amber">
                    <i class="fa-solid fa-indian-rupee-sign"></i>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <h3>Client Acquisitions</h3>
                    <div class="stat-number"><%= totalOrders %></div>
                    <div class="stat-note">Total completed & pending orders</div>
                </div>
                <div class="stat-icon icon-blue">
                    <i class="fa-solid fa-receipt"></i>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <h3>Sculptural Catalog</h3>
                    <div class="stat-number"><%= totalProducts %></div>
                    <div class="stat-note">Active Scandinavian objects</div>
                </div>
                <div class="stat-icon icon-green">
                    <i class="fa-solid fa-couch"></i>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <h3>Registered Patrons</h3>
                    <div class="stat-number"><%= totalCustomers %></div>
                    <div class="stat-note">Verified client accounts</div>
                </div>
                <div class="stat-icon icon-amber">
                    <i class="fa-solid fa-users"></i>
                </div>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px;">
            <!-- Recent Orders Card -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">Recent Patron Acquisitions</h2>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn-admin btn-admin-secondary btn-admin-sm">
                        View All Orders
                    </a>
                </div>
                <div class="admin-table-container">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Date</th>
                                <th>Total</th>
                                <th>Payment</th>
                                <th>Fulfillment</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (recentOrders != null && !recentOrders.isEmpty()) {
                                for (Order o : recentOrders) { %>
                                    <tr>
                                        <td><strong>#ORD-<%= o.getOrderId() %></strong></td>
                                        <td style="color: var(--admin-text-muted); font-size: 0.8rem;">
                                            <%= o.getOrderDate() != null ? o.getOrderDate().toString().substring(0, 16) : "N/A" %>
                                        </td>
                                        <td><strong>&#8377;<%= String.format("%,.0f", o.getTotalAmount()) %></strong></td>
                                        <td>
                                            <span class="admin-badge badge-<%= o.getPaymentStatus() != null ? o.getPaymentStatus().toLowerCase() : "pending" %>">
                                                <%= o.getPaymentStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="admin-badge badge-<%= o.getOrderStatus() != null ? o.getOrderStatus().toLowerCase() : "placed" %>">
                                                <%= o.getOrderStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/orders?action=details&id=<%= o.getOrderId() %>" 
                                               class="btn-admin btn-admin-secondary btn-admin-sm">
                                                Inspect
                                            </a>
                                        </td>
                                    </tr>
                            <%  }
                            } else { %>
                                <tr>
                                    <td colspan="6" style="text-align: center; color: var(--admin-text-muted); padding: 32px;">
                                        No customer orders recorded yet.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Low Stock & Inquiries Alerts -->
            <div>
                <!-- Low Stock Box -->
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h2 class="admin-card-title" style="display: flex; align-items: center; gap: 8px;">
                            <i class="fa-solid fa-triangle-exclamation" style="color: var(--admin-warning); font-size: 1rem;"></i>
                            Studio Inventory Alerts
                        </h2>
                        <a href="${pageContext.request.contextPath}/admin/stock" class="btn-admin btn-admin-secondary btn-admin-sm">
                            Restock
                        </a>
                    </div>
                    <div class="admin-table-container">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Piece</th>
                                    <th>Stock</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (lowStockProducts != null && !lowStockProducts.isEmpty()) {
                                    for (Product p : lowStockProducts) { %>
                                        <tr>
                                            <td>
                                                <div style="font-weight: 500;"><%= p.getProductName() %></div>
                                                <small style="color: var(--admin-text-muted);"><%= p.getCategoryName() %></small>
                                            </td>
                                            <td>
                                                <span class="admin-badge <%= p.getStockQuantity() == 0 ? "badge-danger" : "badge-placed" %>">
                                                    <%= p.getStockQuantity() %> left
                                                </span>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/admin/stock" method="post" style="display: inline-flex; gap: 4px;">
                                                    <input type="hidden" name="action" value="adjust">
                                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                                    <input type="hidden" name="change" value="5">
                                                    <button type="submit" class="btn-admin btn-admin-secondary btn-admin-sm" title="Add 5 items">
                                                        +5
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                <%  }
                                } else { %>
                                    <tr>
                                        <td colspan="3" style="text-align: center; color: var(--admin-success); padding: 24px;">
                                            <i class="fa-regular fa-circle-check"></i> Studio stock levels healthy.
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Client Inquiries Card -->
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h2 class="admin-card-title">Curator Inquiries</h2>
                        <a href="${pageContext.request.contextPath}/admin/messages" class="btn-admin btn-admin-secondary btn-admin-sm">
                            All Inquiries
                        </a>
                    </div>
                    <div class="admin-card-body">
                        <p style="color: var(--admin-text-muted); font-size: 0.9rem; margin-bottom: 12px;">
                            You currently have <strong><%= unreadMessages %></strong> unread patron inquiries awaiting consultation.
                        </p>
                        <a href="${pageContext.request.contextPath}/admin/messages" class="btn-admin btn-admin-primary btn-admin-sm">
                            <i class="fa-solid fa-comments"></i> Consult Patron Messages
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/admin/common/admin-footer.jsp" %>
