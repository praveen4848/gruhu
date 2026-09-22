package com.gruhu.controller.admin;

import com.gruhu.model.Product;
import com.gruhu.service.ProductService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/stock")
public class AdminStockServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filter = request.getParameter("filter");
        List<Product> products = productService.getAllProductsForAdmin();

        if ("low".equalsIgnoreCase(filter)) {
            products = products.stream()
                    .filter(p -> p.getStockQuantity() <= 5 && p.getStockQuantity() > 0)
                    .collect(Collectors.toList());
        } else if ("out".equalsIgnoreCase(filter)) {
            products = products.stream()
                    .filter(p -> p.getStockQuantity() == 0)
                    .collect(Collectors.toList());
        }

        request.setAttribute("products", products);
        request.setAttribute("activeFilter", filter != null ? filter : "all");
        request.setAttribute("pageTitle", "Inventory & Studio Stock — Gruhu Atelier");

        request.getRequestDispatcher("/WEB-INF/views/admin/stock.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int productId = ValidationUtil.parseInt(request.getParameter("productId"), 0);

        if (productId > 0) {
            if ("set".equalsIgnoreCase(action)) {
                int quantity = ValidationUtil.parseInt(request.getParameter("quantity"), 0);
                productService.setStock(productId, quantity);
            } else if ("adjust".equalsIgnoreCase(action)) {
                int change = ValidationUtil.parseInt(request.getParameter("change"), 0);
                productService.updateStock(productId, change);
            }
        }

        String redirectFilter = request.getParameter("filter");
        String redirectUrl = request.getContextPath() + "/admin/stock?success=updated";
        if (redirectFilter != null && !redirectFilter.isEmpty()) {
            redirectUrl += "&filter=" + redirectFilter;
        }

        response.sendRedirect(redirectUrl);
    }
}
