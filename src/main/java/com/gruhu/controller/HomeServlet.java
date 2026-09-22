package com.gruhu.controller;

import com.gruhu.model.Category;
import com.gruhu.model.Customer;
import com.gruhu.model.Product;
import com.gruhu.service.CartService;
import com.gruhu.service.CategoryService;
import com.gruhu.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CategoryService categoryService = new CategoryService();
    private final ProductService productService = new ProductService();
    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ensure session badge counts are fresh for logged in customer
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("customer") != null) {
            Customer customer = (Customer) session.getAttribute("customer");
            int cartCount = cartService.getCartCount(customer.getCustomerId());
            int wishlistCount = cartService.getWishlistCount(customer.getCustomerId());
            session.setAttribute("cartCount", cartCount);
            session.setAttribute("wishlistCount", wishlistCount);
        } else if (session != null) {
            com.gruhu.model.Cart guestCart = (com.gruhu.model.Cart) session.getAttribute("guestCart");
            if (guestCart != null) {
                session.setAttribute("cartCount", guestCart.getTotalQuantity());
            }
            @SuppressWarnings("unchecked")
            java.util.Set<Integer> guestWishlist = (java.util.Set<Integer>) session.getAttribute("guestWishlist");
            if (guestWishlist != null) {
                session.setAttribute("wishlistCount", guestWishlist.size());
            }
        }

        // Fetch curated categories and featured products for home showcase
        List<Category> categories = categoryService.getActiveCategories();
        List<Product> featuredProducts = productService.getFeaturedProducts(8);

        request.setAttribute("categories", categories);
        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("homeProducts", featuredProducts);
        request.setAttribute("extraCss", "home.css");
        request.setAttribute("pageTitle", "Gruhu — Architectural Home Interior & Living");

        request.getRequestDispatcher("/WEB-INF/views/customer/home.jsp").forward(request, response);
    }
}