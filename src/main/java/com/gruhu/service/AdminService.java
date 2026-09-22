package com.gruhu.service;

import com.gruhu.dao.AdminDAO;
import com.gruhu.dao.ContactMessageDAO;
import com.gruhu.dao.CustomerDAO;
import com.gruhu.dao.OrderDAO;
import com.gruhu.dao.ProductDAO;
import com.gruhu.model.Admin;
import com.gruhu.model.ContactMessage;
import com.gruhu.model.Order;
import com.gruhu.model.Product;
import com.gruhu.util.PasswordUtil;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminService {

    private final AdminDAO adminDAO = new AdminDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ContactMessageDAO messageDAO = new ContactMessageDAO();

    public Admin authenticate(String username, String password) {
        if (username == null || password == null) return null;
        Admin admin = adminDAO.findByUsername(username);
        if (admin == null) return null;

        if (PasswordUtil.verifyPassword(password, admin.getPasswordHash())) {
            return admin;
        }
        return null;
    }

    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        stats.put("totalRevenue", orderDAO.getTotalRevenue());
        stats.put("totalOrders", orderDAO.getTotalOrderCount());
        stats.put("totalProducts", productDAO.getTotalProductCount());
        stats.put("totalCustomers", customerDAO.getTotalCustomerCount());
        stats.put("unreadMessages", messageDAO.getUnreadMessageCount());

        List<Order> recentOrders = orderDAO.getRecentOrders(6);
        stats.put("recentOrders", recentOrders);

        List<Product> lowStock = productDAO.getLowStockProducts(10);
        stats.put("lowStockProducts", lowStock);

        return stats;
    }

    public Admin getAdminById(int adminId) {
        return adminDAO.findById(adminId);
    }

    public boolean updateProfile(int adminId, String name, String email) {
        Admin admin = new Admin();
        admin.setAdminId(adminId);
        admin.setName(name);
        admin.setEmail(email);
        return adminDAO.updateProfile(admin);
    }

    public boolean changePassword(int adminId, String currentPassword, String newPassword) {
        Admin admin = adminDAO.findById(adminId);
        if (admin == null) return false;
        if (!PasswordUtil.verifyPassword(currentPassword, admin.getPasswordHash())) {
            return false;
        }
        String newHash = PasswordUtil.hashPassword(newPassword);
        return adminDAO.updatePassword(adminId, newHash);
    }

    public List<ContactMessage> getAllMessages() {
        return messageDAO.getAllMessages();
    }

    public boolean updateMessageStatus(int messageId, String status) {
        return messageDAO.updateMessageStatus(messageId, status);
    }
}
