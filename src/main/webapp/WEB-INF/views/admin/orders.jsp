<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Order" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    if (selectedStatus == null) selectedStatus = "all";
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Patron Acquisitions & Logistics</h1>
        </div>
        <div class="topbar-right">
            <span style="font-size: 0.85rem; color: var(--admin-text-muted);">
                Showing <strong><%= orders != null ? orders.size() : 0 %></strong> orders
            </span>
        </div>
    </header>

    <main class="admin-content">

        <div class="admin-filters-bar">
            <div class="filter-pills">
                <a href="${pageContext.request.contextPath}/admin/orders?status=all" 
                   class="filter-pill <%= "all".equalsIgnoreCase(selectedStatus) ? "active" : "" %>">
                    All Acquisitions
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=PLACED" 
                   class="filter-pill <%= "PLACED".equalsIgnoreCase(selectedStatus) ? "active" : "" %>">
                    Placed
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=CONFIRMED" 
                   class="filter-pill <%= "CONFIRMED".equalsIgnoreCase(selectedStatus) ? "active" : "" %>">
                    Confirmed
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=SHIPPED" 
                   class="filter-pill <%= "SHIPPED".equalsIgnoreCase(selectedStatus) ? "active" : "" %>">
                    In Transit
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=DELIVERED" 
                   class="filter-pill <%= "DELIVERED".equalsIgnoreCase(selectedStatus) ? "active" : "" %>">
                    Delivered
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders?status=CANCELLED" 
                   class="filter-pill <%= "CANCELLED".equalsIgnoreCase(selectedStatus) ? "active" : "" %>">
                    Cancelled
                </a>
            </div>
        </div>

        <div class="admin-card">
            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Date & Time</th>
                            <th>Patron</th>
                            <th>Total Settlement</th>
                            <th>Payment Method</th>
                            <th>Payment State</th>
                            <th>Fulfillment State</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (orders != null && !orders.isEmpty()) {
                            for (Order o : orders) { %>
                                <tr>
                                    <td><strong>#ORD-<%= o.getOrderId() %></strong></td>
                                    <td style="color: var(--admin-text-muted); font-size: 0.82rem;">
                                        <%= o.getOrderDate() != null ? o.getOrderDate().toString().substring(0, 16) : "N/A" %>
                                    </td>
                                    <td>
                                        <% if (o.getCustomer() != null) { %>
                                            <div style="font-weight: 600;"><%= o.getCustomer().getFullName() %></div>
                                            <small style="color: var(--admin-text-muted);"><%= o.getCustomer().getEmail() %></small>
                                        <% } else { %>
                                            <span>Patron #<%= o.getCustomerId() %></span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <strong style="font-size: 0.95rem; font-family: var(--admin-font-serif);">
                                            &#8377;<%= String.format("%,.0f", o.getTotalAmount()) %>
                                        </strong>
                                    </td>
                                    <td>
                                        <span class="admin-badge" style="background: #ece8e1; color: var(--admin-text-main);">
                                            <%= o.getPaymentMethod() %>
                                        </span>
                                    </td>
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
                                            <i class="fa-solid fa-file-invoice"></i> Inspect
                                        </a>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="8" style="text-align: center; color: var(--admin-text-muted); padding: 48px;">
                                    No customer orders found under "<%= selectedStatus %>".
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

<%@ include file="/WEB-INF/views/admin/common/admin-footer.jsp" %>
