<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String email = (String) request.getAttribute("email");
    String redirect = (String) request.getAttribute("redirect");
    if (redirect == null) redirect = request.getParameter("redirect");
    request.setAttribute("extraCss", "auth.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="auth-page">
    <div class="auth-card-container">

        <!-- Form Side -->
        <div class="auth-form-side">
            <div class="auth-header">
                <span class="auth-tag">Welcome to Gruhu</span>
                <h1>Sign In</h1>
                <p>Access your saved wishlist, order history, and architectural consultation notes.</p>
            </div>

            <% if (errorMessage != null) { %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <% if (redirect != null && !redirect.isEmpty()) { %>
                    <input type="hidden" name="redirect" value="<%= redirect %>">
                <% } %>

                <div class="form-group">
                    <label for="loginEmail">Email Address</label>
                    <input type="email" id="loginEmail" name="email" class="form-input" 
                           placeholder="name@example.com" value="<%= email != null ? email : "" %>" required>
                </div>

                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: baseline;">
                        <label for="loginPassword">Password</label>
                        <a href="#" style="font-size: 0.78rem; color: var(--text-muted);">Forgot Password?</a>
                    </div>
                    <input type="password" id="loginPassword" name="password" class="form-input" 
                           placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 10px;">
                    <span>Sign In to Atelier</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>

            <div class="auth-footer-prompt">
                Don't have an account yet? 
                <a href="${pageContext.request.contextPath}/register">Create Account</a>
            </div>

            <div style="margin-top: 18px; padding-top: 14px; border-top: 1px dashed var(--border-subtle); text-align: center; font-size: 0.85rem; color: var(--text-secondary);">
                <span>Atelier Curator / Administrator?</span>
                <a href="${pageContext.request.contextPath}/admin/login" style="font-weight: 600; color: var(--feldgrau); text-decoration: underline; margin-left: 6px;">
                    <i class="fa-solid fa-lock"></i> Curator Portal
                </a>
            </div>
        </div>

        <!-- Visual Image Side -->
        <div class="auth-visual-side">
            <img src="https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1000&q=80" 
                 alt="Gruhu Scandinavian Atelier Interior">
            <div class="auth-visual-overlay">
                <p class="auth-visual-quote">&ldquo;Simplicity is not the lack of clutter, that&rsquo;s simply a consequence of simplicity. Simplicity is somehow essentially describing the purpose and place of an object.&rdquo;</p>
                <span class="auth-visual-author">The Gruhu Design Manifesto</span>
            </div>
        </div>

    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
