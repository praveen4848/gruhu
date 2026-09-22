<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Customer" %>

<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    String success = request.getParameter("success");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Patron Registry (<%= customers != null ? customers.size() : 0 %>)</h1>
        </div>
        <div class="topbar-right">
            <span style="font-size: 0.85rem; color: var(--admin-text-muted);">Verified Boutique Patrons</span>
        </div>
    </header>

    <main class="admin-content">

        <% if ("statusUpdated".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Customer privileges synchronized successfully.</span>
            </div>
        <% } %>

        <div class="admin-card">
            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Patron ID</th>
                            <th>Full Name</th>
                            <th>Contact Email</th>
                            <th>Mobile</th>
                            <th>Member Since</th>
                            <th>Access State</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (customers != null && !customers.isEmpty()) {
                            for (Customer c : customers) {
                                boolean isActive = "ACTIVE".equalsIgnoreCase(c.getStatus());
                        %>
                            <tr>
                                <td><strong>#PAT-<%= c.getCustomerId() %></strong></td>
                                <td>
                                    <div style="font-weight: 600;"><%= c.getFullName() %></div>
                                </td>
                                <td><%= c.getEmail() %></td>
                                <td>+91 <%= c.getPhone() %></td>
                                <td style="color: var(--admin-text-muted); font-size: 0.82rem;">
                                    <%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0, 10) : "N/A" %>
                                </td>
                                <td>
                                    <span class="admin-badge <%= isActive ? "badge-active" : "badge-blocked" %>">
                                        <%= c.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/customers" method="post" style="display: inline;">
                                        <input type="hidden" name="customerId" value="<%= c.getCustomerId() %>">
                                        <input type="hidden" name="status" value="<%= isActive ? "BLOCKED" : "ACTIVE" %>">
                                        <button type="submit" class="btn-admin <%= isActive ? "btn-admin-danger" : "btn-admin-secondary" %> btn-admin-sm"
                                                onclick="return confirm('<%= isActive ? "Suspend access for" : "Restore privileges for" %> <%= c.getFullName() %>?');">
                                            <%= isActive ? "Suspend Access" : "Activate" %>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: var(--admin-text-muted); padding: 40px;">
                                    No registered patrons recorded in the atelier database.
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
