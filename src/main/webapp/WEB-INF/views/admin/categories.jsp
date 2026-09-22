<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Category" %>

<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String success = request.getParameter("success");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Curatorial Disciplines & Categories</h1>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/subcategories" class="btn-admin btn-admin-secondary">
                <i class="fa-solid fa-sitemap"></i> Subcategories
            </a>
        </div>
    </header>

    <main class="admin-content">

        <% if ("saved".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Category taxonomy synchronized successfully.</span>
            </div>
        <% } %>

        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 24px;">
            <!-- Create Category Form -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">Add Discipline</h2>
                </div>
                <div class="admin-card-body">
                    <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="form-group-admin">
                            <label class="form-label-admin">Category Name *</label>
                            <input type="text" name="categoryName" class="form-control-admin" required placeholder="e.g. Sculptural Lighting">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Image Visual URL</label>
                            <input type="url" name="imageUrl" class="form-control-admin" placeholder="https://images.unsplash.com/...">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Curatorial Description</label>
                            <textarea name="description" rows="3" class="form-control-admin" placeholder="Describe the design philosophy of this collection..."></textarea>
                        </div>

                        <button type="submit" class="btn-admin btn-admin-primary" style="width: 100%; justify-content: center;">
                            <i class="fa-solid fa-plus"></i> Save Discipline
                        </button>
                    </form>
                </div>
            </div>

            <!-- Categories List Table -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">Active Disciplines (<%= categories != null ? categories.size() : 0 %>)</h2>
                </div>
                <div class="admin-table-container">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Visual</th>
                                <th>Discipline</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (categories != null && !categories.isEmpty()) {
                                for (Category c : categories) {
                                    String img = (c.getCategoryImage() != null && !c.getCategoryImage().isEmpty())
                                        ? c.getCategoryImage()
                                        : "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&q=80";
                            %>
                                <tr>
                                    <td>
                                        <img src="<%= img %>" alt="<%= c.getCategoryName() %>" class="product-thumb">
                                    </td>
                                    <td><strong><%= c.getCategoryName() %></strong></td>
                                    <td style="color: var(--admin-text-muted); font-size: 0.82rem; max-width: 250px;">
                                        <%= c.getDescription() != null ? c.getDescription() : "&mdash;" %>
                                    </td>
                                    <td>
                                        <span class="admin-badge <%= "ACTIVE".equalsIgnoreCase(c.getStatus()) ? "badge-active" : "badge-inactive" %>">
                                            <%= c.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group">
                                            <button type="button" class="btn-admin btn-admin-secondary btn-admin-sm"
                                                    onclick="editCategory(<%= c.getCategoryId() %>, '<%= c.getCategoryName().replace("'", "\\'") %>', '<%= c.getDescription() != null ? c.getDescription().replace("'", "\\'") : "" %>', '<%= c.getCategoryImage() != null ? c.getCategoryImage() : "" %>', '<%= c.getStatus() %>')">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </button>

                                            <form action="${pageContext.request.contextPath}/admin/categories" method="post" style="display: inline;"
                                                  onsubmit="return confirm('Remove category <%= c.getCategoryName() %>?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="categoryId" value="<%= c.getCategoryId() %>">
                                                <button type="submit" class="btn-admin btn-admin-danger btn-admin-sm" title="Delete">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                            } else { %>
                                <tr>
                                    <td colspan="5" style="text-align: center; color: var(--admin-text-muted); padding: 32px;">
                                        No categories found. Create your first category above.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Edit Category Modal -->
        <div id="editCategoryModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 1000; align-items: center; justify-content: center;">
            <div class="admin-card" style="width: 100%; max-width: 480px; margin: 20px;">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">Edit Discipline</h2>
                    <button type="button" onclick="closeEditModal()" style="background: none; border: none; font-size: 1.2rem; cursor: pointer; color: var(--admin-text-muted);">&times;</button>
                </div>
                <div class="admin-card-body">
                    <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="categoryId" id="editCatId">

                        <div class="form-group-admin">
                            <label class="form-label-admin">Category Name *</label>
                            <input type="text" name="categoryName" id="editCatName" class="form-control-admin" required>
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Image Visual URL</label>
                            <input type="url" name="imageUrl" id="editCatImage" class="form-control-admin">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Description</label>
                            <textarea name="description" id="editCatDesc" rows="3" class="form-control-admin"></textarea>
                        </div>

                        <div class="form-group-admin">
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                <input type="checkbox" name="isActive" id="editCatActive" value="true">
                                <span>Active in Boutique Store</span>
                            </label>
                        </div>

                        <div style="display: flex; gap: 12px; justify-content: flex-end;">
                            <button type="button" onclick="closeEditModal()" class="btn-admin btn-admin-secondary">Cancel</button>
                            <button type="submit" class="btn-admin btn-admin-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </main>
</div>

<script>
    function editCategory(id, name, desc, img, status) {
        document.getElementById('editCatId').value = id;
        document.getElementById('editCatName').value = name;
        document.getElementById('editCatDesc').value = desc;
        document.getElementById('editCatImage').value = img;
        document.getElementById('editCatActive').checked = (status === 'ACTIVE');
        const modal = document.getElementById('editCategoryModal');
        modal.style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editCategoryModal').style.display = 'none';
    }
</script>

<%@ include file="/WEB-INF/views/admin/common/admin-footer.jsp" %>
