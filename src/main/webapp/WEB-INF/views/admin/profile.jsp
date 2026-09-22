<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gruhu.model.Admin" %>

<%
    Admin admin = (Admin) session.getAttribute("admin");
    String success = (String) request.getAttribute("successMessage");
    String error = (String) request.getAttribute("errorMessage");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Curator Security & Profile</h1>
        </div>
    </header>

    <main class="admin-content">

        <% if (success != null) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span><%= success %></span>
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="admin-alert admin-alert-danger">
                <i class="fa-solid fa-circle-exclamation"></i>
                <span><%= error %></span>
            </div>
        <% } %>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">

            <!-- Profile Info Form -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">Curator Account Information</h2>
                </div>
                <div class="admin-card-body">
                    <form action="${pageContext.request.contextPath}/admin/profile" method="post">
                        <input type="hidden" name="action" value="updateInfo">

                        <div class="form-group-admin">
                            <label class="form-label-admin">Curator Handle / Username</label>
                            <input type="text" class="form-control-admin" value="<%= admin != null ? admin.getUsername() : "admin" %>" disabled
                                   style="background-color: #f2eee8; cursor: not-allowed;">
                            <small style="color: var(--admin-text-muted);">Immutable system administrator identifier.</small>
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Full Legal Name *</label>
                            <input type="text" name="name" class="form-control-admin" required 
                                   value="<%= admin != null ? admin.getName() : "" %>">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Administrative Email Address *</label>
                            <input type="email" name="email" class="form-control-admin" required 
                                   value="<%= admin != null ? admin.getEmail() : "" %>">
                        </div>

                        <button type="submit" class="btn-admin btn-admin-primary">
                            <i class="fa-solid fa-floppy-disk"></i> Update Profile
                        </button>
                    </form>
                </div>
            </div>

            <!-- Password Change Form -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">Security Key Passphrase</h2>
                </div>
                <div class="admin-card-body">
                    <form action="${pageContext.request.contextPath}/admin/profile" method="post">
                        <input type="hidden" name="action" value="changePassword">

                        <div class="form-group-admin">
                            <label class="form-label-admin">Existing Passphrase *</label>
                            <input type="password" name="currentPassword" class="form-control-admin" required placeholder="Enter current password">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">New Passphrase *</label>
                            <input type="password" name="newPassword" class="form-control-admin" required placeholder="Minimum 6 characters">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Confirm New Passphrase *</label>
                            <input type="password" name="confirmPassword" class="form-control-admin" required placeholder="Re-type new passphrase">
                        </div>

                        <button type="submit" class="btn-admin btn-admin-secondary">
                            <i class="fa-solid fa-key"></i> Change Passphrase
                        </button>
                    </form>
                </div>
            </div>

        </div>

    </main>
</div>

<%@ include file="/WEB-INF/views/admin/common/admin-footer.jsp" %>
