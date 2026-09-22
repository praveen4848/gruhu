package com.gruhu.controller;

import com.gruhu.model.Category;
import com.gruhu.model.Product;
import com.gruhu.model.Subcategory;
import com.gruhu.service.CategoryService;
import com.gruhu.service.ProductService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(urlPatterns = {"/products", "/product-details", "/search"})
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/product-details".equals(path)) {
            handleProductDetails(request, response);
        } else if ("/search".equals(path)) {
            handleSearch(request, response);
        } else {
            handleCatalog(request, response);
        }
    }

    private void handleCatalog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String catParam = request.getParameter("category");
        String subcatParam = request.getParameter("subcategory");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String materialParam = request.getParameter("material");
        String colorParam = request.getParameter("color");
        String sortParam = request.getParameter("sort");
        if (sortParam == null || sortParam.trim().isEmpty()) {
            sortParam = request.getParameter("sortBy");
        }

        Integer categoryId = null;
        if (ValidationUtil.isNotEmpty(catParam)) {
            categoryId = ValidationUtil.parseInt(catParam, 0);
            if (categoryId == 0) categoryId = null;
        }

        Integer subcategoryId = null;
        if (ValidationUtil.isNotEmpty(subcatParam)) {
            subcategoryId = ValidationUtil.parseInt(subcatParam, 0);
            if (subcategoryId == 0) subcategoryId = null;
        }

        BigDecimal minPrice = null;
        if (ValidationUtil.isNotEmpty(minPriceParam)) {
            minPrice = ValidationUtil.parseBigDecimal(minPriceParam, null);
        }

        BigDecimal maxPrice = null;
        if (ValidationUtil.isNotEmpty(maxPriceParam)) {
            maxPrice = ValidationUtil.parseBigDecimal(maxPriceParam, null);
        }

        String roomParam = request.getParameter("room");
        if (roomParam != null) {
            roomParam = roomParam.trim().toLowerCase();
            if (roomParam.isEmpty() || "all".equals(roomParam)) {
                roomParam = null;
            }
        }

        List<Product> products = productService.filterProducts(
                categoryId, subcategoryId, minPrice, maxPrice, materialParam, colorParam, roomParam, sortParam);

        List<Category> categories = categoryService.getActiveCategories();

        Category activeCategory = null;
        List<Subcategory> subcategories = null;
        if (categoryId != null) {
            activeCategory = categoryService.getCategoryById(categoryId);
            subcategories = categoryService.getSubcategoriesByCategory(categoryId);
        }

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("activeCategory", activeCategory);
        request.setAttribute("subcategories", subcategories);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("selectedSubcategoryId", subcategoryId);
        request.setAttribute("selectedRoom", roomParam);
        request.setAttribute("selectedSort", sortParam);
        request.setAttribute("selectedMinPrice", minPriceParam);
        request.setAttribute("selectedMaxPrice", maxPriceParam);
        request.setAttribute("selectedMaterial", materialParam);
        request.setAttribute("selectedColor", colorParam);

        String title = "Architectural Furniture & Living Catalog — Gruhu";
        if (activeCategory != null) {
            title = activeCategory.getCategoryName() + " Collection — Gruhu";
        } else if (roomParam != null) {
            switch (roomParam) {
                case "living_room":
                    title = "Living Room Collection — Gruhu";
                    break;
                case "bedroom":
                    title = "Bedroom Sanctuary Collection — Gruhu";
                    break;
                case "dining_room":
                    title = "Dining Room Collection — Gruhu";
                    break;
                case "hall":
                    title = "Hall Area Complete Collection — Gruhu";
                    break;
                default:
                    title = "Curated Room Collection — Gruhu";
            }
        }
        request.setAttribute("pageTitle", title);
        request.setAttribute("extraCss", "product.css");

        request.getRequestDispatcher("/WEB-INF/views/customer/products.jsp").forward(request, response);
    }

    private void handleProductDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = ValidationUtil.parseInt(request.getParameter("id"), 0);
        if (productId <= 0) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        Product product = productService.getProductById(productId);
        if (product == null || !"ACTIVE".equalsIgnoreCase(product.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/products?error=not_found");
            return;
        }

        List<Product> relatedProducts = productService.getRelatedProducts(product.getCategoryId(), product.getProductId(), 4);

        request.setAttribute("product", product);
        request.setAttribute("relatedProducts", relatedProducts);
        request.setAttribute("pageTitle", product.getProductName() + " — Gruhu Atelier");
        request.setAttribute("extraCss", "product.css");

        request.getRequestDispatcher("/WEB-INF/views/customer/product-details.jsp").forward(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            keyword = request.getParameter("q");
        }
        List<Product> results;
        if (ValidationUtil.isNotEmpty(keyword)) {
            results = productService.searchProducts(keyword);
        } else {
            results = productService.getAllActiveProducts("featured");
        }

        request.setAttribute("products", results);
        request.setAttribute("keyword", keyword);
        request.setAttribute("pageTitle", "Search Results for \"" + (keyword != null ? keyword : "") + "\" — Gruhu");
        request.setAttribute("extraCss", "product.css");

        request.getRequestDispatcher("/WEB-INF/views/customer/search-results.jsp").forward(request, response);
    }
}
