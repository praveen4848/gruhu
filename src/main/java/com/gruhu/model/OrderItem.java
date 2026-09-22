package com.gruhu.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class OrderItem implements Serializable {

    private static final long serialVersionUID = 1L;

    private int orderItemId;
    private int orderId;
    private int productId;
    private String productName;
    private BigDecimal price = BigDecimal.ZERO;
    private int quantity;
    private BigDecimal subtotal = BigDecimal.ZERO;

    // Helper product image
    private String productImage;

    public OrderItem() {
    }

    public OrderItem(int orderItemId, int orderId, int productId, String productName,
                     BigDecimal price, int quantity, BigDecimal subtotal) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.subtotal = subtotal;
    }

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    private Product product;

    public Product getProduct() {
        if (product == null) {
            product = new Product();
            product.setProductId(this.productId);
            product.setProductName(this.productName);
            product.setPrice(this.price);
            product.setPrimaryImageUrl(this.productImage);
        }
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
        if (product != null) {
            if (this.productId == 0) this.productId = product.getProductId();
            if (this.productName == null) this.productName = product.getProductName();
            if (this.price == null || this.price.compareTo(BigDecimal.ZERO) == 0) this.price = product.getPrice();
            if (this.productImage == null) this.productImage = product.getPrimaryImage();
        }
    }

    public BigDecimal getUnitPrice() {
        return price != null ? price : BigDecimal.ZERO;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.price = unitPrice;
    }

    @Override
    public String toString() {
        return "OrderItem{" +
                "orderItemId=" + orderItemId +
                ", productName='" + productName + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", subtotal=" + subtotal +
                '}';
    }
}
