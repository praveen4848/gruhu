package com.gruhu.dao;

import com.gruhu.model.Subcategory;
import com.gruhu.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubcategoryDAO {

    public List<Subcategory> getSubcategoriesByCategoryId(int categoryId) {
        List<Subcategory> list = new ArrayList<>();
        String sql = "SELECT s.*, c.category_name " +
                     "FROM subcategories s " +
                     "JOIN categories c ON s.category_id = c.category_id " +
                     "WHERE s.category_id = ? AND s.status = 'ACTIVE' " +
                     "ORDER BY s.subcategory_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToSubcategory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Subcategory> getAllSubcategories() {
        List<Subcategory> list = new ArrayList<>();
        String sql = "SELECT s.*, c.category_name " +
                     "FROM subcategories s " +
                     "JOIN categories c ON s.category_id = c.category_id " +
                     "ORDER BY c.category_name ASC, s.subcategory_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToSubcategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Subcategory getSubcategoryById(int subcategoryId) {
        String sql = "SELECT s.*, c.category_name " +
                     "FROM subcategories s " +
                     "JOIN categories c ON s.category_id = c.category_id " +
                     "WHERE s.subcategory_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subcategoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSubcategory(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addSubcategory(Subcategory subcategory) {
        String sql = "INSERT INTO subcategories (category_id, subcategory_name, description, status) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, subcategory.getCategoryId());
            ps.setString(2, subcategory.getSubcategoryName());
            ps.setString(3, subcategory.getDescription());
            ps.setString(4, subcategory.getStatus() != null ? subcategory.getStatus() : "ACTIVE");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        subcategory.setSubcategoryId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSubcategory(Subcategory subcategory) {
        String sql = "UPDATE subcategories SET category_id = ?, subcategory_name = ?, description = ?, status = ? " +
                     "WHERE subcategory_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subcategory.getCategoryId());
            ps.setString(2, subcategory.getSubcategoryName());
            ps.setString(3, subcategory.getDescription());
            ps.setString(4, subcategory.getStatus());
            ps.setInt(5, subcategory.getSubcategoryId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteSubcategory(int subcategoryId) {
        String sql = "DELETE FROM subcategories WHERE subcategory_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subcategoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Subcategory mapResultSetToSubcategory(ResultSet rs) throws SQLException {
        Subcategory sub = new Subcategory();
        sub.setSubcategoryId(rs.getInt("subcategory_id"));
        sub.setCategoryId(rs.getInt("category_id"));
        sub.setSubcategoryName(rs.getString("subcategory_name"));
        sub.setDescription(rs.getString("description"));
        try {
            String st = rs.getString("status");
            sub.setStatus(st != null ? st : "ACTIVE");
        } catch (SQLException e) {
            sub.setStatus("ACTIVE");
        }
        try {
            sub.setCategoryName(rs.getString("category_name"));
        } catch (SQLException ignored) {
        }
        return sub;
    }
}
