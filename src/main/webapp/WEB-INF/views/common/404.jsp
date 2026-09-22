<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="error-page" style="min-height: 70vh; display: flex; align-items: center; justify-content: center; text-align: center; padding: 60px 24px;">
    <div style="max-width: 540px;">
        <span style="font-family: var(--font-serif); font-size: 5rem; font-weight: 700; color: var(--accent-amber); line-height: 1; display: block; margin-bottom: 12px;">404</span>
        <h1 style="font-family: var(--font-serif); font-size: 2rem; color: var(--dark-espresso); margin-bottom: 16px;">The Piece Has Wandered</h1>
        <p style="color: var(--text-secondary); font-size: 1rem; line-height: 1.6; margin-bottom: 32px;">
            The architectural object or destination you sought cannot be located in the current atelier exhibition. Perhaps it has returned to the master craftsman’s workshop.
        </p>
        <div style="display: flex; gap: 16px; justify-content: center;">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg">
                <i class="fa-solid fa-house"></i> Return to Atelier
            </a>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-lg">
                Explore Collection
            </a>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
