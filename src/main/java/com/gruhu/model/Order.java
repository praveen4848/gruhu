package com.gruhu.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order implements Serializable {

    private static final long serialVersionUID = 1L;

    private int orderId;
    private int customerId;
    private String orderNumber;
    private int addressId;
    private Timestamp orderDate;
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private BigDecimal discountAmount = BigDecimal.ZERO;
    private BigDecimal deliveryCharge = BigDecimal.ZERO;
    private BigDecimal shippingFee = BigDecimal.ZERO;
    private BigDecimal finalAmount = BigDecimal.ZERO;
    private String paymentMethod;
    private String paymentStatus = "PENDING";
    private String orderStatus = "PLACED";
    private String deliveryOption = "Complimentary White-Glove Delivery";
    private String trackingNumber;
    private String orderNotes;
    private Timestamp updatedAt;

    // Helper associations
    private List<OrderItem> items = new ArrayList<>();
    private Address address;
    private Customer customer;

    public Order() {
    }

    public Order(int orderId, int customerId, int addressId, Timestamp orderDate,
                 BigDecimal totalAmount, BigDecimal deliveryCharge, String paymentMethod,
                 String paymentStatus, String orderStatus, Timestamp updatedAt) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.addressId = addressId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.deliveryCharge = deliveryCharge;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.orderStatus = orderStatus;
        this.updatedAt = updatedAt;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount != null ? totalAmount : BigDecimal.ZERO;
    }

    public BigDecimal getDeliveryCharge() {
        return deliveryCharge;
    }

    public void setDeliveryCharge(BigDecimal deliveryCharge) {
        this.deliveryCharge = deliveryCharge != null ? deliveryCharge : BigDecimal.ZERO;
    }

    public BigDecimal getGrandTotal() {
        return (totalAmount != null ? totalAmount : BigDecimal.ZERO)
                .add(deliveryCharge != null ? deliveryCharge : BigDecimal.ZERO);
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items != null ? items : new ArrayList<>();
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public int getTotalQuantity() {
        int count = 0;
        for (OrderItem item : items) {
            count += item.getQuantity();
        }
        return count;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getShippingFee() {
        if (shippingFee != null && shippingFee.compareTo(BigDecimal.ZERO) > 0) return shippingFee;
        return deliveryCharge != null ? deliveryCharge : BigDecimal.ZERO;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
        this.deliveryCharge = shippingFee;
    }

    public BigDecimal getFinalAmount() {
        if (finalAmount != null && finalAmount.compareTo(BigDecimal.ZERO) > 0) return finalAmount;
        return getGrandTotal();
    }

    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getDeliveryOption() {
        return (deliveryOption != null && !deliveryOption.trim().isEmpty()) ? deliveryOption : "Complimentary White-Glove Delivery";
    }

    public void setDeliveryOption(String deliveryOption) {
        this.deliveryOption = deliveryOption;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public String getOrderNotes() {
        return orderNotes;
    }

    public void setOrderNotes(String orderNotes) {
        this.orderNotes = orderNotes;
    }

    public String getStatus() {
        return orderStatus;
    }

    public void setStatus(String status) {
        this.orderStatus = status;
    }

    public int getShippingAddressId() {
        return addressId;
    }

    public void setShippingAddressId(int shippingAddressId) {
        this.addressId = shippingAddressId;
    }

    public Timestamp getCreatedAt() {
        return orderDate;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.orderDate = createdAt;
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", customerId=" + customerId +
                ", totalAmount=" + totalAmount +
                ", orderStatus='" + orderStatus + '\'' +
                '}';
    }
}
