package com.gruhu.controller;

import com.gruhu.model.Customer;
import com.gruhu.model.Order;
import com.gruhu.service.OrderService;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/my-orders", "/order-details", "/order-success", "/payment"})
public class OrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customer") : null;
        String path = request.getServletPath();

        if ("/payment".equals(path)) {
            String orderId = request.getParameter("orderId");
            request.setAttribute("orderId", orderId);
            request.setAttribute("pageTitle", "Curated Payment Settlement — Gruhu Atelier");
            request.getRequestDispatcher("/WEB-INF/views/customer/payment.jsp").forward(request, response);
            return;
        }

        if ("/order-success".equals(path)) {
            int orderId = ValidationUtil.parseInt(request.getParameter("orderId"), 0);
            Order order = null;
            if (customer != null && orderId > 0) {
                order = orderService.getOrderDetails(orderId, customer.getCustomerId());
            }
            if (order == null && session != null) {
                Order recent = (Order) session.getAttribute("recentOrder");
                if (recent != null && (orderId == 0 || recent.getOrderId() == orderId)) {
                    order = recent;
                }
            }
            if (order == null && orderId > 0) {
                order = orderService.getOrderDetailsForAdmin(orderId);
            }

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("pageTitle", "Order Placed Successfully &bull; #" + (order.getOrderNumber() != null ? order.getOrderNumber() : order.getOrderId()) + " — Gruhu");
            request.getRequestDispatcher("/WEB-INF/views/customer/order-success.jsp").forward(request, response);
            return;
        }

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("/order-details".equals(path)) {
            int orderId = ValidationUtil.parseInt(request.getParameter("id"), 0);
            Order order = orderService.getOrderDetails(orderId, customer.getCustomerId());
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/my-orders");
                return;
            }
            request.setAttribute("order", order);
            request.setAttribute("pageTitle", "Order #" + order.getOrderId() + " Details — Gruhu");
            request.getRequestDispatcher("/WEB-INF/views/customer/order-details.jsp").forward(request, response);

        } else {
            List<Order> orders = orderService.getCustomerOrders(customer.getCustomerId());
            request.setAttribute("orders", orders);
            request.setAttribute("pageTitle", "My Orders & Delivery Tracking — Gruhu");
            request.getRequestDispatcher("/WEB-INF/views/customer/my-orders.jsp").forward(request, response);
        }
    }
}
