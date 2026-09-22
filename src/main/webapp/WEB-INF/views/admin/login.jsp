<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curator Authentication — Gruhu Atelier</title>
    
    <!-- Google Fonts: Inter & Playfair Display -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@500;600;700&display=swap" rel="stylesheet">
    
    <!-- FontAwesome 6 Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Admin CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-login-body">
    <div class="admin-login-card">
        <h1 class="brand-title">GRUHU</h1>
        <p class="brand-sub">Curator Management Console</p>

        <% String error = (String) request.getAttribute("errorMessage");
           if (error != null) { %>
            <div class="admin-alert admin-alert-danger" style="margin-bottom: 20px;">
                <i class="fa-solid fa-circle-exclamation"></i>
                <span><%= error %></span>
            </div>
        <% } %>

        <% if ("true".equals(request.getParameter("logout"))) { %>
            <div class="admin-alert admin-alert-success" style="margin-bottom: 20px;">
                <i class="fa-solid fa-check"></i>
                <span>You have safely logged out of the curator session.</span>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/admin/login" method="post">
            <div class="form-group-admin">
                <label class="form-label-admin">Curator Email or Username</label>
                <input type="text" name="username" class="form-control-admin" required autofocus 
                       value="${enteredUsername != null ? enteredUsername : ''}" placeholder="curator@gruhu.atelier">
            </div>

            <div class="form-group-admin" style="margin-bottom: 28px;">
                <label class="form-label-admin">Security Key / Password</label>
                <input type="password" name="password" class="form-control-admin" required placeholder="Enter password">
            </div>

            <button type="submit" class="btn-admin btn-admin-primary" style="width: 100%; justify-content: center; padding: 12px;">
                <i class="fa-solid fa-lock-open"></i>
                <span>Access Atelier Console</span>
            </button>
        </form>

        <div style="text-align: center; margin-top: 24px;">
            <a href="${pageContext.request.contextPath}/home" style="color: #8c857b; text-decoration: none; font-size: 0.8rem;">
                <i class="fa-solid fa-arrow-left"></i> Return to Public Atelier Boutique
            </a>
        </div>
    </div>
</body>
</html>
