package com.gruhu.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Product implements Serializable {

    private static final long serialVersionUID = 1L;

    private int productId;
    private int categoryId;
    private Integer subcategoryId;
    private String productName;
    private String description;
    private BigDecimal price = BigDecimal.ZERO;
    private BigDecimal discountPercent = BigDecimal.ZERO;
    private int stockQuantity;
    private String material;
    private String color;
    private String size;
    private String dimensions;
    private String style;
    private String brand;
    private BigDecimal rating = BigDecimal.valueOf(5.0);
    private boolean isFeatured;
    private String status = "ACTIVE";
    private String rooms = "living_room,hall";
    private String deliveryOption = "Complimentary White-Glove Delivery";
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Helper UI fields
    private String categoryName;
    private String subcategoryName;
    private String primaryImageUrl;
    private List<ProductImage> images = new ArrayList<>();

    public Product() {
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public Integer getSubcategoryId() {
        return subcategoryId;
    }

    public void setSubcategoryId(Integer subcategoryId) {
        this.subcategoryId = subcategoryId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price != null ? price : BigDecimal.ZERO;
    }

    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent != null ? discountPercent : BigDecimal.ZERO;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getDimensions() {
        return dimensions;
    }

    public void setDimensions(String dimensions) {
        this.dimensions = dimensions;
    }

    public String getStyle() {
        return style;
    }

    public void setStyle(String style) {
        this.style = style;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public BigDecimal getRating() {
        return rating;
    }

    public void setRating(BigDecimal rating) {
        this.rating = rating != null ? rating : BigDecimal.valueOf(5.0);
    }

    public boolean isFeatured() {
        return isFeatured;
    }

    public void setFeatured(boolean featured) {
        isFeatured = featured;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRooms() {
        return rooms;
    }

    public void setRooms(String rooms) {
        this.rooms = rooms;
    }

    public boolean matchesRoom(String room) {
        if (room == null || room.trim().isEmpty() || "all".equalsIgnoreCase(room) || "hall".equalsIgnoreCase(room)) {
            return true;
        }
        if (rooms == null) return false;
        String[] parts = rooms.toLowerCase().split(",");
        String target = room.toLowerCase().trim();
        for (String p : parts) {
            if (p.trim().equals(target)) return true;
        }
        return false;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getSubcategoryName() {
        return subcategoryName;
    }

    public void setSubcategoryName(String subcategoryName) {
        this.subcategoryName = subcategoryName;
    }

    public String getPrimaryImage() {
        if (primaryImageUrl != null && !primaryImageUrl.trim().isEmpty()) {
            return primaryImageUrl;
        }
        if (images != null && !images.isEmpty()) {
            for (ProductImage img : images) {
                if (img.isPrimary() && img.getImagePath() != null && !img.getImagePath().trim().isEmpty()) {
                    return img.getImagePath();
                }
            }
            if (images.get(0).getImagePath() != null && !images.get(0).getImagePath().trim().isEmpty()) {
                return images.get(0).getImagePath();
            }
        }
        return "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&q=85";
    }

    public void setPrimaryImage(String primaryImage) {
        this.primaryImageUrl = primaryImage;
    }

    public String getImageUrl() {
        return getPrimaryImage();
    }

    public void setImageUrl(String imageUrl) {
        this.primaryImageUrl = imageUrl;
    }

    public String getPrimaryImageUrl() {
        return getPrimaryImage();
    }

    public void setPrimaryImageUrl(String primaryImageUrl) {
        this.primaryImageUrl = primaryImageUrl;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }

    public BigDecimal getDiscountedPrice() {
        if (price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        if (discountPercent == null || discountPercent.compareTo(BigDecimal.ZERO) <= 0) {
            return price;
        }
        BigDecimal discountFactor = BigDecimal.valueOf(100).subtract(discountPercent);
        return price.multiply(discountFactor)
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
    }

    public boolean hasDiscount() {
        return discountPercent != null && discountPercent.compareTo(BigDecimal.ZERO) > 0;
    }

    public boolean isInStock() {
        return stockQuantity > 0;
    }

    public String getDeliveryOption() {
        return (deliveryOption != null && !deliveryOption.trim().isEmpty()) ? deliveryOption : "Complimentary White-Glove Delivery";
    }

    public void setDeliveryOption(String deliveryOption) {
        this.deliveryOption = deliveryOption;
    }

    @Override
    public String toString() {
        return "Product{" +
                "productId=" + productId +
                ", productName='" + productName + '\'' +
                ", price=" + price +
                ", stockQuantity=" + stockQuantity +
                '}';
    }
}
