package com.gruhu.controller.admin;

import com.gruhu.model.Order;
import com.gruhu.service.OrderService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/orders", "/admin/orders/*"})
public class AdminOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("details".equalsIgnoreCase(action)) {
            showOrderDetails(request, response);
            return;
        }

        listOrders(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int orderId = ValidationUtil.parseInt(request.getParameter("orderId"), 0);

        if (orderId > 0) {
            if ("updateStatus".equalsIgnoreCase(action)) {
                String orderStatus = request.getParameter("orderStatus");
                if (orderStatus != null && !orderStatus.trim().isEmpty()) {
                    orderService.updateOrderStatus(orderId, orderStatus.trim().toUpperCase());
                }
            } else if ("updatePayment".equalsIgnoreCase(action)) {
                String paymentStatus = request.getParameter("paymentStatus");
                if (paymentStatus != null && !paymentStatus.trim().isEmpty()) {
                    orderService.updatePaymentStatus(orderId, paymentStatus.trim().toUpperCase());
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders?action=details&id=" + orderId + "&success=statusUpdated");
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusFilter = request.getParameter("status");
        if ("all".equalsIgnoreCase(statusFilter) || statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = null;
        }

        List<Order> orders = orderService.getAllOrders(statusFilter);

        request.setAttribute("orders", orders);
        request.setAttribute("selectedStatus", statusFilter != null ? statusFilter : "all");
        request.setAttribute("pageTitle", "Customer Orders & Logistics — Gruhu Atelier");

        request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
    }

    private void showOrderDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = ValidationUtil.parseInt(request.getParameter("id"), 0);
        Order order = orderService.getOrderDetailsForAdmin(orderId);

        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        request.setAttribute("order", order);
        request.setAttribute("pageTitle", "Order #" + order.getOrderId() + " Details — Gruhu Atelier");

        request.getRequestDispatcher("/WEB-INF/views/admin/order-details.jsp").forward(request, response);
    }
}
