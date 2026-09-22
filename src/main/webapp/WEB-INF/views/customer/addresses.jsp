<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Address" %>

<%
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
    request.setAttribute("extraCss", "auth.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="account-page">
    <div class="account-header">
        <div>
            <span class="auth-tag">Client Account</span>
            <h1 style="font-family: var(--font-serif); font-size: 2.4rem; color: var(--dark-espresso); margin-top: 4px;">Saved Addresses</h1>
        </div>
        <a href="#newAddressForm" class="btn btn-primary btn-sm">
            <i class="fa-solid fa-plus"></i> Add New Address
        </a>
    </div>

    <!-- Account Navigation Tabs -->
    <div class="account-tabs-nav">
        <a href="${pageContext.request.contextPath}/profile" class="account-tab-item">
            <i class="fa-regular fa-id-card"></i> Personal Profile
        </a>
        <a href="${pageContext.request.contextPath}/addresses" class="account-tab-item active">
            <i class="fa-solid fa-location-dot"></i> Delivery Addresses
        </a>
        <a href="${pageContext.request.contextPath}/my-orders" class="account-tab-item">
            <i class="fa-solid fa-box-archive"></i> Order History
        </a>
        <a href="${pageContext.request.contextPath}/wishlist" class="account-tab-item">
            <i class="fa-regular fa-heart"></i> Saved Wishlist
        </a>
    </div>

    <!-- Addresses Grid -->
    <% if (addresses != null && !addresses.isEmpty()) { %>
        <div class="address-cards-grid">
            <% for (Address addr : addresses) { %>
                <div class="address-card <%= addr.isDefault() ? "default-address" : "" %>">
                    <div class="address-card-header">
                        <span style="font-weight: 700; font-size: 1.05rem; color: var(--dark-espresso);">
                            <%= addr.getReceiverName() %>
                        </span>
                        <div>
                            <span class="badge" style="background: var(--bg-sand-dark); color: var(--dark-espresso);">
                                <%= addr.getAddressType() %>
                            </span>
                            <% if (addr.isDefault()) { %>
                                <span class="badge badge-featured" style="margin-left: 6px;">Default</span>
                            <% } %>
                        </div>
                    </div>

                    <p style="font-size: 0.92rem; color: var(--text-secondary); line-height: 1.6; margin-bottom: 8px;">
                        <%= addr.getHouseAddress() %><br>
                        <%= addr.getCity() %>, <%= addr.getState() %> &ndash; <strong><%= addr.getPincode() %></strong>
                    </p>

                    <span style="font-size: 0.88rem; color: var(--text-muted);">
                        <i class="fa-solid fa-phone" style="margin-right: 6px;"></i> +91 <%= addr.getPhone() %>
                    </span>

                    <div class="address-card-actions">
                        <% if (!addr.isDefault()) { %>
                            <form action="${pageContext.request.contextPath}/addresses" method="post">
                                <input type="hidden" name="action" value="set_default">
                                <input type="hidden" name="addressId" value="<%= addr.getAddressId() %>">
                                <button type="submit" class="btn btn-outline btn-sm">Set as Default</button>
                            </form>
                        <% } %>

                        <form action="${pageContext.request.contextPath}/addresses" method="post" onsubmit="return confirm('Remove this address?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="addressId" value="<%= addr.getAddressId() %>">
                            <button type="submit" class="btn btn-outline btn-sm" style="color: var(--status-danger); border-color: #fca5a5;">
                                <i class="fa-solid fa-trash-can"></i> Delete
                            </button>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div style="text-align: center; padding: 60px 20px; background: #fff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); margin-bottom: 40px;">
            <i class="fa-solid fa-location-dot" style="font-size: 2.5rem; color: var(--border-strong); margin-bottom: 14px;"></i>
            <h3 style="font-family: var(--font-serif); font-size: 1.6rem; margin-bottom: 8px;">No Addresses Saved</h3>
            <p style="color: var(--text-muted);">Add your primary delivery address below for quick, seamless white glove checkouts.</p>
        </div>
    <% } %>

    <!-- Add New Address Section -->
    <div id="newAddressForm" style="background: #ffffff; border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); padding: 36px; max-width: 800px;">
        <h3 style="font-family: var(--font-serif); font-size: 1.6rem; color: var(--dark-espresso); margin-bottom: 24px;">Add New Delivery Address</h3>

        <form action="${pageContext.request.contextPath}/addresses" method="post">
            <input type="hidden" name="action" value="add">

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div class="form-group">
                    <label>Receiver Full Name *</label>
                    <input type="text" name="receiverName" class="form-input" required placeholder="e.g. Maya Iyer">
                </div>
                <div class="form-group">
                    <label>Receiver Contact Phone *</label>
                    <input type="tel" name="phone" class="form-input" required placeholder="10 digits">
                </div>
            </div>

            <div class="form-group">
                <label>Flat / House / Building Address *</label>
                <input type="text" name="houseAddress" class="form-input" required placeholder="e.g. Penthouse 402, Oakwood Residences, 8th Main">
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;">
                <div class="form-group">
                    <label>City *</label>
                    <input type="text" name="city" class="form-input" required placeholder="Bengaluru">
                </div>
                <div class="form-group">
                    <label>State *</label>
                    <input type="text" name="state" class="form-input" required placeholder="Karnataka">
                </div>
                <div class="form-group">
                    <label>PIN Code *</label>
                    <input type="text" name="pincode" class="form-input" required placeholder="560038">
                </div>
            </div>

            <div style="display: flex; gap: 30px; align-items: center; margin: 10px 0 24px;">
                <div>
                    <label style="font-size: 0.85rem; font-weight: 600; margin-right: 12px;">Address Type:</label>
                    <label style="font-size: 0.9rem; margin-right: 14px;"><input type="radio" name="addressType" value="HOME" checked> Home</label>
                    <label style="font-size: 0.9rem;"><input type="radio" name="addressType" value="WORK"> Office</label>
                </div>
                <div>
                    <label style="font-size: 0.9rem; display: flex; align-items: center; gap: 8px; cursor: pointer;">
                        <input type="checkbox" name="isDefault" value="true">
                        <span>Make this my default shipping address</span>
                    </label>
                </div>
            </div>

            <button type="submit" class="btn btn-primary">Save Delivery Address</button>
        </form>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
