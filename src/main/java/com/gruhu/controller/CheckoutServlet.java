package com.gruhu.controller;

import com.gruhu.model.Address;
import com.gruhu.model.Admin;
import com.gruhu.model.Cart;
import com.gruhu.model.CartItem;
import com.gruhu.model.Customer;
import com.gruhu.model.Order;
import com.gruhu.service.CartService;
import com.gruhu.service.CustomerService;
import com.gruhu.service.OrderService;
import com.gruhu.util.PasswordUtil;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/checkout", "/booking"})
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CartService cartService = new CartService();
    private final CustomerService customerService = new CustomerService();
    private final OrderService orderService = new OrderService();

    private Customer resolveCustomer(HttpSession session) {
        if (session == null) return null;
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer != null) return customer;

        Admin admin = (Admin) session.getAttribute("admin");
        if (admin != null) {
            customer = customerService.getCustomerByEmail(admin.getEmail());
            if (customer != null) {
                session.setAttribute("customer", customer);
                return customer;
            }
        }
        return null;
    }

    private Cart resolveCart(HttpSession session, Customer customer) {
        if (customer != null) {
            return cartService.getCart(customer.getCustomerId());
        }
        if (session != null) {
            return (Cart) session.getAttribute("guestCart");
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);
        Cart cart = resolveCart(session, customer);

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<Address> addresses = new ArrayList<>();
        Address defaultAddress = null;

        if (customer != null) {
            addresses = customerService.getCustomerAddresses(customer.getCustomerId());
            defaultAddress = customerService.getDefaultAddress(customer.getCustomerId());
        }

        request.setAttribute("cart", cart);
        request.setAttribute("addresses", addresses);
        request.setAttribute("defaultAddress", defaultAddress);
        request.setAttribute("customer", customer);
        request.setAttribute("pageTitle", "Secure Atelier Booking & Checkout — Gruhu");

        request.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Customer customer = resolveCustomer(session);
        Cart cart = resolveCart(session, customer);

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String receiverName = request.getParameter("receiverName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String houseAddress = request.getParameter("houseAddress");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String addressType = request.getParameter("addressType");
        String deliveryOption = request.getParameter("deliveryOption");
        String paymentMethod = request.getParameter("paymentMethod");
        String orderNotes = request.getParameter("orderNotes");

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD";
        }
        if (deliveryOption == null || deliveryOption.trim().isEmpty()) {
            deliveryOption = "Complimentary White-Glove Delivery";
        }

        try {
            // If customer is guest, ensure we have / create a customer record
            if (customer == null) {
                if (!ValidationUtil.isNotEmpty(receiverName) || !ValidationUtil.isValidPhone(phone)
                        || !ValidationUtil.isNotEmpty(houseAddress) || !ValidationUtil.isNotEmpty(pincode)) {
                    request.setAttribute("errorMessage", "Please provide complete delivery address and recipient details.");
                    doGet(request, response);
                    return;
                }

                String customerEmail = (email != null && ValidationUtil.isValidEmail(email)) 
                        ? email.trim().toLowerCase() 
                        : "guest." + System.currentTimeMillis() + "@atelier.gruhu";

                String cleanPhone = (phone != null) ? phone.replaceAll("[^0-9]", "") : "";
                if (cleanPhone.length() < 10) cleanPhone = "9989055955";

                customer = customerService.getCustomerByEmail(customerEmail);
                com.gruhu.dao.CustomerDAO custDAO = new com.gruhu.dao.CustomerDAO();
                if (customer == null) {
                    customer = custDAO.findByPhone(cleanPhone);
                }
                if (customer == null) {
                    String dummyPass = PasswordUtil.hashPassword("Gruhu@" + cleanPhone.substring(cleanPhone.length() - 4));
                    Customer newCust = new Customer(0, receiverName.trim(), customerEmail, cleanPhone, dummyPass, "ACTIVE", null);
                    custDAO.registerCustomer(newCust);
                    customer = newCust;
                }
                session.setAttribute("customer", customer);
            }

            // Transfer guest cart items into DB cart for customer
            Cart guestCart = (Cart) session.getAttribute("guestCart");
            if (guestCart != null && !guestCart.isEmpty()) {
                for (CartItem item : guestCart.getItems()) {
                    try {
                        cartService.addToCart(customer.getCustomerId(), item.getProductId(), item.getQuantity());
                    } catch (Exception ignored) {}
                }
                session.removeAttribute("guestCart");
            }

            // Resolve or save address
            int addressId = ValidationUtil.parseInt(request.getParameter("selectedAddressId"), 0);
            String addressOption = request.getParameter("addressOption");

            if ("new".equalsIgnoreCase(addressOption) || addressId == 0) {
                if (!ValidationUtil.isNotEmpty(receiverName) || !ValidationUtil.isValidPhone(phone)
                        || !ValidationUtil.isNotEmpty(houseAddress) || !ValidationUtil.isNotEmpty(pincode)) {
                    request.setAttribute("errorMessage", "Please provide complete delivery address details.");
                    doGet(request, response);
                    return;
                }

                Address newAddr = new Address(0, customer.getCustomerId(), receiverName, phone,
                        houseAddress, city != null ? city : "Rajahmundry", state != null ? state : "Andhra Pradesh",
                        pincode, addressType != null ? addressType : "HOME", true);
                customerService.addAddress(newAddr);
                addressId = newAddr.getAddressId();
            }

            // Place Order into MySQL orders and order_items
            Order order = orderService.placeOrder(customer.getCustomerId(), addressId, paymentMethod,
                    BigDecimal.ZERO, deliveryOption, orderNotes);

            // Update session
            session.setAttribute("cartCount", 0);
            session.setAttribute("recentOrder", order);

            response.sendRedirect(request.getContextPath() + "/order-success?orderId=" + order.getOrderId());

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Error booking order: " + ex.getMessage());
            doGet(request, response);
        }
    }
}
