package com.gruhu.controller;

import com.gruhu.model.Admin;
import com.gruhu.model.Customer;
import com.gruhu.model.Product;
import com.gruhu.model.Wishlist;
import com.gruhu.service.CartService;
import com.gruhu.service.CustomerService;
import com.gruhu.service.ProductService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CartService cartService = new CartService();
    private final ProductService productService = new ProductService();
    private final CustomerService customerService = new CustomerService();

    private Customer resolveCustomer(HttpSession session) {
        if (session == null) return null;
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer != null) return customer;

        Admin admin = (Admin) session.getAttribute("admin");
        if (admin != null) {
            customer = customerService.getCustomerByEmail(admin.getEmail());
            if (customer != null) {
                session.setAttribute("customer", customer);
                return customer;
            }
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    private Set<Integer> getOrCreateGuestWishlist(HttpSession session) {
        Set<Integer> set = (Set<Integer>) session.getAttribute("guestWishlist");
        if (set == null) {
            set = new LinkedHashSet<>();
            session.setAttribute("guestWishlist", set);
        }
        return set;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);

        List<Wishlist> wishlistItems = new ArrayList<>();
        if (customer != null) {
            wishlistItems = cartService.getWishlist(customer.getCustomerId());
        } else {
            Set<Integer> guestWishlist = getOrCreateGuestWishlist(session);
            int idx = 1;
            for (Integer pId : guestWishlist) {
                Product p = productService.getProductById(pId);
                if (p != null) {
                    Wishlist w = new Wishlist(idx++, 0, pId, new Timestamp(System.currentTimeMillis()));
                    w.setProduct(p);
                    wishlistItems.add(w);
                }
            }
        }

        int count = wishlistItems.size();
        session.setAttribute("wishlistCount", count);

        request.setAttribute("wishlistItems", wishlistItems);
        request.setAttribute("pageTitle", "Saved Objects & Wishlist — Gruhu");

        request.getRequestDispatcher("/WEB-INF/views/customer/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);

        String action = request.getParameter("action");
        if (action == null) action = "toggle";
        int productId = ValidationUtil.parseInt(request.getParameter("productId"), 0);

        boolean isAjax = "true".equalsIgnoreCase(request.getParameter("ajax"))
                || "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        boolean inWishlist = false;
        int count = 0;
        String message = "Wishlist updated.";

        if (productId > 0) {
            if (customer != null) {
                if ("remove".equalsIgnoreCase(action)) {
                    cartService.removeFromWishlist(customer.getCustomerId(), productId);
                    inWishlist = false;
                    message = "Removed from your Wishlist.";
                } else if ("add".equalsIgnoreCase(action)) {
                    cartService.addToWishlist(customer.getCustomerId(), productId);
                    inWishlist = true;
                    message = "Saved to your Wishlist.";
                } else if ("toggle".equalsIgnoreCase(action)) {
                    if (cartService.isInWishlist(customer.getCustomerId(), productId)) {
                        cartService.removeFromWishlist(customer.getCustomerId(), productId);
                        inWishlist = false;
                        message = "Removed from your Wishlist.";
                    } else {
                        cartService.addToWishlist(customer.getCustomerId(), productId);
                        inWishlist = true;
                        message = "Saved to your Wishlist.";
                    }
                }
                count = cartService.getWishlistCount(customer.getCustomerId());
            } else {
                Set<Integer> guestWishlist = getOrCreateGuestWishlist(session);
                if ("remove".equalsIgnoreCase(action)) {
                    guestWishlist.remove(productId);
                    inWishlist = false;
                    message = "Removed from your Wishlist.";
                } else if ("add".equalsIgnoreCase(action)) {
                    guestWishlist.add(productId);
                    inWishlist = true;
                    message = "Saved to your Wishlist.";
                } else if ("toggle".equalsIgnoreCase(action)) {
                    if (guestWishlist.contains(productId)) {
                        guestWishlist.remove(productId);
                        inWishlist = false;
                        message = "Removed from your Wishlist.";
                    } else {
                        guestWishlist.add(productId);
                        inWishlist = true;
                        message = "Saved to your Wishlist.";
                    }
                }
                count = guestWishlist.size();
            }

            session.setAttribute("wishlistCount", count);
        }

        if (isAjax) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(String.format("{\"success\":true,\"wishlistCount\":%d,\"inWishlist\":%b,\"message\":\"%s\"}", count, inWishlist, message));
            return;
        }

        String referer = request.getHeader("referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }
}
