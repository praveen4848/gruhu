package com.gruhu.dao;

import com.gruhu.model.Product;
import com.gruhu.model.Wishlist;
import com.gruhu.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public boolean addToWishlist(int customerId, int productId) {
        String checkSql = "SELECT COUNT(*) FROM wishlist WHERE customer_id = ? AND product_id = ?";
        String insertSql = "INSERT INTO wishlist (customer_id, product_id, created_at) VALUES (?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, customerId);
                ps.setInt(2, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return true; // Already in wishlist
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, customerId);
                ps.setInt(2, productId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeFromWishlist(int customerId, int productId) {
        String sql = "DELETE FROM wishlist WHERE customer_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isInWishlist(int customerId, int productId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE customer_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Wishlist> getWishlistByCustomerId(int customerId) {
        List<Wishlist> list = new ArrayList<>();
        String sql = "SELECT w.*, p.product_name, p.price, p.discount_percent, p.stock_quantity, p.status, " +
                     "(SELECT image_path FROM product_images pi WHERE pi.product_id = p.product_id ORDER BY pi.is_primary DESC, pi.image_id ASC LIMIT 1) AS primary_img " +
                     "FROM wishlist w " +
                     "JOIN products p ON w.product_id = p.product_id " +
                     "WHERE w.customer_id = ? " +
                     "ORDER BY w.wishlist_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Wishlist w = new Wishlist(
                            rs.getInt("wishlist_id"),
                            rs.getInt("customer_id"),
                            rs.getInt("product_id"),
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

                    w.setProduct(p);
                    list.add(w);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getWishlistCount(int customerId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE customer_id = ?";
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
}
