<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.gruhu.model.Cart" %>
<%@ page import="com.gruhu.model.CartItem" %>
<%@ page import="com.gruhu.model.Address" %>
<%@ page import="com.gruhu.model.Product" %>

<%
    Cart cart = (Cart) request.getAttribute("cart");
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
    Address defaultAddress = (Address) request.getAttribute("defaultAddress");
    String errorMessage = (String) request.getAttribute("errorMessage");

    BigDecimal subtotal = (cart != null) ? cart.getTotalAmount() : BigDecimal.ZERO;
    boolean isFreeDelivery = true;
    BigDecimal shipping = BigDecimal.ZERO;
    BigDecimal grandTotal = subtotal;
    request.setAttribute("extraCss", "cart.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="cart-page">
    <div class="catalog-header">
        <div class="catalog-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="${pageContext.request.contextPath}/cart">Bag</a>
            <i class="fa-solid fa-chevron-right"></i>
            <span>Secure Checkout</span>
        </div>
        <h1 class="catalog-title">Finalize Your Acquisition</h1>
    </div>

    <% if (errorMessage != null) { %>
        <div class="alert alert-danger" style="margin-bottom: 24px;">
            <i class="fa-solid fa-circle-exclamation"></i> <span><%= errorMessage %></span>
        </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
        <div class="checkout-layout">

            <!-- Left Form Area -->
            <div>

                <!-- Step 1: Delivery Address -->
                <div class="checkout-section-box">
                    <div class="checkout-section-header">
                        <div class="checkout-step-number">1</div>
                        <h3>Shipping & White Glove Destination</h3>
                    </div>

                    <% if (addresses != null && !addresses.isEmpty()) { %>
                        <div class="address-select-grid">
                            <% for (int i = 0; i < addresses.size(); i++) {
                                Address addr = addresses.get(i);
                                boolean isChecked = (defaultAddress != null && defaultAddress.getAddressId() == addr.getAddressId()) || (defaultAddress == null && i == 0);
                            %>
                                <label class="address-radio-card <%= isChecked ? "active" : "" %>">
                                    <input type="radio" name="selectedAddressId" value="<%= addr.getAddressId() %>" 
                                           <%= isChecked ? "checked" : "" %> onchange="selectAddressCard(this)">
                                    <div>
                                        <div style="font-weight: 700; color: var(--dark-espresso); margin-bottom: 4px;">
                                            <%= addr.getReceiverName() %>
                                            <span class="badge" style="background: var(--bg-sand); font-size: 0.7rem; margin-left: 6px;"><%= addr.getAddressType() %></span>
                                        </div>
                                        <p style="font-size: 0.85rem; color: var(--text-secondary); line-height: 1.5;">
                                            <%= addr.getHouseAddress() %>, <%= addr.getCity() %>, <%= addr.getState() %> - <%= addr.getPincode() %>
                                        </p>
                                        <small style="color: var(--text-muted); font-size: 0.8rem;">Ph: +91 <%= addr.getPhone() %></small>
                                    </div>
                                </label>
                            <% } %>
                        </div>

                        <div style="margin-top: 14px;">
                            <label style="font-size: 0.9rem; font-weight: 600; display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                <input type="checkbox" id="addNewAddressToggle" name="addressOption" value="new" onchange="toggleNewAddressFields(this)">
                                <span>Deliver to a different or new address instead</span>
                            </label>
                        </div>
                    <% } else { %>
                        <input type="hidden" name="addressOption" value="new">
                    <% } %>

                    <!-- New Address Input Fields (Hidden if saved addresses exist, unless toggled) -->
                    <div id="newAddressContainer" style="<%= (addresses != null && !addresses.isEmpty()) ? "display: none;" : "display: block;" %> margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border-subtle);">
                        <h4 style="font-family: var(--font-serif); font-size: 1.15rem; margin-bottom: 16px;">New Destination Details</h4>

                        <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                            <div class="form-group">
                                <label>Recipient Full Name *</label>
                                <input type="text" name="receiverName" class="form-input" placeholder="Praveen Kumar" value="${customer != null ? customer.fullName : ''}">
                            </div>
                            <div class="form-group">
                                <label>Mobile Contact *</label>
                                <input type="tel" name="phone" class="form-input" placeholder="9989055955" value="${customer != null ? customer.phone : ''}">
                            </div>
                            <div class="form-group">
                                <label>Email for Tracking *</label>
                                <input type="email" name="email" class="form-input" placeholder="praveena2z029@gmail.com" value="${customer != null ? customer.email : ''}">
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 16px;">
                            <label>Street / Building / Residence Address *</label>
                            <input type="text" name="houseAddress" class="form-input" placeholder="Riverview Boulevard, Danavaipeta">
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
                            <div class="form-group">
                                <label>City *</label>
                                <input type="text" name="city" class="form-input" placeholder="Rajahmundry" value="Rajahmundry">
                            </div>
                            <div class="form-group">
                                <label>State *</label>
                                <input type="text" name="state" class="form-input" placeholder="Andhra Pradesh" value="Andhra Pradesh">
                            </div>
                            <div class="form-group">
                                <label>PIN Code *</label>
                                <input type="text" name="pincode" class="form-input" placeholder="533102" value="533102">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 2: Delivery Option -->
                <div class="checkout-section-box">
                    <div class="checkout-section-header">
                        <div class="checkout-step-number">2</div>
                        <h3>Curated Delivery & Assembly Option</h3>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 12px;">
                        <label class="delivery-option-card active" style="display: flex; align-items: center; justify-content: space-between; padding: 16px; border: 1.5px solid var(--feldgrau); border-radius: 12px; background: var(--bg-card); cursor: pointer;">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <input type="radio" name="deliveryOption" value="Complimentary White-Glove Delivery" checked>
                                <div>
                                    <strong style="color: var(--dark-espresso); display: block; font-size: 0.95rem;">Complimentary White-Glove Delivery</strong>
                                    <small style="color: var(--text-secondary); display: block; font-size: 0.82rem;">Room of choice placement, debris unboxing & packaging removal across India.</small>
                                </div>
                            </div>
                            <span style="font-weight: 700; color: #2e6930; font-size: 0.85rem; letter-spacing: 0.05em;">COMPLIMENTARY</span>
                        </label>

                        <label class="delivery-option-card" style="display: flex; align-items: center; justify-content: space-between; padding: 16px; border: 1px solid var(--border-subtle); border-radius: 12px; background: var(--bg-card); cursor: pointer;">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <input type="radio" name="deliveryOption" value="Specialized Architectural Assembly">
                                <div>
                                    <strong style="color: var(--dark-espresso); display: block; font-size: 0.95rem;">Specialized Architectural Assembly</strong>
                                    <small style="color: var(--text-secondary); display: block; font-size: 0.82rem;">Master joinery team assembly for modular wall units, wardrobes and timber bed frames.</small>
                                </div>
                            </div>
                            <span style="font-weight: 700; color: #2e6930; font-size: 0.85rem; letter-spacing: 0.05em;">INCLUDED</span>
                        </label>
                    </div>
                </div>

                <!-- Step 3: Payment Method -->
                <div class="checkout-section-box">
                    <div class="checkout-section-header">
                        <div class="checkout-step-number">3</div>
                        <h3>Payment Verification</h3>
                    </div>

                    <div class="payment-methods-grid">
                        <label class="payment-method-card active">
                            <div class="payment-method-left">
                                <input type="radio" name="paymentMethod" value="COD" checked onchange="selectPaymentCard(this)">
                                <div>
                                    <strong style="color: var(--dark-espresso); display: block;">Cash / Card on Delivery (White Glove)</strong>
                                    <small style="color: var(--text-muted);">Inspect joinery and finish before making final settlement.</small>
                                </div>
                            </div>
                            <i class="fa-solid fa-hand-holding-dollar" style="font-size: 1.4rem; color: var(--accent-amber);"></i>
                        </label>

                        <label class="payment-method-card">
                            <div class="payment-method-left">
                                <input type="radio" name="paymentMethod" value="UPI" onchange="selectPaymentCard(this)">
                                <div>
                                    <strong style="color: var(--dark-espresso); display: block;">UPI Instant Settlement (GPay / PhonePe / Paytm / QR)</strong>
                                    <small style="color: var(--text-muted); display: block; margin-bottom: 8px;">Zero processing fees. Instant confirmation across all verified Indian UPI apps.</small>
                                    <div class="upi-app-badges" style="display: flex; flex-wrap: wrap; gap: 6px;">
                                        <span style="display: inline-flex; align-items: center; gap: 5px; padding: 3px 8px; background: #ffffff; border: 1px solid #d1d5db; border-radius: 16px; font-size: 0.72rem; font-weight: 600; color: #374151;">
                                            <svg width="13" height="13" viewBox="0 0 24 24"><path fill="#4285F4" d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v4.51h6.6c-.29 1.52-1.14 2.82-2.4 3.68v3.05h3.88c2.27-2.09 3.665-5.17 3.665-9.17z"/><path fill="#34A853" d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.88-3.05c-1.08.72-2.45 1.16-4.05 1.16-3.12 0-5.77-2.1-6.72-4.93H1.25v3.15C3.26 21.36 7.33 24 12 24z"/><path fill="#FBBC05" d="M5.28 14.27c-.25-.72-.38-1.49-.38-2.27s.13-1.55.38-2.27V6.58H1.25C.45 8.18 0 9.99 0 12s.45 3.82 1.25 5.42l4.03-3.15z"/><path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.33 0 3.26 2.64 1.25 6.58l4.03 3.15c.95-2.83 3.6-4.98 6.72-4.98z"/></svg>
                                            Google Pay
                                        </span>
                                        <span style="display: inline-flex; align-items: center; gap: 5px; padding: 3px 8px; background: #ffffff; border: 1px solid #d1d5db; border-radius: 16px; font-size: 0.72rem; font-weight: 600; color: #5f259f;">
                                            <span style="display: inline-flex; align-items: center; justify-content: center; width: 14px; height: 14px; background: #5f259f; color: #fff; border-radius: 50%; font-size: 0.55rem; font-weight: 900;">पे</span>
                                            PhonePe
                                        </span>
                                        <span style="display: inline-flex; align-items: center; gap: 5px; padding: 3px 8px; background: #ffffff; border: 1px solid #d1d5db; border-radius: 16px; font-size: 0.72rem; font-weight: 600; color: #002e6e;">
                                            <span style="display: inline-flex; align-items: center; justify-content: center; width: 14px; height: 14px; background: #00b9f5; color: #002e6e; border-radius: 2px; font-size: 0.55rem; font-weight: 900;">Pay</span>
                                            Paytm
                                        </span>
                                        <span style="display: inline-flex; align-items: center; gap: 5px; padding: 3px 8px; background: #ffffff; border: 1px solid #d1d5db; border-radius: 16px; font-size: 0.72rem; font-weight: 600; color: #16a34a;">
                                            <i class="fa-solid fa-bolt" style="color: #ea580c; font-size: 0.7rem;"></i>
                                            BHIM
                                        </span>
                                        <span style="display: inline-flex; align-items: center; gap: 5px; padding: 3px 8px; background: #ffffff; border: 1px solid #d1d5db; border-radius: 16px; font-size: 0.72rem; font-weight: 600; color: #b45309;">
                                            <i class="fa-brands fa-amazon-pay" style="color: #d97706; font-size: 0.8rem;"></i>
                                            Amazon Pay
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <i class="fa-solid fa-qrcode" style="font-size: 1.4rem; color: var(--accent-amber);"></i>
                        </label>

                        <label class="payment-method-card">
                            <div class="payment-method-left">
                                <input type="radio" name="paymentMethod" value="ONLINE" onchange="selectPaymentCard(this)">
                                <div>
                                    <strong style="color: var(--dark-espresso); display: block;">Credit / Debit Card & Net Banking</strong>
                                    <small style="color: var(--text-muted);">Visa, Mastercard, RuPay & Corporate Net Banking.</small>
                                </div>
                            </div>
                            <i class="fa-regular fa-credit-card" style="font-size: 1.4rem; color: var(--accent-amber);"></i>
                        </label>
                    </div>
                </div>

            </div>

            <!-- Right Summary Column -->
            <div>
                <div class="cart-summary-box">
                    <h3 class="summary-title">Acquisition Review</h3>

                    <% if (cart != null && cart.getItems() != null) {
                        for (CartItem item : cart.getItems()) {
                            Product p = item.getProduct();
                            if (p != null) { %>
                            <div style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 12px; font-size: 0.88rem;">
                                <div>
                                    <span style="font-weight: 600; color: var(--dark-espresso);"><%= p.getProductName() %></span>
                                    <small style="color: var(--text-muted); display: block;">Qty: <%= item.getQuantity() %> &times; &#8377;<%= String.format("%,.0f", p.getDiscountedPrice()) %></small>
                                </div>
                                <span style="font-weight: 700; color: var(--dark-espresso);">&#8377;<%= String.format("%,.0f", item.getSubtotal()) %></span>
                            </div>
                    <%      }
                        }
                    } %>

                    <div style="margin: 20px 0; border-top: 1px solid var(--border-subtle);"></div>

                    <div class="summary-row">
                        <span>Objects Subtotal</span>
                        <strong>&#8377;<%= String.format("%,.0f", subtotal) %></strong>
                    </div>

                    <div class="summary-row">
                        <span>White Glove Transport</span>
                        <span><%= isFreeDelivery ? "FREE" : "&#8377;" + shipping %></span>
                    </div>

                    <div class="summary-row total-row">
                        <span>Total Payable</span>
                        <span>&#8377;<%= String.format("%,.0f", grandTotal) %></span>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 28px; gap: 10px;">
                        <i class="fa-solid fa-lock"></i>
                        <span>Confirm & Place Order</span>
                    </button>

                    <div style="margin-top: 24px; text-align: center; font-size: 0.8rem; color: var(--text-muted);">
                        By confirming, you agree to Gruhu&rsquo;s 30-Day Trial and 10-Year Craftsmanship Warranty terms.
                    </div>
                </div>
            </div>

        </div>
    </form>
</main>

<script>
    function selectAddressCard(radio) {
        document.querySelectorAll('.address-radio-card').forEach(c => c.classList.remove('active'));
        radio.closest('.address-radio-card').classList.add('active');
    }

    function selectPaymentCard(radio) {
        document.querySelectorAll('.payment-method-card').forEach(c => c.classList.remove('active'));
        radio.closest('.payment-method-card').classList.add('active');
    }

    function toggleNewAddressFields(checkbox) {
        const container = document.getElementById('newAddressContainer');
        if (checkbox.checked) {
            container.style.display = 'block';
            container.querySelectorAll('input').forEach(i => i.setAttribute('required', 'required'));
        } else {
            container.style.display = 'none';
            container.querySelectorAll('input').forEach(i => i.removeAttribute('required'));
        }
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
