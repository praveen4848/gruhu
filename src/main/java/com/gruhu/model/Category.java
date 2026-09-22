package com.gruhu.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Category implements Serializable {

    private static final long serialVersionUID = 1L;

    private int categoryId;
    private String categoryName;
    private String description;
    private String categoryImage;
    private String status;
    private Timestamp createdAt;
    private int productCount;

    public Category() {
    }

    public Category(int categoryId, String categoryName, String description,
                    String categoryImage, String status, Timestamp createdAt) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.categoryImage = categoryImage;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategoryImage() {
        return categoryImage;
    }

    public void setCategoryImage(String categoryImage) {
        this.categoryImage = categoryImage;
    }

    public String getImageUrl() {
        if (categoryImage != null && !categoryImage.trim().isEmpty()) {
            return categoryImage;
        }
        return "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&q=80";
    }

    public void setImageUrl(String imageUrl) {
        this.categoryImage = imageUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getProductCount() {
        return productCount;
    }

    public void setProductCount(int productCount) {
        this.productCount = productCount;
    }

    @Override
    public String toString() {
        return "Category{" +
                "categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
