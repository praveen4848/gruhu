package com.gruhu.dao;

import com.gruhu.model.ContactMessage;
import com.gruhu.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactMessageDAO {

    public boolean saveMessage(ContactMessage msg) {
        String sql = "INSERT INTO contact_messages (name, email, phone, subject, message, sent_at, status) " +
                     "VALUES (?, ?, ?, ?, ?, NOW(), 'NEW')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, msg.getName());
            ps.setString(2, msg.getEmail());
            ps.setString(3, msg.getPhone());
            ps.setString(4, msg.getSubject());
            ps.setString(5, msg.getMessage());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        msg.setMessageId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ContactMessage> getAllMessages() {
        List<ContactMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_messages ORDER BY sent_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ContactMessage m = new ContactMessage();
                m.setMessageId(rs.getInt("message_id"));
                m.setName(rs.getString("name"));
                m.setEmail(rs.getString("email"));
                m.setPhone(rs.getString("phone"));
                m.setSubject(rs.getString("subject"));
                m.setMessage(rs.getString("message"));
                m.setSentAt(rs.getTimestamp("sent_at"));
                m.setStatus(rs.getString("status"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateMessageStatus(int messageId, String status) {
        String sql = "UPDATE contact_messages SET status = ? WHERE message_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, messageId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getUnreadMessageCount() {
        String sql = "SELECT COUNT(*) FROM contact_messages WHERE status = 'NEW'";
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
}
