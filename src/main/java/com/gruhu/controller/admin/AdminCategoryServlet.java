package com.gruhu.controller.admin;

import com.gruhu.model.Category;
import com.gruhu.model.Subcategory;
import com.gruhu.service.CategoryService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/categories", "/admin/subcategories"})
public class AdminCategoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/subcategories".equals(path)) {
            List<Subcategory> subcategories = categoryService.getAllSubcategories();
            List<Category> categories = categoryService.getAllCategories();
            request.setAttribute("subcategories", subcategories);
            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Subcategories Taxonomy — Gruhu Atelier");
            request.getRequestDispatcher("/WEB-INF/views/admin/subcategories.jsp").forward(request, response);
            return;
        }

        // Default: /admin/categories
        List<Category> categories = categoryService.getAllCategories();
        List<Subcategory> subcategories = categoryService.getAllSubcategories();
        request.setAttribute("categories", categories);
        request.setAttribute("subcategories", subcategories);
        request.setAttribute("pageTitle", "Product Lines & Categories — Gruhu Atelier");
        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String action = request.getParameter("action");
        if (action == null) action = "add";

        if ("/admin/subcategories".equals(path)) {
            handleSubcategoryAction(request, response, action);
        } else {
            handleCategoryAction(request, response, action);
        }
    }

    private void handleCategoryAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws IOException {

        switch (action) {
            case "add": {
                String name = request.getParameter("categoryName");
                String description = request.getParameter("description");
                String imageUrl = request.getParameter("imageUrl");

                if (ValidationUtil.isNotEmpty(name)) {
                    Category cat = new Category(0, name.trim(), description != null ? description.trim() : "",
                            imageUrl != null ? imageUrl.trim() : "", "ACTIVE", null);
                    categoryService.addCategory(cat);
                }
                break;
            }
            case "edit": {
                int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), 0);
                String name = request.getParameter("categoryName");
                String description = request.getParameter("description");
                String imageUrl = request.getParameter("imageUrl");
                boolean isActive = "true".equalsIgnoreCase(request.getParameter("isActive")) || "on".equalsIgnoreCase(request.getParameter("isActive"));

                if (categoryId > 0 && ValidationUtil.isNotEmpty(name)) {
                    Category cat = new Category(categoryId, name.trim(), description != null ? description.trim() : "",
                            imageUrl != null ? imageUrl.trim() : "", isActive ? "ACTIVE" : "INACTIVE", null);
                    categoryService.updateCategory(cat);
                }
                break;
            }
            case "delete": {
                int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), 0);
                if (categoryId > 0) {
                    categoryService.deleteCategory(categoryId);
                }
                break;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/categories?success=saved");
    }

    private void handleSubcategoryAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws IOException {

        switch (action) {
            case "add": {
                int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), 0);
                String name = request.getParameter("subcategoryName");
                String description = request.getParameter("description");

                if (categoryId > 0 && ValidationUtil.isNotEmpty(name)) {
                    Subcategory sub = new Subcategory(0, categoryId, name.trim(),
                            description != null ? description.trim() : "", "ACTIVE");
                    categoryService.addSubcategory(sub);
                }
                break;
            }
            case "edit": {
                int subcategoryId = ValidationUtil.parseInt(request.getParameter("subcategoryId"), 0);
                int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), 0);
                String name = request.getParameter("subcategoryName");
                String description = request.getParameter("description");
                boolean isActive = "true".equalsIgnoreCase(request.getParameter("isActive")) || "on".equalsIgnoreCase(request.getParameter("isActive"));

                if (subcategoryId > 0 && categoryId > 0 && ValidationUtil.isNotEmpty(name)) {
                    Subcategory sub = new Subcategory(subcategoryId, categoryId, name.trim(),
                            description != null ? description.trim() : "", isActive ? "ACTIVE" : "INACTIVE");
                    categoryService.updateSubcategory(sub);
                }
                break;
            }
            case "delete": {
                int subcategoryId = ValidationUtil.parseInt(request.getParameter("subcategoryId"), 0);
                if (subcategoryId > 0) {
                    categoryService.deleteSubcategory(subcategoryId);
                }
                break;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/subcategories?success=saved");
    }
}
