package com.gruhu.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Wishlist implements Serializable {

    private static final long serialVersionUID = 1L;

    private int wishlistId;
    private int customerId;
    private int productId;
    private Timestamp addedAt;

    // Associated product
    private Product product;

    public Wishlist() {
    }

    public Wishlist(int wishlistId, int customerId, int productId, Timestamp addedAt) {
        this.wishlistId = wishlistId;
        this.customerId = customerId;
        this.productId = productId;
        this.addedAt = addedAt;
    }

    public int getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(int wishlistId) {
        this.wishlistId = wishlistId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Timestamp getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Timestamp addedAt) {
        this.addedAt = addedAt;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    @Override
    public String toString() {
        return "Wishlist{" +
                "wishlistId=" + wishlistId +
                ", customerId=" + customerId +
                ", productId=" + productId +
                '}';
    }
}
