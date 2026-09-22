package com.gruhu.dao;

import com.gruhu.model.Category;
import com.gruhu.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAllActiveCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(p.product_id) AS prod_count " +
                     "FROM categories c " +
                     "LEFT JOIN products p ON c.category_id = p.category_id AND p.status = 'ACTIVE' " +
                     "WHERE (c.is_active = TRUE OR c.status = 'ACTIVE') " +
                     "GROUP BY c.category_id " +
                     "ORDER BY c.category_id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category cat = mapResultSetToCategory(rs);
                cat.setProductCount(rs.getInt("prod_count"));
                list.add(cat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(p.product_id) AS prod_count " +
                     "FROM categories c " +
                     "LEFT JOIN products p ON c.category_id = p.category_id " +
                     "GROUP BY c.category_id " +
                     "ORDER BY c.category_id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category cat = mapResultSetToCategory(rs);
                cat.setProductCount(rs.getInt("prod_count"));
                list.add(cat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (category_name, description, category_image, status, created_at) " +
                     "VALUES (?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getCategoryImage());
            ps.setString(4, category.getStatus() != null ? category.getStatus() : "ACTIVE");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        category.setCategoryId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET category_name = ?, description = ?, category_image = ?, status = ? " +
                     "WHERE category_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getCategoryImage());
            ps.setString(4, category.getStatus());
            ps.setInt(5, category.getCategoryId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category cat = new Category();
        cat.setCategoryId(rs.getInt("category_id"));
        cat.setCategoryName(rs.getString("category_name"));
        cat.setDescription(rs.getString("description"));
        String img = null;
        try { img = rs.getString("category_image"); } catch (Exception ignored) {}
        if (img == null || img.trim().isEmpty()) {
            try { img = rs.getString("image_url"); } catch (Exception ignored) {}
        }
        cat.setCategoryImage(img);
        try {
            cat.setStatus(rs.getString("status"));
        } catch (Exception e) {
            cat.setStatus("ACTIVE");
        }
        try {
            cat.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (Exception ignored) {}
        return cat;
    }
}
