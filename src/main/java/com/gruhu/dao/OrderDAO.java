package com.gruhu.dao;

import com.gruhu.model.*;
import com.gruhu.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private final AddressDAO addressDAO = new AddressDAO();

    public Order createOrder(int customerId, int addressId, String paymentMethod, BigDecimal deliveryCharge) throws Exception {
        return createOrder(customerId, addressId, paymentMethod, deliveryCharge, "Complimentary White-Glove Delivery", null);
    }

    public Order createOrder(int customerId, int addressId, String paymentMethod, BigDecimal deliveryCharge,
                             String deliveryOption, String orderNotes) throws Exception {

        String orderNumber = "GRUHU-" + System.currentTimeMillis();
        String insertOrderSql = "INSERT INTO orders (customer_id, order_number, total_amount, discount_amount, shipping_fee, " +
                                "final_amount, status, payment_status, payment_method, shipping_address_id, delivery_option, " +
                                "tracking_number, order_notes, created_at, updated_at) " +
                                "VALUES (?, ?, ?, ?, ?, ?, 'PROCESSING', ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        String insertItemSql = "INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price, total_price, created_at) " +
                               "VALUES (?, ?, ?, ?, ?, ?, NOW())";

        String deductStockSql = "UPDATE products SET stock_quantity = stock_quantity - ?, updated_at = NOW() " +
                                "WHERE product_id = ? AND stock_quantity >= ?";

        String clearCartSql = "DELETE ci FROM cart_items ci JOIN cart c ON ci.cart_id = c.cart_id WHERE c.customer_id = ?";

        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getOrCreateCartByCustomerId(customerId);

        if (cart == null || cart.isEmpty()) {
            throw new IllegalStateException("Cart is empty. Cannot place order.");
        }

        if (deliveryCharge == null) {
            deliveryCharge = BigDecimal.ZERO;
        }

        BigDecimal totalAmount = cart.getTotalAmount();
        BigDecimal finalAmount = totalAmount.add(deliveryCharge);
        String initialPaymentStatus = "COD".equalsIgnoreCase(paymentMethod) ? "PENDING" : "PAID";
        String trackingNumber = "TRK-" + (100000 + new java.util.Random().nextInt(900000));
        String selectedDeliveryOption = (deliveryOption != null && !deliveryOption.trim().isEmpty())
                ? deliveryOption.trim()
                : "Complimentary White-Glove Delivery";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Verify stock for all items
                for (CartItem item : cart.getItems()) {
                    Product p = item.getProduct();
                    if (p == null || p.getStockQuantity() < item.getQuantity()) {
                        throw new IllegalStateException("Insufficient stock for product: " + (p != null ? p.getProductName() : "item #" + item.getProductId()));
                    }
                }

                // 2. Insert Order
                int orderId = 0;
                try (PreparedStatement ps = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, customerId);
                    ps.setString(2, orderNumber);
                    ps.setBigDecimal(3, totalAmount);
                    ps.setBigDecimal(4, BigDecimal.ZERO);
                    ps.setBigDecimal(5, deliveryCharge);
                    ps.setBigDecimal(6, finalAmount);
                    ps.setString(7, initialPaymentStatus);
                    ps.setString(8, paymentMethod != null ? paymentMethod : "Credit Card / UPI");
                    ps.setInt(9, addressId);
                    ps.setString(10, selectedDeliveryOption);
                    ps.setString(11, trackingNumber);
                    ps.setString(12, orderNotes != null ? orderNotes : "Atelier curated packaging");

                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            orderId = rs.getInt(1);
                        }
                    }
                }

                if (orderId == 0) {
                    throw new SQLException("Failed to generate order ID.");
                }

                // 3. Insert Order Items & Deduct Stock
                try (PreparedStatement itemPs = conn.prepareStatement(insertItemSql);
                     PreparedStatement stockPs = conn.prepareStatement(deductStockSql)) {

                    for (CartItem item : cart.getItems()) {
                        Product p = item.getProduct();
                        BigDecimal unitPrice = p.getDiscountedPrice();
                        BigDecimal subtotal = item.getSubtotal();
                        String prodName = p.getProductName() != null ? p.getProductName() : "Curated Atelier Piece";

                        itemPs.setInt(1, orderId);
                        itemPs.setInt(2, item.getProductId());
                        itemPs.setString(3, prodName);
                        itemPs.setInt(4, item.getQuantity());
                        itemPs.setBigDecimal(5, unitPrice);
                        itemPs.setBigDecimal(6, subtotal);
                        itemPs.addBatch();

                        stockPs.setInt(1, item.getQuantity());
                        stockPs.setInt(2, item.getProductId());
                        stockPs.setInt(3, item.getQuantity());
                        stockPs.addBatch();
                    }

                    itemPs.executeBatch();
                    int[] stockResults = stockPs.executeBatch();
                    for (int res : stockResults) {
                        if (res <= 0 && res != Statement.SUCCESS_NO_INFO) {
                            throw new IllegalStateException("Stock deduction failed due to concurrent orders.");
                        }
                    }
                }

                // 4. Clear Cart
                try (PreparedStatement ps = conn.prepareStatement(clearCartSql)) {
                    ps.setInt(1, customerId);
                    ps.executeUpdate();
                }

                conn.commit();
                return getOrderById(orderId);

            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        }
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, c.full_name, c.email, c.phone AS customer_phone " +
                     "FROM orders o " +
                     "JOIN customers c ON o.customer_id = c.customer_id " +
                     "WHERE o.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setAddress(addressDAO.getAddressById(order.getAddressId()));
                    order.setItems(getOrderItems(conn, orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrdersByCustomerId(int customerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE customer_id = ? ORDER BY order_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setAddress(addressDAO.getAddressById(order.getAddressId()));
                    order.setItems(getOrderItems(conn, order.getOrderId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrdersForAdmin(String statusFilter) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.*, c.full_name, c.email, c.phone AS customer_phone " +
                "FROM orders o " +
                "JOIN customers c ON o.customer_id = c.customer_id ");

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("WHERE (o.status = ? OR o.order_status = ?) ");
        }
        sql.append("ORDER BY o.order_id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
                ps.setString(1, statusFilter.trim());
                ps.setString(2, statusFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(getOrderItems(conn, order.getOrderId()));
                    order.setAddress(addressDAO.getAddressById(order.getAddressId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getRecentOrders(int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, c.full_name, c.email, c.phone AS customer_phone " +
                     "FROM orders o " +
                     "JOIN customers c ON o.customer_id = c.customer_id " +
                     "ORDER BY o.order_id DESC LIMIT " + limit;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setItems(getOrderItems(conn, order.getOrderId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String orderStatus) {
        String sql = "UPDATE orders SET status = ?, updated_at = NOW() WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, orderStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE orders SET payment_status = ?, updated_at = NOW() WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalOrderCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(final_amount), 0) FROM orders WHERE status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    private List<OrderItem> getOrderItems(Connection conn, int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.product_name AS db_prod_name, " +
                     "(SELECT image_path FROM product_images pi WHERE pi.product_id = oi.product_id ORDER BY pi.is_primary DESC, pi.image_id ASC LIMIT 1) AS primary_img " +
                     "FROM order_items oi LEFT JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String pName = null;
                    try {
                        pName = rs.getString("product_name");
                    } catch (SQLException ignored) {}
                    if (pName == null || pName.trim().isEmpty()) {
                        pName = rs.getString("db_prod_name");
                    }
                    if (pName == null || pName.trim().isEmpty()) {
                        pName = "Atelier Sculptural Object";
                    }

                    BigDecimal unitPrice = BigDecimal.ZERO;
                    try {
                        unitPrice = rs.getBigDecimal("unit_price");
                    } catch (SQLException e) {
                        try { unitPrice = rs.getBigDecimal("price"); } catch (SQLException ignored) {}
                    }

                    BigDecimal totalPrice = BigDecimal.ZERO;
                    try {
                        totalPrice = rs.getBigDecimal("total_price");
                    } catch (SQLException e) {
                        try { totalPrice = rs.getBigDecimal("subtotal"); } catch (SQLException ignored) {}
                    }

                    OrderItem item = new OrderItem(
                            rs.getInt("order_item_id"),
                            rs.getInt("order_id"),
                            rs.getInt("product_id"),
                            pName,
                            unitPrice,
                            rs.getInt("quantity"),
                            totalPrice
                    );
                    item.setProductImage(rs.getString("primary_img"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setCustomerId(rs.getInt("customer_id"));

        try { o.setOrderNumber(rs.getString("order_number")); } catch (SQLException ignored) {}
        try {
            o.setAddressId(rs.getInt("shipping_address_id"));
        } catch (SQLException e) {
            try { o.setAddressId(rs.getInt("address_id")); } catch (SQLException ignored) {}
        }
        try {
            o.setOrderDate(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            try { o.setOrderDate(rs.getTimestamp("order_date")); } catch (SQLException ignored) {}
        }
        try { o.setTotalAmount(rs.getBigDecimal("total_amount")); } catch (SQLException ignored) {}
        try { o.setDiscountAmount(rs.getBigDecimal("discount_amount")); } catch (SQLException ignored) {}
        try {
            o.setShippingFee(rs.getBigDecimal("shipping_fee"));
        } catch (SQLException e) {
            try { o.setShippingFee(rs.getBigDecimal("delivery_charge")); } catch (SQLException ignored) {}
        }
        try { o.setFinalAmount(rs.getBigDecimal("final_amount")); } catch (SQLException ignored) {}
        try { o.setPaymentMethod(rs.getString("payment_method")); } catch (SQLException ignored) {}
        try { o.setPaymentStatus(rs.getString("payment_status")); } catch (SQLException ignored) {}
        try {
            String st = rs.getString("status");
            if (st == null) st = rs.getString("order_status");
            o.setOrderStatus(st);
        } catch (SQLException ignored) {}
        try { o.setDeliveryOption(rs.getString("delivery_option")); } catch (SQLException ignored) {}
        try { o.setTrackingNumber(rs.getString("tracking_number")); } catch (SQLException ignored) {}
        try { o.setOrderNotes(rs.getString("order_notes")); } catch (SQLException ignored) {}
        try { o.setUpdatedAt(rs.getTimestamp("updated_at")); } catch (SQLException ignored) {}

        try {
            Customer c = new Customer();
            c.setCustomerId(rs.getInt("customer_id"));
            c.setFullName(rs.getString("full_name"));
            c.setEmail(rs.getString("email"));
            c.setPhone(rs.getString("customer_phone"));
            o.setCustomer(c);
        } catch (SQLException ignored) {
        }

        return o;
    }
}
