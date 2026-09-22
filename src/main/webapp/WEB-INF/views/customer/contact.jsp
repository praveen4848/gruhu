<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String name = (String) request.getAttribute("name");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    String subject = (String) request.getAttribute("subject");
    String message = (String) request.getAttribute("message");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="home-main">

    <!-- Header -->
    <section class="hero-section" style="padding: 70px 40px 50px; text-align: center;">
        <div style="max-width: 700px; margin: 0 auto;">
            <span class="hero-eyebrow">Studio & Client Concierge</span>
            <h1 class="hero-title" style="font-size: 3.2rem;">Connect with Our Atelier.</h1>
            <p class="hero-desc" style="margin-left: auto; margin-right: auto;">
                Whether you need bespoke architectural dimensions, custom fabric swatches, or styling guidance for a full home, our design advisors are at your service.
            </p>
        </div>
    </section>

    <!-- Main Content -->
    <section class="home-section" style="padding: 60px 40px 100px;">
        <div class="section-container" style="display: grid; grid-template-columns: 1.3fr 1fr; gap: 70px;">

            <!-- Contact Form -->
            <div style="background: #ffffff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); padding: 40px;">
                <h2 style="font-family: var(--font-serif); font-size: 2rem; color: var(--dark-espresso); margin-bottom: 8px;">Send an Inquiry</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 28px;">Fill in your details below and an atelier architect will reply within 24 hours.</p>

                <% if (successMessage != null) { %>
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        <span><%= successMessage %></span>
                    </div>
                <% } %>

                <% if (errorMessage != null) { %>
                    <div class="alert alert-danger">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <span><%= errorMessage %></span>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/contact" method="post" style="display: flex; flex-direction: column; gap: 20px;">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div>
                            <label style="display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 6px;">Full Name *</label>
                            <input type="text" name="name" value="<%= name != null ? name : "" %>" required 
                                   style="width: 100%; padding: 12px 14px; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); outline: none; font-size: 0.92rem;">
                        </div>
                        <div>
                            <label style="display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 6px;">Email Address *</label>
                            <input type="email" name="email" value="<%= email != null ? email : "" %>" required
                                   style="width: 100%; padding: 12px 14px; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); outline: none; font-size: 0.92rem;">
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div>
                            <label style="display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 6px;">Contact Phone</label>
                            <input type="tel" name="phone" value="<%= phone != null ? phone : "" %>" placeholder="+91 98765 43210"
                                   style="width: 100%; padding: 12px 14px; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); outline: none; font-size: 0.92rem;">
                        </div>
                        <div>
                            <label style="display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 6px;">Inquiry Subject</label>
                            <select name="subject" style="width: 100%; padding: 12px 14px; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); outline: none; font-size: 0.92rem; background: #fff;">
                                <option value="Custom Interior Advisory" <%= "Custom Interior Advisory".equals(subject) ? "selected" : "" %>>Custom Interior Advisory</option>
                                <option value="Product Sizing & Swatches" <%= "Product Sizing & Swatches".equals(subject) ? "selected" : "" %>>Product Sizing & Swatches</option>
                                <option value="Order Tracking & White Glove" <%= "Order Tracking & White Glove".equals(subject) ? "selected" : "" %>>Order Tracking & White Glove</option>
                                <option value="Architect & Trade Program" <%= "Architect & Trade Program".equals(subject) ? "selected" : "" %>>Architect & Trade Program</option>
                            </select>
                        </div>
                    </div>

                    <div>
                        <label style="display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 6px;">Your Message *</label>
                        <textarea name="message" rows="5" required placeholder="Tell us about your space or questions..."
                                  style="width: 100%; padding: 12px 14px; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); outline: none; font-size: 0.92rem; resize: vertical;"><%= message != null ? message : "" %></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg" style="align-self: flex-start;">
                        <span>Dispatch Message</span>
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </form>
            </div>

            <!-- Studio Info Card -->
            <div style="display: flex; flex-direction: column; gap: 30px;">
                <div style="background: var(--bg-sand); border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); padding: 36px;">
                    <h3 style="font-family: var(--font-serif); font-size: 1.6rem; color: var(--dark-espresso); margin-bottom: 16px;">Rajahmundry Atelier & Gallery</h3>
                    <p style="color: var(--text-secondary); line-height: 1.7; margin-bottom: 24px;">
                        Visit our flagship gallery to touch fabric swatches, experience timber seat depths in person, and sip pour-over coffee with our studio architects.
                    </p>

                    <div style="display: flex; flex-direction: column; gap: 14px; font-size: 0.92rem; color: var(--text-secondary);">
                        <div>
                            <strong style="color: var(--dark-espresso); display: block;"><i class="fa-solid fa-location-dot" style="color: var(--accent-amber); margin-right: 8px;"></i> Gallery Address</strong>
                            <span>Rajahmundry , 533102</span>
                        </div>
                        <div>
                            <strong style="color: var(--dark-espresso); display: block;"><i class="fa-solid fa-clock" style="color: var(--accent-amber); margin-right: 8px;"></i> Studio Hours</strong>
                            <span>Tuesday &ndash; Sunday: 10:00 AM &ndash; 8:00 PM (Mondays by appointment)</span>
                        </div>
                        <div>
                            <strong style="color: var(--dark-espresso); display: block;"><i class="fa-solid fa-phone" style="color: var(--accent-amber); margin-right: 8px;"></i> Telephone Direct</strong>
                            <span>+91 9989055955</span>
                        </div>
                        <div>
                            <strong style="color: var(--dark-espresso); display: block;"><i class="fa-solid fa-envelope" style="color: var(--accent-amber); margin-right: 8px;"></i> Direct Email</strong>
                            <span>praveena2z029@gmail.com</span>
                        </div>
                    </div>
                </div>

                <div style="border-radius: var(--radius-sm); overflow: hidden; height: 260px; box-shadow: var(--shadow-subtle);">
                    <img src="https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80" 
                         alt="Gruhu Rajahmundry Studio" style="width: 100%; height: 100%; object-fit: cover;">
                </div>
            </div>

        </div>
    </section>

</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
