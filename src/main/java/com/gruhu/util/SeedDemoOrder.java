package com.gruhu.util;

import com.gruhu.model.*;
import com.gruhu.service.*;

public class SeedDemoOrder {
    public static void main(String[] args) {
        System.out.println("=== SEEDING DEMO ORDER ===");
        CustomerService custService = new CustomerService();
        CartService cartService = new CartService();
        OrderService orderService = new OrderService();
        ProductService prodService = new ProductService();

        try {
            Customer customer;
            try {
                customer = custService.register("Ananya Sharma", "ananya.sharma@example.com", "9876543210", "Secret@123");
                System.out.println("Created Customer: " + customer.getFullName());
            } catch (Exception ex) {
                customer = custService.authenticate("ananya.sharma@example.com", "Secret@123");
                System.out.println("Existing Customer Authenticated: " + customer.getFullName());
            }

            // Ensure address
            Address addr = custService.getDefaultAddress(customer.getCustomerId());
            if (addr == null) {
                addr = new Address(0, customer.getCustomerId(), "Ananya Sharma", "9876543210", 
                        "Flat 402, Nordic Palms, Indiranagar 100ft Road", "Bengaluru", "Karnataka", "560038", "HOME", true);
                custService.addAddress(addr);
                System.out.println("Added Address ID: " + addr.getAddressId());
            }

            // Add product to cart
            Product firstProd = prodService.getProductById(1); // Astrid Sculptural Lounge Chair or similar
            if (firstProd != null) {
                cartService.addToCart(customer.getCustomerId(), firstProd.getProductId(), 1);
                System.out.println("Added to cart: " + firstProd.getProductName());

                // Place order
                Order order = orderService.placeOrder(customer.getCustomerId(), addr.getAddressId(), "ONLINE");
                System.out.println("Created Order #" + order.getOrderId() + " for total: Rs. " + order.getTotalAmount());
                
                // Update payment to PAID and order to CONFIRMED
                orderService.updatePaymentStatus(order.getOrderId(), "PAID");
                orderService.updateOrderStatus(order.getOrderId(), "CONFIRMED");
                System.out.println("Updated Order #" + order.getOrderId() + " to PAID & CONFIRMED");
            }

            System.out.println("=== DEMO ORDER SEEDED SUCCESSFULLY ===");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
