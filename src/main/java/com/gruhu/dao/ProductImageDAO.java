package com.gruhu.dao;

import com.gruhu.model.ProductImage;
import com.gruhu.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductImageDAO {

    public List<ProductImage> getImagesByProductId(int productId) {
        List<ProductImage> list = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id = ? ORDER BY is_primary DESC, image_id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProductImage(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getPrimaryImagePath(int productId) {
        String sql = "SELECT image_path FROM product_images WHERE product_id = ? ORDER BY is_primary DESC, image_id ASC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("image_path");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addImage(ProductImage image) {
        String sql = "INSERT INTO product_images (product_id, image_path, is_primary, created_at) " +
                     "VALUES (?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, image.getProductId());
            ps.setString(2, image.getImagePath());
            ps.setBoolean(3, image.isPrimary());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        image.setImageId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteImage(int imageId) {
        String sql = "DELETE FROM product_images WHERE image_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, imageId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean setPrimaryImage(int productId, int imageId) {
        String resetSql = "UPDATE product_images SET is_primary = FALSE WHERE product_id = ?";
        String setSql = "UPDATE product_images SET is_primary = TRUE WHERE product_id = ? AND image_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(resetSql);
                 PreparedStatement ps2 = conn.prepareStatement(setSql)) {

                ps1.setInt(1, productId);
                ps1.executeUpdate();

                ps2.setInt(1, productId);
                ps2.setInt(2, imageId);
                ps2.executeUpdate();

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

    private ProductImage mapResultSetToProductImage(ResultSet rs) throws SQLException {
        ProductImage img = new ProductImage();
        img.setImageId(rs.getInt("image_id"));
        img.setProductId(rs.getInt("product_id"));
        img.setImagePath(rs.getString("image_path"));
        img.setPrimary(rs.getBoolean("is_primary"));
        img.setCreatedAt(rs.getTimestamp("created_at"));
        return img;
    }
}
