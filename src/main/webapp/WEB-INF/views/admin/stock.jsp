<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Product" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    String activeFilter = (String) request.getAttribute("activeFilter");
    if (activeFilter == null) activeFilter = "all";
    String success = request.getParameter("success");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Studio Stock & Inventory Replenishment</h1>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/products" class="btn-admin btn-admin-secondary">
                <i class="fa-solid fa-couch"></i> All Products
            </a>
        </div>
    </header>

    <main class="admin-content">

        <% if ("updated".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Inventory stock counts synchronized successfully.</span>
            </div>
        <% } %>

        <div class="admin-filters-bar">
            <div class="filter-pills">
                <a href="${pageContext.request.contextPath}/admin/stock?filter=all" 
                   class="filter-pill <%= "all".equals(activeFilter) ? "active" : "" %>">
                    All Studio Objects
                </a>
                <a href="${pageContext.request.contextPath}/admin/stock?filter=low" 
                   class="filter-pill <%= "low".equals(activeFilter) ? "active" : "" %>">
                    <i class="fa-solid fa-triangle-exclamation" style="color: var(--admin-warning);"></i> Low Inventory (&le; 5)
                </a>
                <a href="${pageContext.request.contextPath}/admin/stock?filter=out" 
                   class="filter-pill <%= "out".equals(activeFilter) ? "active" : "" %>">
                    <i class="fa-solid fa-circle-xmark" style="color: var(--admin-danger);"></i> Depleted (0)
                </a>
            </div>
        </div>

        <div class="admin-card">
            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Crafted Object</th>
                            <th>Category</th>
                            <th>Current Reserve</th>
                            <th>Inventory State</th>
                            <th>Quick Increment</th>
                            <th style="min-width: 200px;">Direct Set</th>
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
                                            <div style="font-weight: 600;"><%= p.getProductName() %></div>
                                            <small style="color: var(--admin-text-muted);"><%= p.getMaterial() %></small>
                                        </div>
                                    </div>
                                </td>
                                <td><%= p.getCategoryName() %></td>
                                <td>
                                    <span style="font-size: 1.1rem; font-weight: 700; font-family: var(--admin-font-serif);">
                                        <%= p.getStockQuantity() %>
                                    </span>
                                </td>
                                <td>
                                    <% if (p.getStockQuantity() == 0) { %>
                                        <span class="admin-badge badge-danger">Exhausted</span>
                                    <% } else if (p.getStockQuantity() <= 5) { %>
                                        <span class="admin-badge badge-placed">Critically Low</span>
                                    <% } else { %>
                                        <span class="admin-badge badge-active">Available</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <% if (p.getStockQuantity() > 0) { %>
                                            <form action="${pageContext.request.contextPath}/admin/stock" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="adjust">
                                                <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                                <input type="hidden" name="change" value="-1">
                                                <input type="hidden" name="filter" value="<%= activeFilter %>">
                                                <button type="submit" class="btn-admin btn-admin-secondary btn-admin-sm" title="Decrease 1">-1</button>
                                            </form>
                                        <% } %>

                                        <form action="${pageContext.request.contextPath}/admin/stock" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="adjust">
                                            <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                            <input type="hidden" name="change" value="1">
                                            <input type="hidden" name="filter" value="<%= activeFilter %>">
                                            <button type="submit" class="btn-admin btn-admin-secondary btn-admin-sm" title="Add 1">+1</button>
                                        </form>

                                        <form action="${pageContext.request.contextPath}/admin/stock" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="adjust">
                                            <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                            <input type="hidden" name="change" value="5">
                                            <input type="hidden" name="filter" value="<%= activeFilter %>">
                                            <button type="submit" class="btn-admin btn-admin-secondary btn-admin-sm" title="Add 5">+5</button>
                                        </form>
                                    </div>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/stock" method="post" style="display: flex; gap: 8px; align-items: center;">
                                        <input type="hidden" name="action" value="set">
                                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                        <input type="hidden" name="filter" value="<%= activeFilter %>">
                                        <input type="number" min="0" name="quantity" value="<%= p.getStockQuantity() %>" 
                                               class="form-control-admin" style="width: 80px; padding: 6px 10px;">
                                        <button type="submit" class="btn-admin btn-admin-primary btn-admin-sm">Set</button>
                                    </form>
                                </td>
                            </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="6" style="text-align: center; color: var(--admin-text-muted); padding: 40px;">
                                    No products matching inventory state.
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
