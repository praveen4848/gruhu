package com.gruhu.controller;

import com.gruhu.model.Address;
import com.gruhu.model.Admin;
import com.gruhu.model.Customer;
import com.gruhu.service.AdminService;
import com.gruhu.service.CartService;
import com.gruhu.service.CustomerService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/login", "/register", "/logout", "/profile", "/addresses"})
public class CustomerAuthServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CustomerService customerService = new CustomerService();
    private final CartService cartService = new CartService();
    private final AdminService adminService = new AdminService();

    private Customer resolveCustomer(HttpSession session) {
        if (session == null) return null;
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer != null) return customer;

        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            admin = (Admin) session.getAttribute("adminUser");
        }
        if (admin != null && admin.getEmail() != null) {
            customer = customerService.getCustomerByEmail(admin.getEmail());
            if (customer == null) {
                try {
                    customer = customerService.register(
                            admin.getName() != null ? admin.getName() : "Administrator",
                            admin.getEmail(),
                            "9989055955",
                            "AdminAtelierPass123!"
                    );
                } catch (Exception ignored) {
                    customer = customerService.getCustomerByEmail(admin.getEmail());
                }
            }
            if (customer != null) {
                session.setAttribute("customer", customer);
                try {
                    session.setAttribute("cartCount", cartService.getCartCount(customer.getCustomerId()));
                    session.setAttribute("wishlistCount", cartService.getWishlistCount(customer.getCustomerId()));
                } catch (Exception ignored) {}
                return customer;
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/login":
                showLogin(request, response);
                break;
            case "/register":
                showRegister(request, response);
                break;
            case "/logout":
                handleLogout(request, response);
                break;
            case "/profile":
                showProfile(request, response);
                break;
            case "/addresses":
                showAddresses(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/login":
                processLogin(request, response);
                break;
            case "/register":
                processRegister(request, response);
                break;
            case "/profile":
                processProfileUpdate(request, response);
                break;
            case "/addresses":
                processAddressAction(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private void showLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && resolveCustomer(session) != null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        request.setAttribute("pageTitle", "Client Sign In — Gruhu Atelier");
        request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
    }

    private void showRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && resolveCustomer(session) != null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        request.setAttribute("pageTitle", "Create Client Account — Gruhu Atelier");
        request.getRequestDispatcher("/WEB-INF/views/customer/register.jsp").forward(request, response);
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        // 1. Check if user is an Atelier Curator / Administrator
        Admin admin = adminService.authenticate(email, password);
        if (admin != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("admin", admin);
            session.setAttribute("adminUser", admin);

            Customer customer = customerService.getCustomerByEmail(admin.getEmail());
            if (customer != null) {
                session.setAttribute("customer", customer);
                session.setAttribute("cartCount", cartService.getCartCount(customer.getCustomerId()));
                session.setAttribute("wishlistCount", cartService.getWishlistCount(customer.getCustomerId()));
            }

            if (ValidationUtil.isNotEmpty(redirect)) {
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/profile");
            }
            return;
        }

        // 2. Client Authentication
        Customer customer = customerService.authenticate(email, password);

        if (customer != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("customer", customer);

            int cartCount = cartService.getCartCount(customer.getCustomerId());
            int wishlistCount = cartService.getWishlistCount(customer.getCustomerId());
            session.setAttribute("cartCount", cartCount);
            session.setAttribute("wishlistCount", wishlistCount);

            if (ValidationUtil.isNotEmpty(redirect)) {
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email address or password. Please verify and retry.");
            request.setAttribute("email", email);
            request.setAttribute("redirect", redirect);
            request.setAttribute("pageTitle", "Client Sign In — Gruhu Atelier");
            request.getRequestDispatcher("/WEB-INF/views/customer/login.jsp").forward(request, response);
        }
    }

    private void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Password and confirmation do not match.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/WEB-INF/views/customer/register.jsp").forward(request, response);
            return;
        }

        try {
            Customer customer = customerService.register(fullName, email, phone, password);

            // Auto-login after registration
            HttpSession session = request.getSession(true);
            session.setAttribute("customer", customer);
            session.setAttribute("cartCount", 0);
            session.setAttribute("wishlistCount", 0);

            response.sendRedirect(request.getContextPath() + "/home?welcome=true");

        } catch (RuntimeException ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/WEB-INF/views/customer/register.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }


    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" +
                    java.net.URLEncoder.encode(request.getContextPath() + "/profile", java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        Customer freshCustomer = customerService.getCustomerById(customer.getCustomerId());
        if (freshCustomer == null) {
            freshCustomer = customer;
        }
        request.setAttribute("customer", freshCustomer);
        request.setAttribute("pageTitle", "Client Profile — Gruhu");
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
    }

    private void processProfileUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("change_password".equals(action)) {
            String currentPass = request.getParameter("currentPassword");
            String newPass = request.getParameter("newPassword");
            String confirmPass = request.getParameter("confirmPassword");

            if (!newPass.equals(confirmPass)) {
                request.setAttribute("passwordError", "New passwords do not match.");
            } else if (customerService.changePassword(customer.getCustomerId(), currentPass, newPass)) {
                request.setAttribute("passwordSuccess", "Password updated securely.");
            } else {
                request.setAttribute("passwordError", "Current password was incorrect or new password was too weak.");
            }
        } else {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");

            if (customerService.updateProfile(customer.getCustomerId(), fullName, phone)) {
                customer.setFullName(fullName);
                customer.setPhone(phone);
                session.setAttribute("customer", customer);
                request.setAttribute("profileSuccess", "Your profile details have been saved.");
            } else {
                request.setAttribute("profileError", "Please check your full name and 10-digit phone format.");
            }
        }

        showProfile(request, response);
    }

    private void showAddresses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Address> addresses = customerService.getCustomerAddresses(customer.getCustomerId());
        request.setAttribute("addresses", addresses);
        request.setAttribute("pageTitle", "Delivery Addresses — Gruhu");
        request.getRequestDispatcher("/WEB-INF/views/customer/addresses.jsp").forward(request, response);
    }

    private void processAddressAction(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equalsIgnoreCase(action)) {
            int addressId = ValidationUtil.parseInt(request.getParameter("addressId"), 0);
            customerService.deleteAddress(addressId, customer.getCustomerId());
        } else if ("set_default".equalsIgnoreCase(action)) {
            int addressId = ValidationUtil.parseInt(request.getParameter("addressId"), 0);
            customerService.setDefaultAddress(customer.getCustomerId(), addressId);
        } else if ("add".equalsIgnoreCase(action)) {
            Address address = new Address(
                    0,
                    customer.getCustomerId(),
                    request.getParameter("receiverName"),
                    request.getParameter("phone"),
                    request.getParameter("houseAddress"),
                    request.getParameter("city"),
                    request.getParameter("state"),
                    request.getParameter("pincode"),
                    request.getParameter("addressType"),
                    "on".equalsIgnoreCase(request.getParameter("isDefault")) || "true".equalsIgnoreCase(request.getParameter("isDefault"))
            );
            customerService.addAddress(address);
        }

        response.sendRedirect(request.getContextPath() + "/addresses");
    }
}
