package com.gruhu.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/my-orders",
        "/order-details",
        "/profile",
        "/addresses"
})
public class CustomerAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && (session.getAttribute("customer") != null || session.getAttribute("admin") != null || session.getAttribute("adminUser") != null));

        if (isLoggedIn) {
            if (session.getAttribute("customer") == null) {
                com.gruhu.model.Admin admin = (com.gruhu.model.Admin) session.getAttribute("admin");
                if (admin == null) {
                    admin = (com.gruhu.model.Admin) session.getAttribute("adminUser");
                }
                if (admin != null && admin.getEmail() != null) {
                    com.gruhu.service.CustomerService cs = new com.gruhu.service.CustomerService();
                    com.gruhu.model.Customer customer = cs.getCustomerByEmail(admin.getEmail());
                    if (customer != null) {
                        session.setAttribute("customer", customer);
                    }
                }
            }
            chain.doFilter(request, response);
        } else {
            String uri = httpRequest.getRequestURI();
            String query = httpRequest.getQueryString();
            String redirectUrl = (query != null) ? uri + "?" + query : uri;

            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?redirect=" +
                    java.net.URLEncoder.encode(redirectUrl, java.nio.charset.StandardCharsets.UTF_8));
        }
    }
}
