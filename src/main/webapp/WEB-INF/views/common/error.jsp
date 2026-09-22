<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="error-page" style="min-height: 70vh; display: flex; align-items: center; justify-content: center; text-align: center; padding: 60px 24px;">
    <div style="max-width: 540px;">
        <span style="font-family: var(--font-serif); font-size: 4rem; font-weight: 700; color: #a82a2a; line-height: 1; display: block; margin-bottom: 12px;">Notice</span>
        <h1 style="font-family: var(--font-serif); font-size: 1.85rem; color: var(--dark-espresso); margin-bottom: 16px;">A Momentary Pause in Craftsmanship</h1>
        <p style="color: var(--text-secondary); font-size: 1rem; line-height: 1.6; margin-bottom: 32px;">
            We encountered an unexpected challenge processing your request. Our curatorial engineering team has been notified.
        </p>
        <div style="display: flex; gap: 16px; justify-content: center;">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg">
                <i class="fa-solid fa-house"></i> Return to Atelier
            </a>
            <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline btn-lg">
                Contact Concierge
            </a>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
