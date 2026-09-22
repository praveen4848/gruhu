package com.gruhu.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ProductImage implements Serializable {

    private static final long serialVersionUID = 1L;

    private int imageId;
    private int productId;
    private String imagePath;
    private boolean isPrimary;
    private Timestamp createdAt;

    public ProductImage() {
    }

    public ProductImage(int imageId, int productId, String imagePath, boolean isPrimary, Timestamp createdAt) {
        this.imageId = imageId;
        this.productId = productId;
        this.imagePath = imagePath;
        this.isPrimary = isPrimary;
        this.createdAt = createdAt;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getImageUrl() {
        return imagePath;
    }

    public void setImageUrl(String imageUrl) {
        this.imagePath = imageUrl;
    }

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean primary) {
        isPrimary = primary;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "ProductImage{" +
                "imageId=" + imageId +
                ", productId=" + productId +
                ", imagePath='" + imagePath + '\'' +
                ", isPrimary=" + isPrimary +
                '}';
    }
}
