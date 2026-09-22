package com.gruhu.controller.admin;

import com.gruhu.model.ContactMessage;
import com.gruhu.model.Customer;
import com.gruhu.service.AdminService;
import com.gruhu.service.CustomerService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/customers", "/admin/messages"})
public class AdminCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final CustomerService customerService = new CustomerService();
    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/messages".equals(path)) {
            List<ContactMessage> messages = adminService.getAllMessages();
            request.setAttribute("messages", messages);
            request.setAttribute("pageTitle", "Curator Inquiries & Messages — Gruhu Atelier");
            request.getRequestDispatcher("/WEB-INF/views/admin/contact-messages.jsp").forward(request, response);
            return;
        }

        // Default: /admin/customers
        List<Customer> customers = customerService.getAllCustomers();
        request.setAttribute("customers", customers);
        request.setAttribute("pageTitle", "Customer Registry — Gruhu Atelier");
        request.getRequestDispatcher("/WEB-INF/views/admin/customers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/messages".equals(path)) {
            int messageId = ValidationUtil.parseInt(request.getParameter("messageId"), 0);
            String status = request.getParameter("status");
            if (messageId > 0 && ValidationUtil.isNotEmpty(status)) {
                adminService.updateMessageStatus(messageId, status.trim().toUpperCase());
            }
            response.sendRedirect(request.getContextPath() + "/admin/messages?success=updated");
            return;
        }

        // Customer status update
        int customerId = ValidationUtil.parseInt(request.getParameter("customerId"), 0);
        String status = request.getParameter("status");

        if (customerId > 0 && ValidationUtil.isNotEmpty(status)) {
            customerService.updateCustomerStatus(customerId, status.trim().toUpperCase());
        }

        response.sendRedirect(request.getContextPath() + "/admin/customers?success=updated");
    }
}
