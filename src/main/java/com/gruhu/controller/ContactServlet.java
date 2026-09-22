package com.gruhu.controller;

import com.gruhu.dao.ContactMessageDAO;
import com.gruhu.model.ContactMessage;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = {"/contact", "/about"})
public class ContactServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ContactMessageDAO messageDAO = new ContactMessageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/about".equals(path)) {
            request.setAttribute("pageTitle", "Our Philosophy & Craftsmanship — Gruhu");
            request.getRequestDispatcher("/WEB-INF/views/customer/about.jsp").forward(request, response);
        } else {
            request.setAttribute("pageTitle", "Contact Studio & Interior Advisory — Gruhu");
            request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (!ValidationUtil.isNotEmpty(name) || !ValidationUtil.isValidEmail(email) || !ValidationUtil.isNotEmpty(message)) {
            request.setAttribute("errorMessage", "Please provide your name, valid email, and a message.");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("subject", subject);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
            return;
        }

        ContactMessage msg = new ContactMessage(0, name.trim(), email.trim(), phone, subject, message.trim(), null, "NEW");
        boolean saved = messageDAO.saveMessage(msg);

        if (saved) {
            request.setAttribute("successMessage", "Thank you for reaching out to Gruhu Studio. An interior architect will contact you within 24 hours.");
        } else {
            request.setAttribute("errorMessage", "Unable to send your inquiry due to a network glitch. Please try again or call our studio directly.");
        }

        request.setAttribute("pageTitle", "Contact Studio & Interior Advisory — Gruhu");
        request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
    }
}
