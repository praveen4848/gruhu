package com.gruhu.controller.admin;

import com.gruhu.model.Admin;
import com.gruhu.service.AdminService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/login", "/admin/logout", "/admin/profile"})
public class AdminAuthServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("admin");
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/admin/login?logout=true");
            return;
        }

        if ("/admin/profile".equals(path)) {
            HttpSession session = request.getSession(false);
            Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }
            Admin freshAdmin = adminService.getAdminById(admin.getAdminId());
            if (freshAdmin != null) {
                session.setAttribute("admin", freshAdmin);
            }
            request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
            return;
        }

        // Default: /admin/login
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("admin") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/admin/profile".equals(path)) {
            handleProfileUpdate(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (!ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(password)) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
            return;
        }

        Admin admin = adminService.authenticate(username, password);
        if (admin != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("admin", admin);
            session.setAttribute("adminUser", admin);
            try {
                com.gruhu.service.CustomerService customerService = new com.gruhu.service.CustomerService();
                com.gruhu.model.Customer customer = customerService.getCustomerByEmail(admin.getEmail());
                if (customer != null) {
                    session.setAttribute("customer", customer);
                    com.gruhu.service.CartService cartService = new com.gruhu.service.CartService();
                    session.setAttribute("cartCount", cartService.getCartCount(customer.getCustomerId()));
                    session.setAttribute("wishlistCount", cartService.getWishlistCount(customer.getCustomerId()));
                }
            } catch (Exception ignored) {}
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid administrator credentials. Please check and retry.");
            request.setAttribute("enteredUsername", username);
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateInfo".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");

            if (!ValidationUtil.isNotEmpty(name) || !ValidationUtil.isValidEmail(email)) {
                request.setAttribute("errorMessage", "Valid administrator name and email are required.");
            } else {
                boolean success = adminService.updateProfile(admin.getAdminId(), name.trim(), email.trim());
                if (success) {
                    admin.setName(name.trim());
                    admin.setEmail(email.trim());
                    session.setAttribute("admin", admin);
                    request.setAttribute("successMessage", "Profile credentials updated successfully.");
                } else {
                    request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
                }
            }
        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!ValidationUtil.isNotEmpty(currentPassword) || !ValidationUtil.isNotEmpty(newPassword)) {
                request.setAttribute("errorMessage", "Please provide all required password fields.");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "New password and confirmation do not match.");
            } else if (newPassword.length() < 6) {
                request.setAttribute("errorMessage", "New password must be at least 6 characters long.");
            } else {
                boolean changed = adminService.changePassword(admin.getAdminId(), currentPassword, newPassword);
                if (changed) {
                    request.setAttribute("successMessage", "Security passphrase changed successfully.");
                } else {
                    request.setAttribute("errorMessage", "Current password verification failed. Please try again.");
                }
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
    }
}
