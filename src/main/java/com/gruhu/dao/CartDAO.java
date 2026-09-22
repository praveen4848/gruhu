package com.gruhu.dao;

import com.gruhu.model.Cart;
import com.gruhu.model.CartItem;
import com.gruhu.model.Product;
import com.gruhu.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public Cart getOrCreateCartByCustomerId(int customerId) {
        String findSql = "SELECT * FROM cart WHERE customer_id = ?";
        String insertSql = "INSERT INTO cart (customer_id, created_at, updated_at) VALUES (?, NOW(), NOW())";

        try (Connection conn = DBConnection.getConnection()) {
            Cart cart = null;
            try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                ps.setInt(1, customerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cart = new Cart(
                                rs.getInt("cart_id"),
                                rs.getInt("customer_id"),
                                rs.getTimestamp("created_at"),
                                rs.getTimestamp("updated_at")
                        );
                    }
                }
            }

            if (cart == null) {
                try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, customerId);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            cart = new Cart(rs.getInt(1), customerId, new Timestamp(System.currentTimeMillis()), new Timestamp(System.currentTimeMillis()));
                        }
                    }
                }
            }

            if (cart != null) {
                cart.setItems(getCartItems(conn, cart.getCartId()));
            }
            return cart;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addItemToCart(int customerId, int productId, int quantity) {
        Cart cart = getOrCreateCartByCustomerId(customerId);
        if (cart == null) return false;

        String checkSql = "SELECT cart_item_id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ?";
        String updateSql = "UPDATE cart_items SET quantity = quantity + ? WHERE cart_item_id = ?";
        String insertSql = "INSERT INTO cart_items (cart_id, product_id, quantity, created_at) VALUES (?, ?, ?, NOW())";
        String touchCart = "UPDATE cart SET updated_at = NOW() WHERE cart_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                boolean itemExists = false;
                int existingItemId = 0;

                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setInt(1, cart.getCartId());
                    ps.setInt(2, productId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            itemExists = true;
                            existingItemId = rs.getInt("cart_item_id");
                        }
                    }
                }

                if (itemExists) {
                    try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                        ps.setInt(1, quantity);
                        ps.setInt(2, existingItemId);
                        ps.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                        ps.setInt(1, cart.getCartId());
                        ps.setInt(2, productId);
                        ps.setInt(3, quantity);
                        ps.executeUpdate();
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(touchCart)) {
                    ps.setInt(1, cart.getCartId());
                    ps.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateItemQuantity(int customerId, int cartItemId, int newQuantity) {
        if (newQuantity <= 0) {
            return removeItemFromCart(customerId, cartItemId);
        }

        String sql = "UPDATE cart_items ci " +
                     "JOIN cart c ON ci.cart_id = c.cart_id " +
                     "SET ci.quantity = ? " +
                     "WHERE ci.cart_item_id = ? AND c.customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newQuantity);
            ps.setInt(2, cartItemId);
            ps.setInt(3, customerId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeItemFromCart(int customerId, int cartItemId) {
        String sql = "DELETE ci FROM cart_items ci " +
                     "JOIN cart c ON ci.cart_id = c.cart_id " +
                     "WHERE ci.cart_item_id = ? AND c.customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartItemId);
            ps.setInt(2, customerId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean clearCart(int customerId) {
        String sql = "DELETE ci FROM cart_items ci " +
                     "JOIN cart c ON ci.cart_id = c.cart_id " +
                     "WHERE c.customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getCartItemCount(int customerId) {
        String sql = "SELECT COALESCE(SUM(ci.quantity), 0) FROM cart_items ci " +
                     "JOIN cart c ON ci.cart_id = c.cart_id " +
                     "WHERE c.customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private List<CartItem> getCartItems(Connection conn, int cartId) throws SQLException {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.*, p.product_name, p.price, p.discount_percent, p.stock_quantity, p.status, " +
                     "(SELECT image_path FROM product_images pi WHERE pi.product_id = p.product_id ORDER BY pi.is_primary DESC, pi.image_id ASC LIMIT 1) AS primary_img " +
                     "FROM cart_items ci " +
                     "JOIN products p ON ci.product_id = p.product_id " +
                     "WHERE ci.cart_id = ? " +
                     "ORDER BY ci.cart_item_id DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem(
                            rs.getInt("cart_item_id"),
                            rs.getInt("cart_id"),
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getTimestamp("created_at")
                    );

                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                    p.setStockQuantity(rs.getInt("stock_quantity"));
                    p.setStatus(rs.getString("status"));
                    p.setPrimaryImageUrl(rs.getString("primary_img"));

                    item.setProduct(p);
                    items.add(item);
                }
            }
        }
        return items;
    }
}
