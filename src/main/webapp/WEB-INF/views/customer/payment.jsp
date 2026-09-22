<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>

<%
    String orderId = request.getParameter("orderId");
    String amount = request.getParameter("amount");
    if (amount == null || amount.isEmpty()) {
        amount = "45,000";
    }
    request.setAttribute("extraCss", "cart.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="cart-page" style="min-height: 70vh;">
    <div class="catalog-header" style="text-align: center; margin-bottom: 32px;">
        <div class="catalog-breadcrumb" style="justify-content: center;">
            <a href="${pageContext.request.contextPath}/home">Atelier</a>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="${pageContext.request.contextPath}/checkout">Checkout</a>
            <i class="fa-solid fa-chevron-right"></i>
            <span>Encrypted Payment</span>
        </div>
        <h1 class="catalog-title" style="font-size: 2.2rem;">White-Glove Financial Settlement</h1>
        <p style="color: var(--text-secondary); max-width: 500px; margin: 0 auto; font-size: 0.95rem;">
            Bank-grade 256-bit encryption for your architectural furniture acquisition.
        </p>
    </div>

    <div style="max-width: 600px; margin: 0 auto;">
        <div class="cart-summary-box" style="padding: 36px; background: #ffffff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm);">
            
            <div style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid var(--border-subtle);">
                <div>
                    <span style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.1em; color: var(--text-muted);">Payable Amount</span>
                    <div style="font-family: var(--font-serif); font-size: 2rem; font-weight: 700; color: var(--dark-espresso);">&#8377;<%= amount %></div>
                </div>
                <div style="text-align: right;">
                    <span class="badge" style="background: var(--bg-sand); font-size: 0.75rem;">Instant Settlement</span>
                </div>
            </div>

            <!-- Payment Mode Tabs -->
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-weight: 600; font-size: 0.88rem; margin-bottom: 12px; color: var(--dark-espresso);">
                    Select Preferred Mode:
                </label>

                <div class="payment-methods-grid">
                    <label class="payment-method-card active" onclick="switchPayTab('upi')">
                        <div class="payment-method-left">
                            <input type="radio" name="payTab" value="upi" checked>
                            <div>
                                <strong style="display: block; font-size: 0.9rem;">UPI / Instant QR</strong>
                                <small style="color: var(--text-muted);">GPay, PhonePe, BHIM</small>
                            </div>
                        </div>
                        <i class="fa-solid fa-qrcode" style="font-size: 1.3rem; color: var(--accent-amber);"></i>
                    </label>

                    <label class="payment-method-card" onclick="switchPayTab('card')">
                        <div class="payment-method-left">
                            <input type="radio" name="payTab" value="card">
                            <div>
                                <strong style="display: block; font-size: 0.9rem;">Credit & Debit Card</strong>
                                <small style="color: var(--text-muted);">Visa, Mastercard, Amex, RuPay</small>
                            </div>
                        </div>
                        <i class="fa-regular fa-credit-card" style="font-size: 1.3rem; color: var(--accent-amber);"></i>
                    </label>
                </div>
            </div>

            <!-- UPI Section -->
            <div id="upiSection" style="margin-bottom: 28px; padding: 24px; background: var(--bg-sand); border-radius: var(--radius-sm); text-align: center;">
                <div style="font-size: 0.9rem; font-weight: 600; color: var(--dark-espresso); margin-bottom: 12px;">
                    Select UPI App or Pay via Virtual Payment Address (VPA)
                </div>

                <!-- UPI App Grid / Icons -->
                <div style="display: flex; justify-content: center; flex-wrap: wrap; gap: 10px; margin-bottom: 20px;">
                    <button type="button" class="upi-app-btn active-upi" onclick="selectUpiApp('gpay', 'Google Pay', '@okhdfcbank')"
                            style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 14px; background: #ffffff; border: 1.5px solid var(--accent-amber); border-radius: 24px; font-size: 0.8rem; font-weight: 600; color: #1f2937; cursor: pointer; transition: all 0.2s ease;">
                        <svg width="16" height="16" viewBox="0 0 24 24"><path fill="#4285F4" d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v4.51h6.6c-.29 1.52-1.14 2.82-2.4 3.68v3.05h3.88c2.27-2.09 3.665-5.17 3.665-9.17z"/><path fill="#34A853" d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.88-3.05c-1.08.72-2.45 1.16-4.05 1.16-3.12 0-5.77-2.1-6.72-4.93H1.25v3.15C3.26 21.36 7.33 24 12 24z"/><path fill="#FBBC05" d="M5.28 14.27c-.25-.72-.38-1.49-.38-2.27s.13-1.55.38-2.27V6.58H1.25C.45 8.18 0 9.99 0 12s.45 3.82 1.25 5.42l4.03-3.15z"/><path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.33 0 3.26 2.64 1.25 6.58l4.03 3.15c.95-2.83 3.6-4.98 6.72-4.98z"/></svg>
                        <span>Google Pay</span>
                    </button>

                    <button type="button" class="upi-app-btn" onclick="selectUpiApp('phonepe', 'PhonePe', '@ybl')"
                            style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 14px; background: #ffffff; border: 1.5px solid #d1d5db; border-radius: 24px; font-size: 0.8rem; font-weight: 600; color: #5f259f; cursor: pointer; transition: all 0.2s ease;">
                        <span style="display: inline-flex; align-items: center; justify-content: center; width: 18px; height: 18px; background: #5f259f; color: #fff; border-radius: 50%; font-size: 0.65rem; font-weight: 900;">पे</span>
                        <span>PhonePe</span>
                    </button>

                    <button type="button" class="upi-app-btn" onclick="selectUpiApp('paytm', 'Paytm', '@paytm')"
                            style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 14px; background: #ffffff; border: 1.5px solid #d1d5db; border-radius: 24px; font-size: 0.8rem; font-weight: 600; color: #002e6e; cursor: pointer; transition: all 0.2s ease;">
                        <span style="display: inline-flex; align-items: center; justify-content: center; width: 18px; height: 18px; background: #00b9f5; color: #002e6e; border-radius: 3px; font-size: 0.65rem; font-weight: 900;">Pay</span>
                        <span>Paytm</span>
                    </button>

                    <button type="button" class="upi-app-btn" onclick="selectUpiApp('bhim', 'BHIM UPI', '@upi')"
                            style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 14px; background: #ffffff; border: 1.5px solid #d1d5db; border-radius: 24px; font-size: 0.8rem; font-weight: 600; color: #16a34a; cursor: pointer; transition: all 0.2s ease;">
                        <i class="fa-solid fa-bolt" style="color: #ea580c; font-size: 0.85rem;"></i>
                        <span>BHIM</span>
                    </button>

                    <button type="button" class="upi-app-btn" onclick="selectUpiApp('amazon', 'Amazon Pay', '@apl')"
                            style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 14px; background: #ffffff; border: 1.5px solid #d1d5db; border-radius: 24px; font-size: 0.8rem; font-weight: 600; color: #b45309; cursor: pointer; transition: all 0.2s ease;">
                        <i class="fa-brands fa-amazon-pay" style="color: #d97706; font-size: 0.95rem;"></i>
                        <span>Amazon Pay</span>
                    </button>
                </div>

                <div style="max-width: 380px; margin: 0 auto;">
                    <label id="upiVpaLabel" style="display: block; font-size: 0.78rem; text-align: left; color: var(--text-muted); margin-bottom: 4px; font-weight: 600;">
                        Enter Google Pay VPA / UPI ID
                    </label>
                    <input type="text" id="upiVpaInput" class="form-input" placeholder="e.g. mobile@okhdfcbank" value="patron@okhdfcbank" style="margin-bottom: 12px; text-align: center; font-weight: 500;">
                </div>

                <div style="display: flex; align-items: center; justify-content: center; gap: 10px; margin-top: 10px; font-size: 0.78rem; color: var(--text-muted);">
                    <i class="fa-solid fa-shield-check" style="color: var(--accent-sage);"></i>
                    <span>NPCI Verified &bull; Zero convenience fees charged &bull; Instant Settlement</span>
                </div>
            </div>

            <script>
                function selectUpiApp(appKey, appName, sampleDomain) {
                    document.querySelectorAll('.upi-app-btn').forEach(btn => {
                        btn.style.borderColor = '#d1d5db';
                        btn.style.boxShadow = 'none';
                    });
                    if (event && event.currentTarget) {
                        event.currentTarget.style.borderColor = 'var(--accent-amber)';
                        event.currentTarget.style.boxShadow = '0 0 0 2px rgba(184, 115, 51, 0.2)';
                    }
                    const lbl = document.getElementById('upiVpaLabel');
                    const inp = document.getElementById('upiVpaInput');
                    if (lbl) lbl.textContent = 'Enter ' + appName + ' VPA / UPI ID';
                    if (inp) inp.placeholder = 'e.g. mobile' + sampleDomain;
                }
            </script>

            <!-- Card Section (Hidden initially) -->
            <div id="cardSection" style="display: none; margin-bottom: 28px; padding: 20px; background: var(--bg-sand); border-radius: var(--radius-sm);">
                <div class="form-group" style="margin-bottom: 14px;">
                    <label>Card Number</label>
                    <input type="text" class="form-input" placeholder="4532 &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; 8921">
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="form-group">
                        <label>Expiry (MM/YY)</label>
                        <input type="text" class="form-input" placeholder="08/29">
                    </div>
                    <div class="form-group">
                        <label>CVV</label>
                        <input type="password" maxlength="4" class="form-input" placeholder="&bull;&bull;&bull;">
                    </div>
                </div>
            </div>

            <!-- Submit Button -->
            <form action="${pageContext.request.contextPath}/order-success" method="get">
                <% if (orderId != null) { %>
                    <input type="hidden" name="orderId" value="<%= orderId %>">
                <% } %>
                <button type="submit" class="btn btn-primary btn-block btn-lg" style="gap: 10px;">
                    <i class="fa-solid fa-lock"></i>
                    <span>Authorize & Complete Payment</span>
                </button>
            </form>

            <div style="display: flex; justify-content: center; gap: 20px; margin-top: 24px; color: var(--text-muted); font-size: 0.8rem;">
                <span><i class="fa-solid fa-shield-halved"></i> PCI-DSS Level 1</span>
                <span><i class="fa-solid fa-certificate"></i> Verified Atelier</span>
            </div>

        </div>
    </div>
</main>

<script>
    function switchPayTab(type) {
        document.querySelectorAll('.payment-method-card').forEach(c => c.classList.remove('active'));
        if (type === 'upi') {
            document.getElementById('upiSection').style.display = 'block';
            document.getElementById('cardSection').style.display = 'none';
        } else {
            document.getElementById('upiSection').style.display = 'none';
            document.getElementById('cardSection').style.display = 'block';
        }
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
