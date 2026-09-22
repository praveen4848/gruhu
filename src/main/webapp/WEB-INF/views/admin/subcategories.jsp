<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Category" %>
<%@ page import="com.gruhu.model.Subcategory" %>

<%
    List<Subcategory> subcategories = (List<Subcategory>) request.getAttribute("subcategories");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String success = request.getParameter("success");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Subcategories & Specializations</h1>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn-admin btn-admin-secondary">
                <i class="fa-solid fa-layer-group"></i> Main Categories
            </a>
        </div>
    </header>

    <main class="admin-content">

        <% if ("saved".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Subcategory catalog taxonomy synchronized.</span>
            </div>
        <% } %>

        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 24px;">
            <!-- Create Subcategory Form -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">Add Subcategory</h2>
                </div>
                <div class="admin-card-body">
                    <form action="${pageContext.request.contextPath}/admin/subcategories" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="form-group-admin">
                            <label class="form-label-admin">Parent Discipline *</label>
                            <select name="categoryId" class="form-control-admin" required>
                                <option value="">Select Parent Category</option>
                                <% if (categories != null) {
                                    for (Category c : categories) { %>
                                        <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Subcategory Name *</label>
                            <input type="text" name="subcategoryName" class="form-control-admin" required placeholder="e.g. Lounge & Accent Chairs">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Scope / Description</label>
                            <textarea name="description" rows="3" class="form-control-admin" placeholder="Optional notes..."></textarea>
                        </div>

                        <button type="submit" class="btn-admin btn-admin-primary" style="width: 100%; justify-content: center;">
                            <i class="fa-solid fa-plus"></i> Save Subcategory
                        </button>
                    </form>
                </div>
            </div>

            <!-- Subcategories Table -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">All Sub-Disciplines (<%= subcategories != null ? subcategories.size() : 0 %>)</h2>
                </div>
                <div class="admin-table-container">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Subcategory</th>
                                <th>Parent Discipline</th>
                                <th>Scope</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (subcategories != null && !subcategories.isEmpty()) {
                                for (Subcategory s : subcategories) { %>
                                    <tr>
                                        <td><strong><%= s.getSubcategoryName() %></strong></td>
                                        <td>
                                            <span style="color: var(--admin-accent); font-weight: 500;">
                                                <%= s.getCategoryName() != null ? s.getCategoryName() : "Category #" + s.getCategoryId() %>
                                            </span>
                                        </td>
                                        <td style="color: var(--admin-text-muted); font-size: 0.82rem;">
                                            <%= s.getDescription() != null ? s.getDescription() : "&mdash;" %>
                                        </td>
                                        <td>
                                            <span class="admin-badge <%= "ACTIVE".equalsIgnoreCase(s.getStatus()) ? "badge-active" : "badge-inactive" %>">
                                                <%= s.getStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <button type="button" class="btn-admin btn-admin-secondary btn-admin-sm"
                                                        onclick="editSubcategory(<%= s.getSubcategoryId() %>, <%= s.getCategoryId() %>, '<%= s.getSubcategoryName().replace("'", "\\'") %>', '<%= s.getDescription() != null ? s.getDescription().replace("'", "\\'") : "" %>', '<%= s.getStatus() %>')">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </button>

                                                <form action="${pageContext.request.contextPath}/admin/subcategories" method="post" style="display: inline;"
                                                      onsubmit="return confirm('Remove subcategory <%= s.getSubcategoryName() %>?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="subcategoryId" value="<%= s.getSubcategoryId() %>">
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
                                        No subcategories registered yet.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Edit Subcategory Modal -->
        <div id="editSubModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 1000; align-items: center; justify-content: center;">
            <div class="admin-card" style="width: 100%; max-width: 480px; margin: 20px;">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">Edit Subcategory</h2>
                    <button type="button" onclick="closeSubModal()" style="background: none; border: none; font-size: 1.2rem; cursor: pointer; color: var(--admin-text-muted);">&times;</button>
                </div>
                <div class="admin-card-body">
                    <form action="${pageContext.request.contextPath}/admin/subcategories" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="subcategoryId" id="editSubId">

                        <div class="form-group-admin">
                            <label class="form-label-admin">Parent Discipline *</label>
                            <select name="categoryId" id="editSubCatId" class="form-control-admin" required>
                                <% if (categories != null) {
                                    for (Category c : categories) { %>
                                        <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Subcategory Name *</label>
                            <input type="text" name="subcategoryName" id="editSubName" class="form-control-admin" required>
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Description</label>
                            <textarea name="description" id="editSubDesc" rows="3" class="form-control-admin"></textarea>
                        </div>

                        <div class="form-group-admin">
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                <input type="checkbox" name="isActive" id="editSubActive" value="true">
                                <span>Active in Boutique Store</span>
                            </label>
                        </div>

                        <div style="display: flex; gap: 12px; justify-content: flex-end;">
                            <button type="button" onclick="closeSubModal()" class="btn-admin btn-admin-secondary">Cancel</button>
                            <button type="submit" class="btn-admin btn-admin-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </main>
</div>

<script>
    function editSubcategory(id, catId, name, desc, status) {
        document.getElementById('editSubId').value = id;
        document.getElementById('editSubCatId').value = catId;
        document.getElementById('editSubName').value = name;
        document.getElementById('editSubDesc').value = desc;
        document.getElementById('editSubActive').checked = (status === 'ACTIVE');
        document.getElementById('editSubModal').style.display = 'flex';
    }

    function closeSubModal() {
        document.getElementById('editSubModal').style.display = 'none';
    }
</script>

<%@ include file="/WEB-INF/views/admin/common/admin-footer.jsp" %>
