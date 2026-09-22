package com.gruhu.controller.admin;

import com.gruhu.model.Category;
import com.gruhu.model.Product;
import com.gruhu.model.ProductImage;
import com.gruhu.model.Subcategory;
import com.gruhu.service.CategoryService;
import com.gruhu.service.ProductService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {"/admin/products", "/admin/products/*", "/admin/add-product", "/admin/edit-product"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 15,      // 15MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        String action = request.getParameter("action");
        if ("/admin/add-product".equals(servletPath)) {
            action = "add";
        } else if ("/admin/edit-product".equals(servletPath)) {
            action = "edit";
        }
        if (action == null) action = "list";

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "images":
                showImagesPage(request, response);
                break;
            case "delete":
                handleDeleteProduct(request, response);
                break;
            case "list":
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        String action = request.getParameter("action");
        if ("/admin/add-product".equals(servletPath)) {
            action = "add";
        } else if ("/admin/edit-product".equals(servletPath)) {
            action = "edit";
        }
        if (action == null) action = "list";

        switch (action) {
            case "add":
                handleAddProduct(request, response);
                break;
            case "edit":
                handleEditProduct(request, response);
                break;
            case "addImage":
                handleAddImage(request, response);
                break;
            case "deleteImage":
                handleDeleteImage(request, response);
                break;
            case "setPrimaryImage":
                handleSetPrimaryImage(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/products");
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = productService.getAllProductsForAdmin();
        List<Category> categories = categoryService.getAllCategories();

        String categoryFilter = request.getParameter("category");
        String searchFilter = request.getParameter("search");
        String stockFilter = request.getParameter("stock");

        if (categoryFilter != null && !categoryFilter.isEmpty() && !"all".equalsIgnoreCase(categoryFilter)) {
            int catId = ValidationUtil.parseInt(categoryFilter, 0);
            if (catId > 0) {
                products = products.stream()
                        .filter(p -> p.getCategoryId() == catId)
                        .collect(Collectors.toList());
            }
        }

        if (stockFilter != null && !stockFilter.isEmpty()) {
            if ("low".equalsIgnoreCase(stockFilter)) {
                products = products.stream()
                        .filter(p -> p.getStockQuantity() > 0 && p.getStockQuantity() <= 5)
                        .collect(Collectors.toList());
            } else if ("out".equalsIgnoreCase(stockFilter)) {
                products = products.stream()
                        .filter(p -> p.getStockQuantity() == 0)
                        .collect(Collectors.toList());
            } else if ("in".equalsIgnoreCase(stockFilter)) {
                products = products.stream()
                        .filter(p -> p.getStockQuantity() > 5)
                        .collect(Collectors.toList());
            }
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            String q = searchFilter.toLowerCase().trim();
            products = products.stream()
                    .filter(p -> (p.getProductName() != null && p.getProductName().toLowerCase().contains(q))
                            || (p.getMaterial() != null && p.getMaterial().toLowerCase().contains(q))
                            || (p.getColor() != null && p.getColor().toLowerCase().contains(q)))
                    .collect(Collectors.toList());
        }

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", categoryFilter);
        request.setAttribute("selectedStock", stockFilter);
        request.setAttribute("searchQuery", searchFilter);
        request.setAttribute("pageTitle", "Furniture Catalog — Gruhu Atelier Management");

        request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Category> categories = categoryService.getActiveCategories();
        List<Subcategory> subcategories = categoryService.getAllSubcategories();

        request.setAttribute("categories", categories);
        request.setAttribute("subcategories", subcategories);
        request.setAttribute("pageTitle", "Add Sculptural Object — Gruhu Atelier");

        request.getRequestDispatcher("/WEB-INF/views/admin/add-product.jsp").forward(request, response);
    }

    private String saveUploadedImageFile(HttpServletRequest request, String partName) {
        try {
            Part part = request.getPart(partName);
            if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().trim().isEmpty()) {
                String submitted = part.getSubmittedFileName();
                String ext = ".jpg";
                int dotIdx = submitted.lastIndexOf('.');
                if (dotIdx > 0) {
                    String subExt = submitted.substring(dotIdx).toLowerCase();
                    if (Arrays.asList(".jpg", ".jpeg", ".png", ".webp").contains(subExt)) {
                        ext = subExt;
                    }
                }

                String uploadDir = request.getServletContext().getRealPath("/assets/uploads/products");
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                String fileName = "atelier_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8) + ext;
                File targetFile = new File(dir, fileName);
                part.write(targetFile.getAbsolutePath());

                return request.getContextPath() + "/assets/uploads/products/" + fileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("productName");
        int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), 0);
        int subcategoryId = ValidationUtil.parseInt(request.getParameter("subcategoryId"), 0);
        String description = request.getParameter("description");
        BigDecimal price = ValidationUtil.parseBigDecimal(request.getParameter("price"), BigDecimal.ZERO);
        BigDecimal discount = ValidationUtil.parseBigDecimal(request.getParameter("discountPercent"), BigDecimal.ZERO);
        int stock = ValidationUtil.parseInt(request.getParameter("stockQuantity"), 0);
        String material = request.getParameter("material");
        String color = request.getParameter("color");
        String size = request.getParameter("size");
        String dimensions = request.getParameter("dimensions");
        String style = request.getParameter("style");
        String brand = request.getParameter("brand");
        boolean isFeatured = "true".equalsIgnoreCase(request.getParameter("isFeatured")) || "on".equalsIgnoreCase(request.getParameter("isFeatured"));
        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) status = "ACTIVE";

        String deliveryOption = request.getParameter("deliveryOption");
        if (deliveryOption == null || deliveryOption.trim().isEmpty()) {
            deliveryOption = "Complimentary White-Glove Delivery";
        }

        String primaryImageUrl = request.getParameter("primaryImageUrl");
        String uploadedPrimary = saveUploadedImageFile(request, "primaryImageFile");
        if (uploadedPrimary != null) {
            primaryImageUrl = uploadedPrimary;
        }

        String galleryUrlsRaw = request.getParameter("galleryImageUrls");

        if (!ValidationUtil.isNotEmpty(name) || categoryId == 0 || price.compareTo(BigDecimal.ZERO) <= 0) {
            request.setAttribute("errorMessage", "Product title, category, and a valid base price are strictly required.");
            showAddForm(request, response);
            return;
        }

        Product product = new Product();
        product.setProductName(name.trim());
        product.setCategoryId(categoryId);
        product.setSubcategoryId(subcategoryId > 0 ? subcategoryId : null);
        product.setDescription(description != null ? description.trim() : "");
        product.setPrice(price);
        product.setDiscountPercent(discount);
        product.setStockQuantity(stock);
        product.setMaterial(material != null ? material.trim() : "");
        product.setColor(color != null ? color.trim() : "");
        product.setSize(size != null ? size.trim() : "");
        product.setDimensions(dimensions != null ? dimensions.trim() : "");
        product.setStyle(style != null ? style.trim() : "Scandinavian Modern");
        product.setBrand(brand != null ? brand.trim() : "Gruhu Atelier");
        product.setRating(BigDecimal.valueOf(5.0));
        product.setFeatured(isFeatured);
        product.setStatus(status);
        product.setDeliveryOption(deliveryOption.trim());

        List<String> galleryList = new ArrayList<>();
        if (galleryUrlsRaw != null && !galleryUrlsRaw.trim().isEmpty()) {
            String[] urls = galleryUrlsRaw.split("[\\r\\n,]+");
            for (String u : urls) {
                if (u != null && !u.trim().isEmpty()) {
                    galleryList.add(u.trim());
                }
            }
        }

        boolean created = productService.addProduct(product, primaryImageUrl, galleryList);
        if (created) {
            response.sendRedirect(request.getContextPath() + "/admin/products?success=added");
        } else {
            request.setAttribute("errorMessage", "Error saving product to the collection database.");
            showAddForm(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = ValidationUtil.parseInt(request.getParameter("id"), 0);
        Product product = productService.getProductById(productId);

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        List<Category> categories = categoryService.getActiveCategories();
        List<Subcategory> subcategories = categoryService.getAllSubcategories();

        request.setAttribute("product", product);
        request.setAttribute("categories", categories);
        request.setAttribute("subcategories", subcategories);
        request.setAttribute("pageTitle", "Refine " + product.getProductName() + " — Gruhu Atelier");

        request.getRequestDispatcher("/WEB-INF/views/admin/edit-product.jsp").forward(request, response);
    }

    private void handleEditProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = ValidationUtil.parseInt(request.getParameter("productId"), 0);
        Product product = productService.getProductById(productId);

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        String name = request.getParameter("productName");
        int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), 0);
        int subcategoryId = ValidationUtil.parseInt(request.getParameter("subcategoryId"), 0);
        String description = request.getParameter("description");
        BigDecimal price = ValidationUtil.parseBigDecimal(request.getParameter("price"), BigDecimal.ZERO);
        BigDecimal discount = ValidationUtil.parseBigDecimal(request.getParameter("discountPercent"), BigDecimal.ZERO);
        int stock = ValidationUtil.parseInt(request.getParameter("stockQuantity"), 0);
        String material = request.getParameter("material");
        String color = request.getParameter("color");
        String size = request.getParameter("size");
        String dimensions = request.getParameter("dimensions");
        String style = request.getParameter("style");
        String brand = request.getParameter("brand");
        boolean isFeatured = "true".equalsIgnoreCase(request.getParameter("isFeatured")) || "on".equalsIgnoreCase(request.getParameter("isFeatured"));
        String status = request.getParameter("status");

        String deliveryOption = request.getParameter("deliveryOption");
        if (deliveryOption != null && !deliveryOption.trim().isEmpty()) {
            product.setDeliveryOption(deliveryOption.trim());
        }

        if (!ValidationUtil.isNotEmpty(name) || categoryId == 0 || price.compareTo(BigDecimal.ZERO) <= 0) {
            request.setAttribute("errorMessage", "Product title, category, and valid price are required.");
            showEditForm(request, response);
            return;
        }

        product.setProductName(name.trim());
        product.setCategoryId(categoryId);
        product.setSubcategoryId(subcategoryId > 0 ? subcategoryId : null);
        product.setDescription(description != null ? description.trim() : "");
        product.setPrice(price);
        product.setDiscountPercent(discount);
        product.setStockQuantity(stock);
        product.setMaterial(material != null ? material.trim() : "");
        product.setColor(color != null ? color.trim() : "");
        product.setSize(size != null ? size.trim() : "");
        product.setDimensions(dimensions != null ? dimensions.trim() : "");
        product.setStyle(style != null ? style.trim() : "");
        product.setBrand(brand != null ? brand.trim() : "");
        product.setFeatured(isFeatured);
        product.setStatus(status != null ? status : "ACTIVE");

        boolean updated = productService.updateProduct(product);
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/products?success=updated");
        } else {
            request.setAttribute("errorMessage", "Failed to update product details.");
            showEditForm(request, response);
        }
    }

    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = ValidationUtil.parseInt(request.getParameter("id"), 0);
        if (productId > 0) {
            productService.deleteProduct(productId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/products?success=deleted");
    }

    private void showImagesPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = ValidationUtil.parseInt(request.getParameter("id"), 0);
        Product product = productService.getProductById(productId);

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        request.setAttribute("product", product);
        request.setAttribute("pageTitle", "Visual Portfolio: " + product.getProductName() + " — Gruhu");
        request.getRequestDispatcher("/WEB-INF/views/admin/product-images.jsp").forward(request, response);
    }

    private void handleAddImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = ValidationUtil.parseInt(request.getParameter("productId"), 0);
        String imageUrl = request.getParameter("imageUrl");

        String uploadedUrl = saveUploadedImageFile(request, "imageFile");
        if (uploadedUrl != null) {
            imageUrl = uploadedUrl;
        }

        boolean isPrimary = "true".equalsIgnoreCase(request.getParameter("isPrimary")) || "on".equalsIgnoreCase(request.getParameter("isPrimary"));

        if (productId > 0 && ValidationUtil.isNotEmpty(imageUrl)) {
            productService.addProductImage(productId, imageUrl.trim(), isPrimary);
        }
        response.sendRedirect(request.getContextPath() + "/admin/products?action=images&id=" + productId + "&success=imageAdded");
    }

    private void handleDeleteImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int imageId = ValidationUtil.parseInt(request.getParameter("imageId"), 0);
        int productId = ValidationUtil.parseInt(request.getParameter("productId"), 0);

        if (imageId > 0) {
            productService.deleteProductImage(imageId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/products?action=images&id=" + productId + "&success=imageDeleted");
    }

    private void handleSetPrimaryImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int imageId = ValidationUtil.parseInt(request.getParameter("imageId"), 0);
        int productId = ValidationUtil.parseInt(request.getParameter("productId"), 0);

        if (imageId > 0 && productId > 0) {
            productService.setPrimaryImage(productId, imageId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/products?action=images&id=" + productId + "&success=primarySet");
    }
}
