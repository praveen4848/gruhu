<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gruhu.model.Customer" %>

<%
    Customer currentCustomer = (Customer) session.getAttribute("customer");
    if (currentCustomer == null) {
        com.gruhu.model.Admin adminObj = (com.gruhu.model.Admin) session.getAttribute("admin");
        if (adminObj == null) {
            adminObj = (com.gruhu.model.Admin) session.getAttribute("adminUser");
        }
        if (adminObj != null && adminObj.getEmail() != null) {
            com.gruhu.service.CustomerService cs = new com.gruhu.service.CustomerService();
            currentCustomer = cs.getCustomerByEmail(adminObj.getEmail());
            if (currentCustomer != null) {
                session.setAttribute("customer", currentCustomer);
            }
        }
    }
    Integer cartCount = (Integer) session.getAttribute("cartCount");
    if (cartCount == null) cartCount = 0;
    Integer wishlistCount = (Integer) session.getAttribute("wishlistCount");
    if (wishlistCount == null) wishlistCount = 0;
%>

<header class="main-header skanvi-header">
    <!-- Top Row: Logo, Search, User Utilities -->
    <div class="header-top-row">
        <div class="header-inner">
            <!-- Brand Logo (Skanvi style clean wordmark with 3D Architectural Monogram) -->
            <div class="brand-logo">
                <a href="${pageContext.request.contextPath}/home" class="logo-skanvi" aria-label="Gruhu Atelier Home">
                    <img src="${pageContext.request.contextPath}/assets/images/gruhu-logo-circle.png" 
                         alt="Gruhu Architectural Monogram" 
                         class="brand-logo-img">
                    <span class="brand-name-text">Gruhu</span>
                </a>
            </div>

            <!-- Centered Pill Search Input -->
            <form action="${pageContext.request.contextPath}/search" method="get" class="skanvi-search-form">
                <i class="fa-solid fa-magnifying-glass search-icon"></i>
                <input type="text" name="keyword" placeholder="Search" 
                       value="${param.keyword != null ? param.keyword : ''}" required>
            </form>

            <!-- User Utilities & Actions -->
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/wishlist" class="skanvi-icon-link" title="Wishlist">
                    <i class="fa-regular fa-heart"></i>
                    <span class="badge-count" id="wishlistCountBadge"><%= wishlistCount %></span>
                </a>

                <a href="${pageContext.request.contextPath}/cart" class="skanvi-icon-link cart-link" title="Bag">
                    <i class="fa-solid fa-bag-shopping"></i>
                    <span class="badge-count" id="cartCountBadge"><%= cartCount %></span>
                </a>

                <% if (session.getAttribute("admin") != null) { %>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="skanvi-btn-auth" style="background: var(--feldgrau); color: #ffffff !important; border-color: var(--feldgrau); margin-right: 6px;" title="Curator Dashboard">
                        <i class="fa-solid fa-gauge-high"></i> <span>Dashboard</span>
                    </a>
                <% } %>

                <div class="user-dropdown">
                    <% if (currentCustomer != null) { %>
                        <button class="skanvi-user-btn logged-in" id="userMenuBtn" type="button" aria-haspopup="true">
                            <i class="fa-regular fa-circle-user"></i>
                            <span><%= (currentCustomer.getFullName() != null && !currentCustomer.getFullName().trim().isEmpty()) ? currentCustomer.getFullName().split("\\s+")[0] : "Account" %></span>
                            <i class="fa-solid fa-chevron-down caret-icon"></i>
                        </button>
                        <div class="dropdown-menu">
                            <div class="dropdown-header">
                                <strong><%= currentCustomer.getFullName() %></strong>
                                <small><%= currentCustomer.getEmail() %></small>
                            </div>
                            <a href="${pageContext.request.contextPath}/profile"><i class="fa-regular fa-id-card"></i> My Profile</a>
                            <a href="${pageContext.request.contextPath}/my-orders"><i class="fa-solid fa-box-archive"></i> My Orders</a>
                            <a href="${pageContext.request.contextPath}/addresses"><i class="fa-solid fa-location-dot"></i> Saved Addresses</a>
                            <a href="${pageContext.request.contextPath}/wishlist"><i class="fa-regular fa-heart"></i> My Wishlist</a>
                            <% if (session.getAttribute("admin") != null || "praveena2z029@gmail.com".equalsIgnoreCase(currentCustomer.getEmail())) { %>
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: var(--feldgrau); font-weight: 600;"><i class="fa-solid fa-gauge-high"></i> Curator Console</a>
                            <% } %>
                            <div class="dropdown-divider"></div>
                            <a href="${pageContext.request.contextPath}/logout" class="logout-link"><i class="fa-solid fa-arrow-right-from-bracket"></i> Sign Out</a>
                        </div>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/login" class="skanvi-btn-auth"><i class="fa-regular fa-circle-user" style="margin-right: 6px;"></i> Sign In</a>
                    <% } %>
                </div>

                <button class="mobile-toggle-btn" id="mobileToggleBtn" aria-label="Toggle Navigation">
                    <i class="fa-solid fa-bars"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Secondary Nav Row with Line Icons (Screenshots 1 & 3) -->
    <div class="header-nav-row">
        <div class="header-inner">
            <nav class="skanvi-nav-menu">
                <button type="button" class="skanvi-nav-link mega-trigger-btn" id="btnMegaToggle" aria-expanded="false">
                    <i class="fa-solid fa-shapes"></i>
                    <span>PRODUCTS</span>
                    <i class="fa-solid fa-chevron-down nav-chevron"></i>
                </button>

                <!-- ROOMS Dropdown Menu (Living Room, Bedroom, Dining Room, Hall Area) -->
                <div class="rooms-nav-item" id="roomsNavItem">
                    <button type="button" class="skanvi-nav-link rooms-trigger-btn" id="btnRoomsToggle" aria-expanded="false">
                        <i class="fa-solid fa-door-open"></i>
                        <span>ROOMS</span>
                        <i class="fa-solid fa-chevron-down nav-chevron"></i>
                    </button>
                    <div class="rooms-dropdown-menu" id="roomsDropdownMenu" style="display: none;">
                        <a href="${pageContext.request.contextPath}/products?room=living_room" class="room-dropdown-item">
                            <div class="room-item-header">
                                <i class="fa-solid fa-couch"></i>
                                <span>Living Room</span>
                            </div>
                            <span class="room-item-desc">Sofas, Tables, Storage, Accessories, Chairs</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/products?room=bedroom" class="room-dropdown-item">
                            <div class="room-item-header">
                                <i class="fa-solid fa-bed"></i>
                                <span>Bedroom</span>
                            </div>
                            <span class="room-item-desc">Beds, Accessories, Storage, Mirrors</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/products?room=dining_room" class="room-dropdown-item">
                            <div class="room-item-header">
                                <i class="fa-solid fa-utensils"></i>
                                <span>Dining Room</span>
                            </div>
                            <span class="room-item-desc">Tables, Chairs, Accessories, Storage</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/products?room=hall" class="room-dropdown-item">
                            <div class="room-item-header">
                                <i class="fa-solid fa-hotel"></i>
                                <span>Hall Area</span>
                            </div>
                            <span class="room-item-desc">All Things — Complete Curated Collection</span>
                        </a>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/products?sort=newest" class="skanvi-nav-link">
                    <i class="fa-solid fa-sparkles"></i>
                    <span>NEW</span>
                </a>
            </nav>
        </div>
    </div>

    <!-- Skanvi Full-Width Mega-Menu Dropdown Overlay -->
    <div class="skanvi-mega-menu" id="skanviMegaMenu" style="display: none;">
        <div class="mega-menu-container">
            <!-- Column 1: PRODUCTS (Only Furniture, Lights, Mirrors, Accessories - NO Carpets) -->
            <div class="mega-col mega-col-products">
                <span class="mega-col-heading">PRODUCTS</span>
                <ul class="mega-nav-list" id="megaCatList">
                    <li class="active" data-cat="furniture">
                        <a href="${pageContext.request.contextPath}/products?category=1">
                            <span class="mega-item-left"><i class="fa-solid fa-couch"></i> Furniture</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                    <li data-cat="lights">
                        <a href="${pageContext.request.contextPath}/products?category=2">
                            <span class="mega-item-left"><i class="fa-solid fa-lightbulb"></i> Lights</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                    <li data-cat="mirrors">
                        <a href="${pageContext.request.contextPath}/products?category=3">
                            <span class="mega-item-left"><i class="fa-regular fa-gem"></i> Mirrors</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                    <li data-cat="accessories">
                        <a href="${pageContext.request.contextPath}/products?category=4">
                            <span class="mega-item-left"><i class="fa-solid fa-sparkles"></i> Accessories</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Column 2: SUB-COLLECTION (Dynamic based on Category Hover) -->
            <div class="mega-col mega-col-subcat">
                <span class="mega-col-heading" id="megaSubcatHeading">FURNITURE</span>
                <ul class="mega-nav-list" id="megaSubcatList">
                    <li class="active" data-sub="sofas">
                        <a href="${pageContext.request.contextPath}/products?category=1&subcategory=1">
                            <span class="mega-item-left"><i class="fa-solid fa-couch"></i> Sofas</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                    <li data-sub="chairs">
                        <a href="${pageContext.request.contextPath}/products?category=1&subcategory=2">
                            <span class="mega-item-left"><i class="fa-solid fa-chair"></i> Chairs</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                    <li data-sub="beds">
                        <a href="${pageContext.request.contextPath}/products?category=1&subcategory=3">
                            <span class="mega-item-left"><i class="fa-solid fa-bed"></i> Beds</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                    <li data-sub="tables">
                        <a href="${pageContext.request.contextPath}/products?category=1&subcategory=4">
                            <span class="mega-item-left"><i class="fa-solid fa-table"></i> Tables</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                    <li data-sub="storage">
                        <a href="${pageContext.request.contextPath}/products?category=1&subcategory=5">
                            <span class="mega-item-left"><i class="fa-solid fa-box-archive"></i> Storage</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Column 3: SUB-MODELS SPECIFICATION (Only for the active/hovered subcategory) -->
            <div class="mega-col mega-col-accessoires">
                <span class="mega-col-heading" id="megaModelsHeading">SOFAS & SEATING</span>
                <ul class="mega-nav-list" id="megaModelsList">
                    <li>
                        <a href="${pageContext.request.contextPath}/products?category=1&subcategory=1">
                            <span class="mega-item-left"><i class="fa-solid fa-couch"></i> Two-Seater Sofa (3 items)</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/products?category=1&subcategory=1">
                            <span class="mega-item-left"><i class="fa-solid fa-couch"></i> Three-Seater Sofa (2 items)</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/products?category=1&subcategory=1">
                            <span class="mega-item-left"><i class="fa-solid fa-couch"></i> 4-Seater Sectional Sofa (3 items)</span>
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Column 4: CURATED ROOMS QUICK ACCESS -->
            <div class="mega-col mega-col-rooms">
                <span class="mega-col-heading">ROOM COLLECTIONS</span>
                <ul class="mega-nav-list">
                    <li>
                        <a href="${pageContext.request.contextPath}/products?room=living_room">
                            <span class="mega-item-left"><i class="fa-solid fa-couch"></i> Living Room</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/products?room=bedroom">
                            <span class="mega-item-left"><i class="fa-solid fa-bed"></i> Bedroom</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/products?room=dining_room">
                            <span class="mega-item-left"><i class="fa-solid fa-utensils"></i> Dining Room</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/products?room=hall">
                            <span class="mega-item-left"><i class="fa-solid fa-hotel"></i> Hall Area (All 88)</span>
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Quick Close Button -->
            <button type="button" class="btn-close-mega" id="btnCloseMega" aria-label="Close Mega Menu">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
    </div>
</header>