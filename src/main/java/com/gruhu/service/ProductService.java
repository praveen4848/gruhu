package com.gruhu.service;

import com.gruhu.dao.ProductDAO;
import com.gruhu.dao.ProductImageDAO;
import com.gruhu.model.Product;
import com.gruhu.model.ProductImage;

import java.math.BigDecimal;
import java.util.List;

public class ProductService {

    private final ProductDAO productDAO = new ProductDAO();
    private final ProductImageDAO imageDAO = new ProductImageDAO();

    public List<Product> getAllActiveProducts(String sortBy) {
        return productDAO.getAllActiveProducts(sortBy);
    }

    public List<Product> getFeaturedProducts(int limit) {
        return productDAO.getFeaturedProducts(limit);
    }

    public List<Product> getProductsByCategory(int categoryId, String sortBy) {
        return productDAO.getProductsByCategory(categoryId, sortBy);
    }

    public List<Product> getProductsBySubcategory(int subcategoryId, String sortBy) {
        return productDAO.getProductsBySubcategory(subcategoryId, sortBy);
    }

    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return productDAO.getAllActiveProducts("featured");
        }
        return productDAO.searchProducts(keyword);
    }

    public List<Product> getProductsByRoom(String room, String sortBy) {
        return productDAO.getProductsByRoom(room, sortBy);
    }

    public List<Product> filterProducts(Integer categoryId, Integer subcategoryId,
                                        BigDecimal minPrice, BigDecimal maxPrice,
                                        String material, String color, String sortBy) {
        return productDAO.filterProducts(categoryId, subcategoryId, minPrice, maxPrice, material, color, null, sortBy);
    }

    public List<Product> filterProducts(Integer categoryId, Integer subcategoryId,
                                        BigDecimal minPrice, BigDecimal maxPrice,
                                        String material, String color, String room, String sortBy) {
        return productDAO.filterProducts(categoryId, subcategoryId, minPrice, maxPrice, material, color, room, sortBy);
    }

    public Product getProductById(int productId) {
        return productDAO.getProductById(productId);
    }

    public List<Product> getRelatedProducts(int categoryId, int excludeProductId, int limit) {
        return productDAO.getRelatedProducts(categoryId, excludeProductId, limit);
    }

    public List<Product> getAllProductsForAdmin() {
        return productDAO.getAllProductsForAdmin();
    }

    public List<Product> getLowStockProducts(int threshold) {
        return productDAO.getLowStockProducts(threshold);
    }

    public boolean addProduct(Product product, String primaryImageUrl, List<String> galleryImages) {
        boolean saved = productDAO.addProduct(product);
        if (saved && product.getProductId() > 0) {
            if (primaryImageUrl != null && !primaryImageUrl.trim().isEmpty()) {
                imageDAO.addImage(new ProductImage(0, product.getProductId(), primaryImageUrl.trim(), true, null));
            }
            if (galleryImages != null) {
                for (String url : galleryImages) {
                    if (url != null && !url.trim().isEmpty()) {
                        imageDAO.addImage(new ProductImage(0, product.getProductId(), url.trim(), false, null));
                    }
                }
            }
            return true;
        }
        return false;
    }

    public boolean updateProduct(Product product) {
        return productDAO.updateProduct(product);
    }

    public boolean updateStock(int productId, int quantityChange) {
        return productDAO.updateStock(productId, quantityChange);
    }

    public boolean setStock(int productId, int newQuantity) {
        return productDAO.setStock(productId, newQuantity);
    }

    public boolean deleteProduct(int productId) {
        return productDAO.deleteProduct(productId);
    }

    public boolean addProductImage(int productId, String imagePath, boolean isPrimary) {
        return imageDAO.addImage(new ProductImage(0, productId, imagePath, isPrimary, null));
    }

    public boolean deleteProductImage(int imageId) {
        return imageDAO.deleteImage(imageId);
    }

    public boolean setPrimaryImage(int productId, int imageId) {
        return imageDAO.setPrimaryImage(productId, imageId);
    }

    public int getTotalProductCount() {
        return productDAO.getTotalProductCount();
    }
}
