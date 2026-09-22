<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Product" %>
<%@ page import="com.gruhu.model.Category" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedStock = (String) request.getAttribute("selectedStock");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String success = request.getParameter("success");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Curated Collection (<%= products != null ? products.size() : 0 %>)</h1>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn-admin btn-admin-primary">
                <i class="fa-solid fa-plus"></i> Add New Product
            </a>
        </div>
    </header>

    <main class="admin-content">

        <% if ("added".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Sculptural piece added to the atelier catalog successfully.</span>
            </div>
        <% } else if ("updated".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Product specifications and pricing updated.</span>
            </div>
        <% } else if ("deleted".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Product status updated to inactive.</span>
            </div>
        <% } %>

        <!-- Filter & Search Toolbar -->
        <div class="admin-card" style="margin-bottom: 20px;">
            <div class="admin-card-body" style="padding: 16px 20px;">
                <form action="${pageContext.request.contextPath}/admin/products" method="get" style="display: flex; gap: 16px; align-items: center; flex-wrap: wrap;">
                    <div style="flex: 1; min-width: 240px;">
                        <input type="text" name="search" class="form-control-admin" placeholder="Search by piece title, material, or maker..." 
                               value="<%= searchQuery != null ? searchQuery : "" %>">
                    </div>

                    <div style="width: 200px;">
                        <select name="category" class="form-control-admin">
                            <option value="all">All Disciplines</option>
                            <% if (categories != null) {
                                for (Category c : categories) {
                                    boolean isSel = selectedCategory != null && selectedCategory.equals(String.valueOf(c.getCategoryId()));
                            %>
                                <option value="<%= c.getCategoryId() %>" <%= isSel ? "selected" : "" %>>
                                    <%= c.getCategoryName() %>
                                </option>
                            <%  }
                            } %>
                        </select>
                    </div>

                    <div style="width: 160px;">
                        <select name="stock" class="form-control-admin">
                            <option value="all" <%= "all".equals(selectedStock) ? "selected" : "" %>>All Stock</option>
                            <option value="low" <%= "low".equals(selectedStock) ? "selected" : "" %>>Low Stock (&le; 5)</option>
                            <option value="out" <%= "out".equals(selectedStock) ? "selected" : "" %>>Out of Stock</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-admin btn-admin-secondary">
                        <i class="fa-solid fa-filter"></i> Apply Filter
                    </button>

                    <% if ((searchQuery != null && !searchQuery.isEmpty()) || (selectedCategory != null && !"all".equals(selectedCategory)) || (selectedStock != null && !"all".equals(selectedStock))) { %>
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn-admin btn-admin-secondary" title="Clear Filters">
                            <i class="fa-solid fa-xmark"></i> Clear
                        </a>
                    <% } %>
                </form>
            </div>
        </div>

        <!-- Products Table -->
        <div class="admin-card">
            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Object</th>
                            <th>Category</th>
                            <th>Base Price</th>
                            <th>Discount</th>
                            <th>Net Price</th>
                            <th>Stock</th>
                            <th>Featured</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (products != null && !products.isEmpty()) {
                            for (Product p : products) {
                                String imgUrl = p.getPrimaryImage() != null && !p.getPrimaryImage().isEmpty() 
                                    ? p.getPrimaryImage() 
                                    : "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&q=80";
                        %>
                            <tr>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 14px;">
                                        <img src="<%= imgUrl %>" alt="<%= p.getProductName() %>" class="product-thumb">
                                        <div>
                                            <div style="font-weight: 600; color: var(--admin-text-main);">
                                                <%= p.getProductName() %>
                                            </div>
                                            <small style="color: var(--admin-text-muted);">
                                                <%= p.getMaterial() != null ? p.getMaterial() : "Crafted Piece" %>
                                            </small>
                                        </div>
                                    </div>
                                </td>
                                <td><%= p.getCategoryName() != null ? p.getCategoryName() : "Unassigned" %></td>
                                <td>&#8377;<%= String.format("%,.0f", p.getPrice()) %></td>
                                <td>
                                    <% if (p.getDiscountPercent() != null && p.getDiscountPercent().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                                        <span style="color: var(--admin-accent); font-weight: 600;">-<%= p.getDiscountPercent() %>%</span>
                                    <% } else { %>
                                        <span style="color: var(--admin-text-muted);">&mdash;</span>
                                    <% } %>
                                </td>
                                <td><strong>&#8377;<%= String.format("%,.0f", p.getDiscountedPrice()) %></strong></td>
                                <td>
                                    <% if (p.getStockQuantity() == 0) { %>
                                        <span class="admin-badge badge-danger">Out of Stock</span>
                                    <% } else if (p.getStockQuantity() <= 5) { %>
                                        <span class="admin-badge badge-placed"><%= p.getStockQuantity() %> units</span>
                                    <% } else { %>
                                        <span class="admin-badge badge-active"><%= p.getStockQuantity() %> units</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (p.isFeatured()) { %>
                                        <i class="fa-solid fa-star" style="color: #d4a373;" title="Featured on Front Atelier"></i>
                                    <% } else { %>
                                        <span style="color: var(--admin-border);">&mdash;</span>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="admin-badge <%= "ACTIVE".equalsIgnoreCase(p.getStatus()) ? "badge-active" : "badge-inactive" %>">
                                        <%= p.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=<%= p.getProductId() %>" 
                                           class="btn-admin btn-admin-secondary btn-admin-sm" title="Edit Piece">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/products?action=images&id=<%= p.getProductId() %>" 
                                           class="btn-admin btn-admin-secondary btn-admin-sm" title="Manage Image Portfolio">
                                            <i class="fa-solid fa-images"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=<%= p.getProductId() %>" 
                                           class="btn-admin btn-admin-danger btn-admin-sm" title="Deactivate"
                                           onclick="return confirm('Deactivate <%= p.getProductName() %> from the boutique?');">
                                            <i class="fa-solid fa-eye-slash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="9" style="text-align: center; color: var(--admin-text-muted); padding: 48px;">
                                    No products matched your catalog criteria.
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
