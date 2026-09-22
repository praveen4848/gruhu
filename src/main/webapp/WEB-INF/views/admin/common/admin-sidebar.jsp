<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gruhu.model.Admin" %>
<%
    Admin currentAdmin = (session != null) ? (Admin) session.getAttribute("admin") : null;
    String currentServlet = request.getServletPath();
%>

<aside class="admin-sidebar">
    <div class="admin-sidebar-brand">
        <a href="${pageContext.request.contextPath}/admin/dashboard" style="display: flex; flex-direction: row; align-items: center; gap: 12px;">
            <img src="${pageContext.request.contextPath}/assets/images/gruhu-logo-circle.png" 
                 alt="Gruhu Monogram" 
                 style="width: 38px; height: 38px; border-radius: 50%; object-fit: cover; box-shadow: 0 2px 8px rgba(0,0,0,0.3); background-color: #ffffff; flex-shrink: 0;">
            <div>
                <span class="brand-title">GRUHU</span>
                <span class="brand-sub">Curator Console</span>
            </div>
        </a>
    </div>

    <nav class="admin-nav">
        <span class="admin-nav-heading">Overview</span>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-item <%= "/admin/dashboard".equals(currentServlet) ? "active" : "" %>">
            <i class="fa-solid fa-chart-line"></i>
            <span>Dashboard</span>
        </a>

        <span class="admin-nav-heading">Collection Management</span>
        <a href="${pageContext.request.contextPath}/admin/products" class="admin-nav-item <%= "/admin/products".equals(currentServlet) ? "active" : "" %>">
            <i class="fa-solid fa-couch"></i>
            <span>All Products</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/stock" class="admin-nav-item <%= "/admin/stock".equals(currentServlet) ? "active" : "" %>">
            <i class="fa-solid fa-boxes-stacked"></i>
            <span>Stock Inventory</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/categories" class="admin-nav-item <%= "/admin/categories".equals(currentServlet) ? "active" : "" %>">
            <i class="fa-solid fa-layer-group"></i>
            <span>Categories</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/subcategories" class="admin-nav-item <%= "/admin/subcategories".equals(currentServlet) ? "active" : "" %>">
            <i class="fa-solid fa-sitemap"></i>
            <span>Subcategories</span>
        </a>

        <span class="admin-nav-heading">Operations</span>
        <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-item <%= "/admin/orders".equals(currentServlet) ? "active" : "" %>">
            <i class="fa-solid fa-receipt"></i>
            <span>Client Orders</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/customers" class="admin-nav-item <%= "/admin/customers".equals(currentServlet) ? "active" : "" %>">
            <i class="fa-solid fa-users"></i>
            <span>Customer Registry</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/messages" class="admin-nav-item <%= "/admin/messages".equals(currentServlet) ? "active" : "" %>">
            <i class="fa-solid fa-envelope-open-text"></i>
            <span>Curator Inquiries</span>
        </a>

        <span class="admin-nav-heading">Administration</span>
        <a href="${pageContext.request.contextPath}/admin/profile" class="admin-nav-item <%= "/admin/profile".equals(currentServlet) ? "active" : "" %>">
            <i class="fa-solid fa-shield-halved"></i>
            <span>Security & Profile</span>
        </a>
        <a href="${pageContext.request.contextPath}/home" target="_blank" class="admin-nav-item">
            <i class="fa-solid fa-arrow-up-right-from-square"></i>
            <span>Live Boutique Store</span>
        </a>
    </nav>

    <div class="admin-sidebar-footer">
        <div class="admin-user-info">
            <span class="admin-user-name"><%= currentAdmin != null ? currentAdmin.getName() : "Administrator" %></span>
            <span class="admin-user-role">Lead Curator</span>
        </div>
        <a href="${pageContext.request.contextPath}/admin/logout" class="admin-logout-btn" title="Log out from console">
            <i class="fa-solid fa-power-off"></i>
        </a>
    </div>
</aside>
