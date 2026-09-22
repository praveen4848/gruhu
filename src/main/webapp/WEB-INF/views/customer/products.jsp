<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Category" %>
<%@ page import="com.gruhu.model.Subcategory" %>
<%@ page import="com.gruhu.model.Product" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Subcategory> subcategories = (List<Subcategory>) request.getAttribute("subcategories");
    Category activeCategory = (Category) request.getAttribute("activeCategory");
    Integer selectedCatId = (Integer) request.getAttribute("selectedCategoryId");
    Integer selectedSubcatId = (Integer) request.getAttribute("selectedSubcategoryId");
    String selectedRoom = (String) request.getAttribute("selectedRoom");
    String selectedSort = (String) request.getAttribute("selectedSort");
    String minPrice = (String) request.getAttribute("selectedMinPrice");
    String maxPrice = (String) request.getAttribute("selectedMaxPrice");
    String selectedMaterial = (String) request.getAttribute("selectedMaterial");
    request.setAttribute("extraCss", "product.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="catalog-page">

    <!-- Header & Breadcrumb -->
    <div class="catalog-header">
        <div class="catalog-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="${pageContext.request.contextPath}/products">Catalog</a>
            <% if (activeCategory != null) { %>
                <i class="fa-solid fa-chevron-right"></i>
                <a href="${pageContext.request.contextPath}/products?category=<%= activeCategory.getCategoryId() %>"><%= activeCategory.getCategoryName() %></a>
                <% if (selectedSubcatId != null && subcategories != null) {
                    for (Subcategory sub : subcategories) {
                        if (sub.getSubcategoryId() == selectedSubcatId) { %>
                            <i class="fa-solid fa-chevron-right"></i>
                            <span><%= sub.getSubcategoryName() %></span>
                <%          break;
                        }
                    }
                } %>
            <% } else if (selectedRoom != null) { %>
                <i class="fa-solid fa-chevron-right"></i>
                <span><%= selectedRoom.replace("_", " ").toUpperCase() %></span>
            <% } %>
        </div>

        <h1 class="catalog-title">
            <% if (activeCategory != null) { %>
                <%= activeCategory.getCategoryName() %>
            <% } else if ("living_room".equals(selectedRoom)) { %>
                Living Room Collection
            <% } else if ("bedroom".equals(selectedRoom)) { %>
                Bedroom Sanctuary Collection
            <% } else if ("dining_room".equals(selectedRoom)) { %>
                Dining Room Collection
            <% } else if ("hall".equals(selectedRoom)) { %>
                Hall Area (Complete Collection)
            <% } else { %>
                The Complete Atelier Collection
            <% } %>
        </h1>
        <p class="catalog-desc">
            <%= activeCategory != null && activeCategory.getDescription() != null 
                ? activeCategory.getDescription() 
                : "Mindfully designed objects crafted from sustainably harvested hardwood, organic textiles, and honest stone to bring warmth to modern interiors." %>
        </p>
    </div>

    <!-- Top Subcategory Visual Selector Strip (Strictly Horizontal, Category-Isolated) -->
    <div class="subcat-strip-wrapper" style="width: 100%; overflow-x: auto; -webkit-overflow-scrolling: touch; margin-bottom: 28px; padding-bottom: 6px;">
        <div class="subcat-strip-track" style="display: flex !important; flex-direction: row !important; flex-wrap: nowrap !important; align-items: center; gap: 18px; width: max-content; min-width: 100%;">

            <% if (selectedCatId == null || selectedCatId == 0) { %>
                <!-- State 0: ALL PRODUCTS (Shows the 4 primary categories horizontally) -->
                <a href="${pageContext.request.contextPath}/products" class="subcat-strip-tile active" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.08); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=260&h=260&q=80" alt="All Products" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 700 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--feldgrau) !important;">ALL (88)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=1" class="subcat-strip-tile" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=260&h=260&q=80" alt="Furniture" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">FURNITURE</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=2" class="subcat-strip-tile" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=260&h=260&q=80" alt="Lights" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">LIGHTS</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=3" class="subcat-strip-tile" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1618220179428-22790b461013?auto=format&fit=crop&w=260&h=260&q=80" alt="Mirrors" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">MIRRORS</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=4" class="subcat-strip-tile" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1581783342308-f792dbdd27c5?auto=format&fit=crop&w=260&h=260&q=80" alt="Accessories" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">ACCESSORIES</span>
                </a>

            <% } else if (selectedCatId == 1) { %>
                <!-- State 1: FURNITURE (Shows ONLY Furniture Subcategories) -->
                <a href="${pageContext.request.contextPath}/products?category=1" class="subcat-strip-tile <%= selectedSubcatId == null ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=260&h=260&q=80" alt="All Furniture" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">ALL FURNITURE</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=1&subcategory=1" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 1) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=260&h=260&q=80" alt="Sofas" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">SOFAS (8)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=1&subcategory=2" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 2) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=260&h=260&q=80" alt="Chairs" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">CHAIRS (17)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=1&subcategory=3" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 3) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=260&h=260&q=80" alt="Beds" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">BEDS (4)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=1&subcategory=4" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 4) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1530018607912-eff2daa1bac4?auto=format&fit=crop&w=260&h=260&q=80" alt="Tables" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">TABLES (13)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=1&subcategory=5" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 5) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=260&h=260&q=80" alt="Storage" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">STORAGE (9)</span>
                </a>

            <% } else if (selectedCatId == 2) { %>
                <!-- State 2: LIGHTS (Shows ONLY Lights Subcategories) -->
                <a href="${pageContext.request.contextPath}/products?category=2" class="subcat-strip-tile <%= selectedSubcatId == null ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=260&h=260&q=80" alt="All Lights" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">ALL LIGHTS</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=2&subcategory=6" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 6) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=260&h=260&q=80" alt="Floor Lamps" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">FLOOR LAMPS (4)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=2&subcategory=7" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 7) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1513506003901-2e6a229e2d15?auto=format&fit=crop&w=260&h=260&q=80" alt="Table Lamps" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">TABLE LAMPS (5)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=2&subcategory=8" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 8) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1540932239986-30128078f3c5?auto=format&fit=crop&w=260&h=260&q=80" alt="Wall Lamps" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">WALL LAMPS (3)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=2&subcategory=9" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 9) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?auto=format&fit=crop&w=260&h=260&q=80" alt="Ceiling Lamps" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">CEILING LAMPS (2)</span>
                </a>

            <% } else if (selectedCatId == 3) { %>
                <!-- State 3: MIRRORS (Shows ONLY Mirrors Subcategories) -->
                <a href="${pageContext.request.contextPath}/products?category=3" class="subcat-strip-tile <%= selectedSubcatId == null ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1618220179428-22790b461013?auto=format&fit=crop&w=260&h=260&q=80" alt="All Mirrors" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">ALL MIRRORS</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=3&subcategory=10" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 10) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1618220179428-22790b461013?auto=format&fit=crop&w=260&h=260&q=80" alt="Round Mirrors" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">ROUND MIRRORS (2)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=3&subcategory=11" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 11) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1584589167171-541ce45f1eea?auto=format&fit=crop&w=260&h=260&q=80" alt="Rectangle Mirrors" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">RECTANGLE (4)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=3&subcategory=12" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 12) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1616046229478-9901c5536a45?auto=format&fit=crop&w=260&h=260&q=80" alt="Full Length Mirrors" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">FULL LENGTH (5)</span>
                </a>

            <% } else if (selectedCatId == 4) { %>
                <!-- State 4: ACCESSORIES (Shows ONLY Accessories Subcategories) -->
                <a href="${pageContext.request.contextPath}/products?category=4" class="subcat-strip-tile <%= selectedSubcatId == null ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1581783342308-f792dbdd27c5?auto=format&fit=crop&w=260&h=260&q=80" alt="All Accessories" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">ALL ACCESSORIES</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=4&subcategory=13" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 13) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1563861826100-9cb868fdbe1c?auto=format&fit=crop&w=260&h=260&q=80" alt="Wall Clocks" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">WALL CLOCKS (4)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=4&subcategory=14" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 14) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=260&h=260&q=80" alt="Wall Paintings" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">PAINTINGS (3)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=4&subcategory=15" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 15) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1581783342308-f792dbdd27c5?auto=format&fit=crop&w=260&h=260&q=80" alt="Vases" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">VASES (3)</span>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=4&subcategory=16" class="subcat-strip-tile <%= (selectedSubcatId != null && selectedSubcatId == 16) ? "active" : "" %>" style="flex: 0 0 120px !important; width: 120px !important; display: flex !important; flex-direction: column !important; align-items: center !important; text-align: center !important; text-decoration: none !important;">
                    <div class="subcat-strip-thumb" style="width: 84px !important; height: 84px !important; border-radius: 14px !important; overflow: hidden !important; margin-bottom: 8px !important; box-shadow: 0 4px 10px rgba(0,0,0,0.06); background: var(--bg-card);">
                        <img src="https://images.unsplash.com/photo-1602874801007-bd458bb1b8b8?auto=format&fit=crop&w=260&h=260&q=80" alt="Candle Stands" style="width: 100% !important; height: 100% !important; object-fit: cover !important; display: block !important;">
                    </div>
                    <span class="subcat-strip-label" style="font-size: 0.8rem !important; font-weight: 600 !important; letter-spacing: 0.05em !important; text-transform: uppercase !important; color: var(--dark-espresso) !important;">CANDLE STANDS (2)</span>
                </a>
            <% } %>

        </div>
    </div>

    <!-- Quick Filter Bar with Dropdown Box in Left Corner -->
    <div class="catalog-quick-bar">
        <div class="quick-bar-left">
            <%
                int activeFilterCount = (selectedRoom != null ? 1 : 0) + (selectedCatId != null ? 1 : 0) + (selectedSubcatId != null ? 1 : 0) + (minPrice != null ? 1 : 0) + (selectedMaterial != null ? 1 : 0);
            %>
            
            <!-- Filter Dropdown Trigger & Floating Panel in Left Corner -->
            <div class="filter-dropdown-wrapper" style="position: relative; display: inline-block;">
                <button type="button" class="filter-pill-btn <%= activeFilterCount > 0 ? "active" : "" %>" id="btnToggleFilters" aria-haspopup="true" aria-expanded="false">
                    <i class="fa-solid fa-sliders"></i>
                    <span>Filter (<%= activeFilterCount %>)</span>
                    <i class="fa-solid fa-chevron-down caret-icon" style="font-size: 0.72rem; margin-left: 6px;"></i>
                </button>

                <!-- Floating Dropdown Box in Left Corner -->
                <div class="filter-dropdown-menu" id="filterDropdownMenu" style="display: none;">
                    <div class="filter-dropdown-header">
                        <span class="dropdown-heading"><i class="fa-solid fa-sliders"></i> Filter Catalog</span>
                        <a href="${pageContext.request.contextPath}/products" class="dropdown-reset-link">Reset</a>
                    </div>

                    <form action="${pageContext.request.contextPath}/products" method="get" id="filterDropdownForm">
                        <% if (selectedCatId != null) { %><input type="hidden" name="category" value="<%= selectedCatId %>"><% } %>
                        <% if (selectedSubcatId != null) { %><input type="hidden" name="subcategory" value="<%= selectedSubcatId %>"><% } %>
                        <% if (selectedSort != null) { %><input type="hidden" name="sort" value="<%= selectedSort %>"><% } %>

                        <!-- Space / Room -->
                        <div class="dropdown-section">
                            <label class="dropdown-section-title">Room & Space</label>
                            <select name="room" class="dropdown-select">
                                <option value="" <%= selectedRoom == null ? "selected" : "" %>>All Spaces (Living, Bed, Dining, Hall)</option>
                                <option value="living_room" <%= "living_room".equals(selectedRoom) ? "selected" : "" %>>Living Room</option>
                                <option value="bedroom" <%= "bedroom".equals(selectedRoom) ? "selected" : "" %>>Bedroom</option>
                                <option value="dining_room" <%= "dining_room".equals(selectedRoom) ? "selected" : "" %>>Dining Room</option>
                                <option value="hall" <%= "hall".equals(selectedRoom) ? "selected" : "" %>>Hall Area</option>
                            </select>
                        </div>

                        <!-- Price Range -->
                        <div class="dropdown-section">
                            <label class="dropdown-section-title">Price Range (₹)</label>
                            <div class="dropdown-range-row">
                                <input type="number" name="minPrice" placeholder="Min ₹" value="<%= minPrice != null ? minPrice : "" %>" class="dropdown-number-input">
                                <span class="range-sep">&ndash;</span>
                                <input type="number" name="maxPrice" placeholder="Max ₹" value="<%= maxPrice != null ? maxPrice : "" %>" class="dropdown-number-input">
                            </div>
                        </div>

                        <!-- Material -->
                        <div class="dropdown-section">
                            <label class="dropdown-section-title">Material</label>
                            <select name="material" class="dropdown-select">
                                <option value="">All Materials</option>
                                <option value="Oak" <%= "Oak".equalsIgnoreCase(selectedMaterial) ? "selected" : "" %>>Solid Oak</option>
                                <option value="Boucle" <%= "Boucle".equalsIgnoreCase(selectedMaterial) ? "selected" : "" %>>Boucle</option>
                                <option value="Leather" <%= "Leather".equalsIgnoreCase(selectedMaterial) ? "selected" : "" %>>Top Grain Leather</option>
                                <option value="Linen" <%= "Linen".equalsIgnoreCase(selectedMaterial) ? "selected" : "" %>>Organic Flax Linen</option>
                                <option value="Brass" <%= "Brass".equalsIgnoreCase(selectedMaterial) ? "selected" : "" %>>Brushed Brass</option>
                                <option value="Ceramic" <%= "Ceramic".equalsIgnoreCase(selectedMaterial) ? "selected" : "" %>>Ceramic & Stone</option>
                            </select>
                        </div>

                        <div class="dropdown-action-row">
                            <button type="submit" class="btn-dropdown-apply">Apply Filters</button>
                            <button type="button" class="btn-dropdown-close" id="btnCloseFilterDropdown">Close</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Spaces Quick Pill -->
            <div class="quick-select-pill-wrap">
                <select onchange="location = this.value;" class="quick-select-pill">
                    <option value="${pageContext.request.contextPath}/products" <%= selectedRoom == null ? "selected" : "" %>>All Spaces</option>
                    <option value="${pageContext.request.contextPath}/products?room=living_room" <%= "living_room".equals(selectedRoom) ? "selected" : "" %>>Living Room</option>
                    <option value="${pageContext.request.contextPath}/products?room=bedroom" <%= "bedroom".equals(selectedRoom) ? "selected" : "" %>>Bedroom</option>
                    <option value="${pageContext.request.contextPath}/products?room=dining_room" <%= "dining_room".equals(selectedRoom) ? "selected" : "" %>>Dining Room</option>
                    <option value="${pageContext.request.contextPath}/products?room=hall" <%= "hall".equals(selectedRoom) ? "selected" : "" %>>Hall Area</option>
                </select>
            </div>

            <!-- Categories Quick Pill -->
            <div class="quick-select-pill-wrap">
                <select onchange="location = this.value;" class="quick-select-pill">
                    <option value="${pageContext.request.contextPath}/products" <%= selectedCatId == null ? "selected" : "" %>>All Categories</option>
                    <% if (categories != null) {
                        for (Category c : categories) { %>
                        <option value="${pageContext.request.contextPath}/products?category=<%= c.getCategoryId() %>" 
                                <%= (selectedCatId != null && selectedCatId == c.getCategoryId()) ? "selected" : "" %>>
                            <%= c.getCategoryName() %> (<%= c.getProductCount() %>)
                        </option>
                    <%  }
                       } %>
                </select>
            </div>

            <% if (activeFilterCount > 0) { %>
                <a href="${pageContext.request.contextPath}/products" class="quick-reset-link">
                    <i class="fa-solid fa-xmark"></i> Reset
                </a>
            <% } %>
        </div>

        <div class="quick-bar-right">
            <span class="quick-count-text">Showing <strong><%= products != null ? products.size() : 0 %></strong> interior objects</span>
            <div class="quick-select-pill-wrap">
                <%
                    String roomQ = (selectedRoom != null ? "room=" + selectedRoom + "&" : "");
                    String catQ = (selectedCatId != null ? "category=" + selectedCatId + "&" : "");
                    String subcatQ = (selectedSubcatId != null ? "subcategory=" + selectedSubcatId + "&" : "");
                    String sortBase = request.getContextPath() + "/products?" + roomQ + catQ + subcatQ;
                %>
                <select id="catalogSortSelect" onchange="location = this.value;" class="quick-select-pill">
                    <option value="<%= sortBase %>sort=featured" <%= "featured".equals(selectedSort) || selectedSort == null ? "selected" : "" %>>Sort: Featured</option>
                    <option value="<%= sortBase %>sort=price_asc" <%= "price_asc".equals(selectedSort) ? "selected" : "" %>>Price: Low to High</option>
                    <option value="<%= sortBase %>sort=price_desc" <%= "price_desc".equals(selectedSort) ? "selected" : "" %>>Price: High to Low</option>
                    <option value="<%= sortBase %>sort=rating" <%= "rating".equals(selectedSort) ? "selected" : "" %>>Top Rated</option>
                    <option value="<%= sortBase %>sort=newest" <%= "newest".equals(selectedSort) ? "selected" : "" %>>Newest Editions</option>
                </select>
            </div>
        </div>
    </div>

    <!-- Product Cards Grid: Exactly 3 Cards in a Row (Image 2 Reference) -->
    <div class="catalog-products-container" style="width: 100%; margin-top: 10px;">
        <% if (products != null && !products.isEmpty()) { %>
            <div class="product-grid-v2">
                <% for (Product p : products) { %>
                    <div class="product-card-v2">
                        <!-- Full Image with Rounded Corners (Image 2) -->
                        <div class="card-v2-image-wrap">
                            <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>" class="card-v2-img-link">
                                <img src="<%= p.getPrimaryImageUrl() != null ? p.getPrimaryImageUrl() : "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80" %>" 
                                     alt="<%= p.getProductName() %>" class="card-v2-img" loading="lazy">
                            </a>

                            <div class="card-v2-badges">
                                <% if (p.hasDiscount()) { %>
                                    <span class="badge-v2 badge-discount">-<%= p.getDiscountPercent().intValue() %>%</span>
                                <% } %>
                                <% if (p.isFeatured()) { %>
                                    <span class="badge-v2 badge-featured">Atelier</span>
                                <% } %>
                            </div>

                            <form action="${pageContext.request.contextPath}/wishlist" method="post" class="card-v2-wishlist-form">
                                <input type="hidden" name="action" value="toggle">
                                <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                <button type="submit" class="btn-card-v2-wishlist" title="Save to Wishlist">
                                    <i class="fa-regular fa-heart"></i>
                                </button>
                            </form>
                        </div>

                        <!-- Card Info Directly Below Image (Image 2 Layout) -->
                        <div class="card-v2-info">
                            <div class="card-v2-title-row">
                                <h3 class="card-v2-title">
                                    <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>">
                                        <%= p.getProductName() %>
                                    </a>
                                </h3>
                                <div class="card-v2-price">
                                    <span class="price-val">&#8377;<%= String.format("%,.0f", p.getDiscountedPrice()) %></span>
                                    <% if (p.hasDiscount()) { %>
                                        <span class="price-val-orig">&#8377;<%= String.format("%,.0f", p.getPrice()) %></span>
                                    <% } %>
                                </div>
                            </div>

                            <div class="card-v2-meta-row">
                                <div class="card-v2-swatches">
                                    <span class="swatch-dot dot-terracotta"></span>
                                    <span class="swatch-dot dot-slate"></span>
                                    <span class="swatch-label">2 Colors</span>
                                </div>
                                <span class="card-v2-material-tag"><%= p.getMaterial() != null ? p.getMaterial() : "Solid Wood" %></span>
                            </div>

                            <div class="card-v2-actions">
                                <form action="${pageContext.request.contextPath}/cart" method="post" class="card-v2-add-form">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn-card-v2-add" <%= !p.isInStock() ? "disabled" : "" %>>
                                        <i class="fa-solid fa-bag-shopping"></i>
                                        <span><%= p.isInStock() ? "Add to Bag" : "Sold Out" %></span>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div style="text-align: center; padding: 80px 20px; background: var(--bg-card); border: 1px solid var(--border-subtle); border-radius: 16px;">
                <i class="fa-solid fa-magnifying-glass" style="font-size: 3rem; color: var(--border-strong); margin-bottom: 20px;"></i>
                <h3 style="font-family: var(--font-serif); font-size: 1.8rem; margin-bottom: 12px; color: var(--dark-espresso);">No Objects Match Your Criteria</h3>
                <p style="color: var(--text-muted); margin-bottom: 24px;">Try adjusting your price range or exploring another category.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Reset All Filters</a>
            </div>
        <% } %>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
