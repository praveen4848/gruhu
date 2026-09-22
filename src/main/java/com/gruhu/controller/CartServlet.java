package com.gruhu.controller;

import com.gruhu.model.Admin;
import com.gruhu.model.Cart;
import com.gruhu.model.CartItem;
import com.gruhu.model.Customer;
import com.gruhu.model.Product;
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

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CartService cartService = new CartService();
    private final ProductService productService = new ProductService();
    private final CustomerService customerService = new CustomerService();

    private Customer resolveCustomer(HttpSession session) {
        if (session == null) return null;
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer != null) return customer;

        // Auto-link logged-in Curator/Admin to customer account if present
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

    private Cart getOrCreateGuestCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("guestCart");
        if (cart == null) {
            cart = new Cart(0, 0, new Timestamp(System.currentTimeMillis()), new Timestamp(System.currentTimeMillis()));
            session.setAttribute("guestCart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);

        Cart cart;
        if (customer != null) {
            cart = cartService.getCart(customer.getCustomerId());
        } else {
            cart = getOrCreateGuestCart(session);
        }

        int cartCount = (cart != null) ? cart.getTotalQuantity() : 0;
        session.setAttribute("cartCount", cartCount);

        request.setAttribute("cart", cart);
        request.setAttribute("pageTitle", "Your Atelier Bag — Gruhu");

        request.getRequestDispatcher("/WEB-INF/views/customer/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);

        String action = request.getParameter("action");
        if (action == null) action = "add";

        boolean isAjax = "true".equalsIgnoreCase(request.getParameter("ajax"))
                || "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        int updatedCount = 0;
        String message = "Updated your Atelier Bag.";

        try {
            if ("add".equalsIgnoreCase(action)) {
                int productId = ValidationUtil.parseInt(request.getParameter("productId"), 0);
                int quantity = ValidationUtil.parseInt(request.getParameter("quantity"), 1);

                if (productId > 0 && quantity > 0) {
                    if (customer != null) {
                        cartService.addToCart(customer.getCustomerId(), productId, quantity);
                        updatedCount = cartService.getCartCount(customer.getCustomerId());
                    } else {
                        Cart guestCart = getOrCreateGuestCart(session);
                        Product p = productService.getProductById(productId);
                        if (p != null) {
                            boolean found = false;
                            for (CartItem item : guestCart.getItems()) {
                                if (item.getProductId() == productId) {
                                    item.setQuantity(item.getQuantity() + quantity);
                                    found = true;
                                    break;
                                }
                            }
                            if (!found) {
                                int fakeId = guestCart.getItems().size() + 1;
                                CartItem item = new CartItem(fakeId, 0, productId, quantity, new Timestamp(System.currentTimeMillis()));
                                item.setProduct(p);
                                guestCart.getItems().add(item);
                            }
                        }
                        updatedCount = guestCart.getTotalQuantity();
                    }
                    message = "Sculptural piece added to your Atelier Bag.";
                }
            } else if ("update".equalsIgnoreCase(action)) {
                int cartItemId = ValidationUtil.parseInt(request.getParameter("cartItemId"), 0);
                int quantity = ValidationUtil.parseInt(request.getParameter("quantity"), 1);

                if (customer != null) {
                    if (cartItemId > 0) {
                        cartService.updateQuantity(customer.getCustomerId(), cartItemId, quantity);
                    }
                    updatedCount = cartService.getCartCount(customer.getCustomerId());
                } else {
                    Cart guestCart = getOrCreateGuestCart(session);
                    guestCart.getItems().removeIf(item -> item.getCartItemId() == cartItemId && quantity <= 0);
                    for (CartItem item : guestCart.getItems()) {
                        if (item.getCartItemId() == cartItemId) {
                            item.setQuantity(quantity);
                            break;
                        }
                    }
                    updatedCount = guestCart.getTotalQuantity();
                }
                message = "Quantity updated.";
            } else if ("remove".equalsIgnoreCase(action)) {
                int cartItemId = ValidationUtil.parseInt(request.getParameter("cartItemId"), 0);

                if (customer != null) {
                    if (cartItemId > 0) {
                        cartService.removeFromCart(customer.getCustomerId(), cartItemId);
                    }
                    updatedCount = cartService.getCartCount(customer.getCustomerId());
                } else {
                    Cart guestCart = getOrCreateGuestCart(session);
                    guestCart.getItems().removeIf(item -> item.getCartItemId() == cartItemId);
                    updatedCount = guestCart.getTotalQuantity();
                }
                message = "Object removed from your bag.";
            } else if ("clear".equalsIgnoreCase(action)) {
                if (customer != null) {
                    cartService.clearCart(customer.getCustomerId());
                } else {
                    Cart guestCart = getOrCreateGuestCart(session);
                    guestCart.getItems().clear();
                }
                updatedCount = 0;
                message = "Atelier Bag emptied.";
            }

            session.setAttribute("cartCount", updatedCount);

        } catch (IllegalArgumentException ex) {
            session.setAttribute("cartError", ex.getMessage());
            message = ex.getMessage();
        }

        if (isAjax) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(String.format("{\"success\":true,\"cartCount\":%d,\"message\":\"%s\"}", updatedCount, message));
            return;
        }

        String referer = request.getHeader("referer");
        if ("add".equalsIgnoreCase(action) && referer != null && !referer.contains("/cart")) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
