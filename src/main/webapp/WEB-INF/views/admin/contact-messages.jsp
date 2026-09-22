<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.ContactMessage" %>

<%
    List<ContactMessage> messages = (List<ContactMessage>) request.getAttribute("messages");
    String success = request.getParameter("success");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Curator Inquiries & Consultations (<%= messages != null ? messages.size() : 0 %>)</h1>
        </div>
        <div class="topbar-right">
            <span style="font-size: 0.85rem; color: var(--admin-text-muted);">Direct Patron Communications</span>
        </div>
    </header>

    <main class="admin-content">

        <% if ("updated".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Message state updated.</span>
            </div>
        <% } %>

        <div class="admin-card">
            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Inquiry ID</th>
                            <th>Sender</th>
                            <th>Subject</th>
                            <th>Inquiry Message</th>
                            <th>Received Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (messages != null && !messages.isEmpty()) {
                            for (ContactMessage m : messages) {
                                String status = m.getStatus() != null ? m.getStatus() : "NEW";
                        %>
                            <tr>
                                <td><strong>#MSG-<%= m.getMessageId() %></strong></td>
                                <td>
                                    <div style="font-weight: 600;"><%= m.getName() %></div>
                                    <small style="color: var(--admin-text-muted);"><%= m.getEmail() %></small>
                                </td>
                                <td><strong><%= m.getSubject() != null ? m.getSubject() : "Consultation" %></strong></td>
                                <td style="max-width: 320px; font-size: 0.85rem; line-height: 1.5; color: var(--admin-text-main);">
                                    <%= m.getMessage() %>
                                </td>
                                <td style="color: var(--admin-text-muted); font-size: 0.8rem; white-space: nowrap;">
                                    <%= m.getCreatedAt() != null ? m.getCreatedAt().toString().substring(0, 16) : "N/A" %>
                                </td>
                                <td>
                                    <span class="admin-badge <%= "NEW".equalsIgnoreCase(status) ? "badge-placed" : ("READ".equalsIgnoreCase(status) ? "badge-confirmed" : "badge-active") %>">
                                        <%= status %>
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <a href="mailto:<%= m.getEmail() %>?subject=Re:%20<%= m.getSubject() != null ? m.getSubject() : "Gruhu Consultation" %>" 
                                           class="btn-admin btn-admin-primary btn-admin-sm" title="Reply via Email">
                                            <i class="fa-solid fa-reply"></i>
                                        </a>

                                        <% if ("NEW".equalsIgnoreCase(status)) { %>
                                            <form action="${pageContext.request.contextPath}/admin/messages" method="post" style="display: inline;">
                                                <input type="hidden" name="messageId" value="<%= m.getMessageId() %>">
                                                <input type="hidden" name="status" value="READ">
                                                <button type="submit" class="btn-admin btn-admin-secondary btn-admin-sm" title="Mark as Read">
                                                    Mark Read
                                                </button>
                                            </form>
                                        <% } else if ("READ".equalsIgnoreCase(status)) { %>
                                            <form action="${pageContext.request.contextPath}/admin/messages" method="post" style="display: inline;">
                                                <input type="hidden" name="messageId" value="<%= m.getMessageId() %>">
                                                <input type="hidden" name="status" value="RESPONDED">
                                                <button type="submit" class="btn-admin btn-admin-secondary btn-admin-sm" title="Mark as Responded">
                                                    Mark Responded
                                                </button>
                                            </form>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: var(--admin-text-muted); padding: 40px;">
                                    No customer inquiries currently awaiting consultation.
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
