package com.gruhu.dao;

import com.gruhu.model.Address;
import com.gruhu.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {

    public boolean addAddress(Address address) {
        String countSql = "SELECT COUNT(*) FROM addresses WHERE customer_id = ?";
        String insertSql = "INSERT INTO addresses (customer_id, receiver_name, phone, house_address, city, " +
                           "state, pincode, address_type, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            boolean isFirst = false;
            try (PreparedStatement checkPs = conn.prepareStatement(countSql)) {
                checkPs.setInt(1, address.getCustomerId());
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        isFirst = true;
                    }
                }
            }

            if (address.isDefault() || isFirst) {
                address.setDefault(true);
                clearDefault(conn, address.getCustomerId());
            }

            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, address.getCustomerId());
                ps.setString(2, address.getReceiverName());
                ps.setString(3, address.getPhone());
                ps.setString(4, address.getHouseAddress());
                ps.setString(5, address.getCity());
                ps.setString(6, address.getState());
                ps.setString(7, address.getPincode());
                ps.setString(8, address.getAddressType() != null ? address.getAddressType() : "HOME");
                ps.setBoolean(9, address.isDefault());

                int affected = ps.executeUpdate();
                if (affected > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            address.setAddressId(rs.getInt(1));
                        }
                    }
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAddress(Address address) {
        String updateSql = "UPDATE addresses SET receiver_name = ?, phone = ?, house_address = ?, city = ?, " +
                           "state = ?, pincode = ?, address_type = ?, is_default = ? WHERE address_id = ? AND customer_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            if (address.isDefault()) {
                clearDefault(conn, address.getCustomerId());
            }

            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, address.getReceiverName());
                ps.setString(2, address.getPhone());
                ps.setString(3, address.getHouseAddress());
                ps.setString(4, address.getCity());
                ps.setString(5, address.getState());
                ps.setString(6, address.getPincode());
                ps.setString(7, address.getAddressType());
                ps.setBoolean(8, address.isDefault());
                ps.setInt(9, address.getAddressId());
                ps.setInt(10, address.getCustomerId());

                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteAddress(int addressId, int customerId) {
        String sql = "DELETE FROM addresses WHERE address_id = ? AND customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, addressId);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Address> getAddressesByCustomerId(int customerId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE customer_id = ? ORDER BY is_default DESC, address_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAddress(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Address getAddressById(int addressId) {
        String sql = "SELECT * FROM addresses WHERE address_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, addressId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAddress(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Address getDefaultAddress(int customerId) {
        String sql = "SELECT * FROM addresses WHERE customer_id = ? ORDER BY is_default DESC, address_id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAddress(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean setDefaultAddress(int customerId, int addressId) {
        try (Connection conn = DBConnection.getConnection()) {
            clearDefault(conn, customerId);
            String sql = "UPDATE addresses SET is_default = TRUE WHERE customer_id = ? AND address_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, customerId);
                ps.setInt(2, addressId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private void clearDefault(Connection conn, int customerId) throws SQLException {
        String sql = "UPDATE addresses SET is_default = FALSE WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.executeUpdate();
        }
    }

    private Address mapResultSetToAddress(ResultSet rs) throws SQLException {
        Address a = new Address();
        a.setAddressId(rs.getInt("address_id"));
        a.setCustomerId(rs.getInt("customer_id"));
        a.setReceiverName(rs.getString("receiver_name"));
        a.setPhone(rs.getString("phone"));
        a.setHouseAddress(rs.getString("house_address"));
        a.setCity(rs.getString("city"));
        a.setState(rs.getString("state"));
        a.setPincode(rs.getString("pincode"));
        a.setAddressType(rs.getString("address_type"));
        a.setDefault(rs.getBoolean("is_default"));
        return a;
    }
}
