package com.gruhu.dao;

import com.gruhu.model.Admin;
import com.gruhu.util.DBConnection;

import java.sql.*;

public class AdminDAO {

    public Admin findByUsername(String usernameOrEmail) {
        if (usernameOrEmail == null) return null;
        String sql = "SELECT * FROM admin WHERE username = ? OR email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, usernameOrEmail.trim());
            ps.setString(2, usernameOrEmail.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAdmin(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Admin findById(int adminId) {
        String sql = "SELECT * FROM admin WHERE admin_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAdmin(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePassword(int adminId, String newPasswordHash) {
        String sql = "UPDATE admin SET password_hash = ? WHERE admin_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPasswordHash);
            ps.setInt(2, adminId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProfile(Admin admin) {
        String sql = "UPDATE admin SET name = ?, email = ? WHERE admin_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, admin.getName());
            ps.setString(2, admin.getEmail());
            ps.setInt(3, admin.getAdminId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin a = new Admin();
        a.setAdminId(rs.getInt("admin_id"));
        a.setUsername(rs.getString("username"));
        a.setPasswordHash(rs.getString("password_hash"));
        a.setName(rs.getString("name"));
        a.setEmail(rs.getString("email"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}
