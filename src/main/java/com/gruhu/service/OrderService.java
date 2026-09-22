package com.gruhu.service;

import com.gruhu.dao.OrderDAO;
import com.gruhu.model.Order;

import java.math.BigDecimal;
import java.util.List;

public class OrderService {

    private final OrderDAO orderDAO = new OrderDAO();

    public Order placeOrder(int customerId, int addressId, String paymentMethod) throws Exception {
        return placeOrder(customerId, addressId, paymentMethod, BigDecimal.ZERO, "Complimentary White-Glove Delivery", null);
    }

    public Order placeOrder(int customerId, int addressId, String paymentMethod, BigDecimal deliveryCharge,
                            String deliveryOption, String orderNotes) throws Exception {
        if (deliveryCharge == null) deliveryCharge = BigDecimal.ZERO;
        return orderDAO.createOrder(customerId, addressId, paymentMethod, deliveryCharge, deliveryOption, orderNotes);
    }

    public Order getOrderDetails(int orderId, int customerId) {
        Order order = orderDAO.getOrderById(orderId);
        if (order != null && order.getCustomerId() == customerId) {
            return order;
        }
        return null;
    }

    public Order getOrderDetailsForAdmin(int orderId) {
        return orderDAO.getOrderById(orderId);
    }

    public List<Order> getCustomerOrders(int customerId) {
        return orderDAO.getOrdersByCustomerId(customerId);
    }

    public List<Order> getAllOrders(String statusFilter) {
        return orderDAO.getAllOrdersForAdmin(statusFilter);
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        return orderDAO.updateOrderStatus(orderId, newStatus);
    }

    public boolean updatePaymentStatus(int orderId, String newStatus) {
        return orderDAO.updatePaymentStatus(orderId, newStatus);
    }

    public int getTotalOrderCount() {
        return orderDAO.getTotalOrderCount();
    }

    public BigDecimal getTotalRevenue() {
        return orderDAO.getTotalRevenue();
    }

    public List<Order> getRecentOrders(int limit) {
        return orderDAO.getRecentOrders(limit);
    }
}
