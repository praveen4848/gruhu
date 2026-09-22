package com.gruhu.util;

import com.gruhu.dao.*;
import com.gruhu.model.*;
import java.util.List;

public class VerifyDatabase {
    public static void main(String[] args) {
        System.out.println("=== GRUHU DATABASE VERIFICATION ===");
        
        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.findByUsername("admin");
        System.out.println("Admin User: " + (admin != null ? admin.getUsername() + " (" + admin.getEmail() + ")" : "NOT FOUND"));

        CategoryDAO catDAO = new CategoryDAO();
        List<Category> cats = catDAO.getAllCategories();
        System.out.println("Categories Count: " + cats.size());
        for (Category c : cats) {
            System.out.println(" - " + c.getCategoryName() + " (ID: " + c.getCategoryId() + ")");
        }

        SubcategoryDAO subDAO = new SubcategoryDAO();
        List<Subcategory> subs = subDAO.getAllSubcategories();
        System.out.println("Subcategories Count: " + subs.size());

        ProductDAO prodDAO = new ProductDAO();
        List<Product> prods = prodDAO.getAllActiveProducts("featured");
        System.out.println("Active Products Count: " + prods.size());
        for (Product p : prods) {
            System.out.println(" * [" + p.getCategoryName() + "] " + p.getProductName() + " - Rs. " + p.getPrice() + " (Stock: " + p.getStockQuantity() + ")");
        }

        ProductImageDAO imgDAO = new ProductImageDAO();
        if (!prods.isEmpty()) {
            List<ProductImage> imgs = imgDAO.getImagesByProductId(prods.get(0).getProductId());
            System.out.println("Images for first product (" + prods.get(0).getProductName() + "): " + imgs.size());
        }

        CustomerDAO custDAO = new CustomerDAO();
        System.out.println("Total Customers: " + custDAO.getTotalCustomerCount());

        OrderDAO orderDAO = new OrderDAO();
        System.out.println("Total Orders: " + orderDAO.getTotalOrderCount());
        System.out.println("=== VERIFICATION COMPLETE ===");
    }
}
