package com.gruhu.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class CartItem implements Serializable {

    private static final long serialVersionUID = 1L;

    private int cartItemId;
    private int cartId;
    private int productId;
    private int quantity;
    private Timestamp addedAt;

    // Associated product details
    private Product product;

    public CartItem() {
    }

    public CartItem(int cartItemId, int cartId, int productId, int quantity, Timestamp addedAt) {
        this.cartItemId = cartItemId;
        this.cartId = cartId;
        this.productId = productId;
        this.quantity = quantity;
        this.addedAt = addedAt;
    }

    public int getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    public BigDecimal getSubtotal() {
        if (product != null) {
            return product.getDiscountedPrice().multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "cartItemId=" + cartItemId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                '}';
    }
}
