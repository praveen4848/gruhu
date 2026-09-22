<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String fullName = (String) request.getAttribute("fullName");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    request.setAttribute("extraCss", "auth.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="auth-page">
    <div class="auth-card-container">

        <!-- Form Side -->
        <div class="auth-form-side">
            <div class="auth-header">
                <span class="auth-tag">Join the Atelier Circle</span>
                <h1>Create Account</h1>
                <p>Register to save interior curated spaces, enjoy white glove checkout, and track private orders.</p>
            </div>

            <% if (errorMessage != null) { %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label for="regName">Full Legal Name</label>
                    <input type="text" id="regName" name="fullName" class="form-input" 
                           placeholder="e.g. Maya Iyer" value="<%= fullName != null ? fullName : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="regEmail">Email Address</label>
                    <input type="email" id="regEmail" name="email" class="form-input" 
                           placeholder="name@domain.com" value="<%= email != null ? email : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="regPhone">Mobile Number (10 Digits)</label>
                    <input type="tel" id="regPhone" name="phone" class="form-input" 
                           placeholder="9876543210" value="<%= phone != null ? phone : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="regPass">Create Password (min. 6 chars)</label>
                    <input type="password" id="regPass" name="password" class="form-input" 
                           placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;" required>
                </div>

                <div class="form-group">
                    <label for="regConfirmPass">Confirm Password</label>
                    <input type="password" id="regConfirmPass" name="confirmPassword" class="form-input" 
                           placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 10px;">
                    <span>Complete Registration</span>
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>

            <div class="auth-footer-prompt">
                Already registered with Gruhu? 
                <a href="${pageContext.request.contextPath}/login">Sign In</a>
            </div>
        </div>

        <!-- Visual Image Side -->
        <div class="auth-visual-side">
            <img src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1000&q=80" 
                 alt="Gruhu Master Timber Platform Bed">
            <div class="auth-visual-overlay">
                <p class="auth-visual-quote">&ldquo;Your home should be an antidote to the noise of the outside world &mdash; grounded in natural tones and timeless craft.&rdquo;</p>
                <span class="auth-visual-author">Gruhu Architectural Workshop</span>
            </div>
        </div>

    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
