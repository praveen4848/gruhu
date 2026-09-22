<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gruhu.model.Customer" %>

<%
    Customer customer = (Customer) request.getAttribute("customer");
    if (customer == null && session != null) {
        customer = (Customer) session.getAttribute("customer");
        if (customer == null && session.getAttribute("admin") != null) {
            com.gruhu.model.Admin adminObj = (com.gruhu.model.Admin) session.getAttribute("admin");
            com.gruhu.service.CustomerService cs = new com.gruhu.service.CustomerService();
            customer = cs.getCustomerByEmail(adminObj.getEmail());
            if (customer != null) {
                session.setAttribute("customer", customer);
            }
        }
    }
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/login?redirect=" +
                java.net.URLEncoder.encode(request.getContextPath() + "/profile", java.nio.charset.StandardCharsets.UTF_8));
        return;
    }
    String profileSuccess = (String) request.getAttribute("profileSuccess");
    String profileError = (String) request.getAttribute("profileError");
    String passwordSuccess = (String) request.getAttribute("passwordSuccess");
    String passwordError = (String) request.getAttribute("passwordError");
    request.setAttribute("extraCss", "auth.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="account-page">
    <div class="account-header">
        <div>
            <span class="auth-tag">Client Account</span>
            <h1 style="font-family: var(--font-serif); font-size: 2.4rem; color: var(--dark-espresso); margin-top: 4px;">Personal Profile</h1>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="color: var(--status-danger); border-color: var(--border-strong);">
                <i class="fa-solid fa-arrow-right-from-bracket"></i>
                <span>Sign Out</span>
            </a>
        </div>
    </div>

    <!-- Account Navigation Tabs -->
    <div class="account-tabs-nav">
        <a href="${pageContext.request.contextPath}/profile" class="account-tab-item active">
            <i class="fa-regular fa-id-card"></i> Personal Profile
        </a>
        <a href="${pageContext.request.contextPath}/addresses" class="account-tab-item">
            <i class="fa-solid fa-location-dot"></i> Delivery Addresses
        </a>
        <a href="${pageContext.request.contextPath}/my-orders" class="account-tab-item">
            <i class="fa-solid fa-box-archive"></i> Order History
        </a>
        <a href="${pageContext.request.contextPath}/wishlist" class="account-tab-item">
            <i class="fa-regular fa-heart"></i> Saved Wishlist
        </a>
    </div>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">

        <!-- Personal Info Card -->
        <div style="background: #ffffff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); padding: 32px;">
            <h3 style="font-family: var(--font-serif); font-size: 1.5rem; margin-bottom: 20px;">Contact Details</h3>

            <% if (profileSuccess != null) { %>
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <span><%= profileSuccess %></span></div>
            <% } %>
            <% if (profileError != null) { %>
                <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> <span><%= profileError %></span></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/profile" method="post">
                <input type="hidden" name="action" value="update_profile">

                <div class="form-group">
                    <label>Account Email (Primary ID)</label>
                    <input type="email" class="form-input" value="<%= customer.getEmail() != null ? customer.getEmail() : "" %>" disabled 
                           style="background-color: var(--bg-sand-light); color: var(--text-muted); cursor: not-allowed;">
                </div>

                <div class="form-group">
                    <label for="profName">Full Name</label>
                    <input type="text" id="profName" name="fullName" class="form-input" value="<%= customer.getFullName() != null ? customer.getFullName() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="profPhone">Mobile Phone</label>
                    <input type="tel" id="profPhone" name="phone" class="form-input" value="<%= customer.getPhone() != null ? customer.getPhone() : "" %>" required>
                </div>

                <button type="submit" class="btn btn-primary" style="margin-top: 10px;">Save Profile Changes</button>
            </form>
        </div>

        <!-- Change Password Card -->
        <div style="background: #ffffff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); padding: 32px;">
            <h3 style="font-family: var(--font-serif); font-size: 1.5rem; margin-bottom: 20px;">Security & Password</h3>

            <% if (passwordSuccess != null) { %>
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <span><%= passwordSuccess %></span></div>
            <% } %>
            <% if (passwordError != null) { %>
                <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> <span><%= passwordError %></span></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/profile" method="post">
                <input type="hidden" name="action" value="change_password">

                <div class="form-group">
                    <label for="currPass">Current Password</label>
                    <input type="password" id="currPass" name="currentPassword" class="form-input" required>
                </div>

                <div class="form-group">
                    <label for="newPass">New Secure Password</label>
                    <input type="password" id="newPass" name="newPassword" class="form-input" required>
                </div>

                <div class="form-group">
                    <label for="confPass">Confirm New Password</label>
                    <input type="password" id="confPass" name="confirmPassword" class="form-input" required>
                </div>

                <button type="submit" class="btn btn-outline" style="margin-top: 10px;">Update Password</button>
            </form>
        </div>

    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
