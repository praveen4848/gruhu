package com.gruhu.service;

import com.gruhu.dao.AddressDAO;
import com.gruhu.dao.CustomerDAO;
import com.gruhu.model.Address;
import com.gruhu.model.Customer;
import com.gruhu.util.PasswordUtil;
import com.gruhu.util.ValidationUtil;

import java.util.List;

public class CustomerService {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final AddressDAO addressDAO = new AddressDAO();

    public Customer register(String fullName, String email, String phone, String password) throws IllegalArgumentException {
        if (!ValidationUtil.isNotEmpty(fullName)) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Please enter a valid email address.");
        }
        if (!ValidationUtil.isValidPhone(phone)) {
            throw new IllegalArgumentException("Please enter a valid 10-digit mobile number.");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            throw new IllegalArgumentException("Password must be at least 6 characters long.");
        }

        if (customerDAO.findByEmail(email) != null) {
            throw new IllegalArgumentException("An account with this email already exists. Please log in.");
        }
        if (customerDAO.findByPhone(phone) != null) {
            throw new IllegalArgumentException("An account with this mobile number already exists. Please log in.");
        }

        String passwordHash = PasswordUtil.hashPassword(password);
        Customer customer = new Customer(0, fullName.trim(), email.trim(), phone.trim(), passwordHash, "ACTIVE", null);

        boolean success = customerDAO.registerCustomer(customer);
        if (!success) {
            throw new RuntimeException("Registration failed due to a server error. Please try again.");
        }
        return customer;
    }

    public Customer authenticate(String email, String password) {
        if (!ValidationUtil.isValidEmail(email) || !ValidationUtil.isNotEmpty(password)) {
            return null;
        }

        Customer customer = customerDAO.findByEmail(email);
        if (customer == null) {
            return null;
        }

        if (!"ACTIVE".equalsIgnoreCase(customer.getStatus())) {
            return null;
        }

        if (PasswordUtil.verifyPassword(password, customer.getPasswordHash())) {
            return customer;
        }
        return null;
    }

    public Customer getCustomerById(int customerId) {
        return customerDAO.findById(customerId);
    }

    public Customer getCustomerByEmail(String email) {
        if (!ValidationUtil.isValidEmail(email)) {
            return null;
        }
        return customerDAO.findByEmail(email);
    }

    public boolean updateProfile(int customerId, String fullName, String phone) {
        if (!ValidationUtil.isNotEmpty(fullName) || !ValidationUtil.isValidPhone(phone)) {
            return false;
        }
        Customer c = new Customer();
        c.setCustomerId(customerId);
        c.setFullName(fullName.trim());
        c.setPhone(phone.trim());
        return customerDAO.updateProfile(c);
    }

    public boolean changePassword(int customerId, String currentPassword, String newPassword) {
        Customer c = customerDAO.findById(customerId);
        if (c == null) return false;

        if (!PasswordUtil.verifyPassword(currentPassword, c.getPasswordHash())) {
            return false;
        }

        if (!ValidationUtil.isValidPassword(newPassword)) {
            return false;
        }

        String newHash = PasswordUtil.hashPassword(newPassword);
        return customerDAO.updatePassword(customerId, newHash);
    }

    public List<Address> getCustomerAddresses(int customerId) {
        return addressDAO.getAddressesByCustomerId(customerId);
    }

    public boolean addAddress(Address address) {
        return addressDAO.addAddress(address);
    }

    public boolean updateAddress(Address address) {
        return addressDAO.updateAddress(address);
    }

    public boolean deleteAddress(int addressId, int customerId) {
        return addressDAO.deleteAddress(addressId, customerId);
    }

    public boolean setDefaultAddress(int customerId, int addressId) {
        return addressDAO.setDefaultAddress(customerId, addressId);
    }

    public Address getDefaultAddress(int customerId) {
        return addressDAO.getDefaultAddress(customerId);
    }

    public List<Customer> getAllCustomers() {
        return customerDAO.getAllCustomers();
    }

    public boolean updateCustomerStatus(int customerId, String status) {
        return customerDAO.updateStatus(customerId, status);
    }
}
