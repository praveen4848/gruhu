<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Category" %>
<%@ page import="com.gruhu.model.Subcategory" %>

<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Subcategory> subcategories = (List<Subcategory>) request.getAttribute("subcategories");
    String error = (String) request.getAttribute("errorMessage");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Curate New Architectural Object</h1>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/products" class="btn-admin btn-admin-secondary">
                <i class="fa-solid fa-arrow-left"></i> Back to Catalog
            </a>
        </div>
    </header>

    <main class="admin-content">

        <% if (error != null) { %>
            <div class="admin-alert admin-alert-danger">
                <i class="fa-solid fa-circle-exclamation"></i>
                <span><%= error %></span>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add">

            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">1. Essential Nomenclature & Discipline</h2>
                </div>
                <div class="admin-card-body">
                    <div class="form-group-admin">
                        <label class="form-label-admin">Product Nomenclature / Title *</label>
                        <input type="text" name="productName" class="form-control-admin" required placeholder="e.g., Koto Boucl&eacute; Sculptural Lounge Chair">
                    </div>

                    <div class="form-row-2">
                        <div class="form-group-admin">
                            <label class="form-label-admin">Discipline / Category *</label>
                            <select name="categoryId" class="form-control-admin" required onchange="filterSubcategories(this.value)">
                                <option value="">Select Primary Category</option>
                                <% if (categories != null) {
                                    for (Category c : categories) { %>
                                        <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Sub-Discipline</label>
                            <select name="subcategoryId" id="subcategorySelect" class="form-control-admin">
                                <option value="0">None / General</option>
                                <% if (subcategories != null) {
                                    for (Subcategory s : subcategories) { %>
                                        <option value="<%= s.getSubcategoryId() %>" data-category="<%= s.getCategoryId() %>">
                                            <%= s.getSubcategoryName() %>
                                        </option>
                                <%  }
                                } %>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">2. Value, Acquisition & Studio Stock</h2>
                </div>
                <div class="admin-card-body">
                    <div class="form-row-3">
                        <div class="form-group-admin">
                            <label class="form-label-admin">Base Valuation (&#8377;) *</label>
                            <input type="number" step="0.01" name="price" class="form-control-admin" required placeholder="54900">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Privilege Discount (%)</label>
                            <input type="number" step="0.01" name="discountPercent" class="form-control-admin" value="0" placeholder="0">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Initial Inventory Stock *</label>
                            <input type="number" name="stockQuantity" class="form-control-admin" required value="10" placeholder="10">
                        </div>
                    </div>
                </div>
            </div>

            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">3. Materiality & Craft Specifications</h2>
                </div>
                <div class="admin-card-body">
                    <div class="form-row-2">
                        <div class="form-group-admin">
                            <label class="form-label-admin">Raw Materiality</label>
                            <input type="text" name="material" class="form-control-admin" placeholder="e.g., Solid Nordic Oak, Boucl&eacute; Textile">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Hue & Palette</label>
                            <input type="text" name="color" class="form-control-admin" placeholder="e.g., Oat White & Warm Natural">
                        </div>
                    </div>

                    <div class="form-row-3">
                        <div class="form-group-admin">
                            <label class="form-label-admin">Scale / Format</label>
                            <input type="text" name="size" class="form-control-admin" placeholder="e.g., Single Lounge, Standard">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Architectural Dimensions</label>
                            <input type="text" name="dimensions" class="form-control-admin" placeholder="e.g., 88 x 84 x 76 cm">
                        </div>

                        <div class="form-group-admin">
                            <label class="form-label-admin">Architectural Style</label>
                            <input type="text" name="style" class="form-control-admin" value="Scandinavian Modern" placeholder="Scandinavian Modern">
                        </div>
                    </div>

                    <div class="form-group-admin">
                        <label class="form-label-admin">Craft Atelier / Maker</label>
                        <input type="text" name="brand" class="form-control-admin" value="Gruhu Atelier" placeholder="Gruhu Atelier">
                    </div>

                    <div class="form-group-admin">
                        <label class="form-label-admin">Curator's Descriptive Narrative</label>
                        <textarea name="description" rows="4" class="form-control-admin" placeholder="Detail the timber provenance, ergonomic sculpting, and quiet serenity of the piece..."></textarea>
                    </div>
                </div>
            </div>

            <div class="admin-card">
                <div class="admin-card-header">
                    <h2 class="admin-card-title">4. Visual Portfolio & Exhibition</h2>
                </div>
                <div class="admin-card-body">
                    <div class="form-group-admin" style="margin-bottom: 16px;">
                        <label class="form-label-admin"><i class="fa-solid fa-file-arrow-up"></i> Upload High-Resolution Photograph (JPG / PNG / WebP)</label>
                        <input type="file" name="primaryImageFile" accept="image/jpeg,image/png,image/webp" class="form-control-admin">
                        <small style="color: #8c857b; display: block; margin-top: 4px;">Direct high-resolution photography upload. Automatically saved to Atelier asset storage.</small>
                    </div>

                    <div style="text-align: center; margin: 12px 0; color: #8c857b; font-weight: 600; font-size: 0.8rem; letter-spacing: 0.05em;">&mdash; OR SPECIFY REMOTE ARCHIVE LINK &mdash;</div>

                    <div class="form-group-admin">
                        <label class="form-label-admin">Primary Exhibition Image URL</label>
                        <input type="url" name="primaryImageUrl" class="form-control-admin" placeholder="https://images.unsplash.com/photo-...">
                    </div>

                    <div class="form-group-admin">
                        <label class="form-label-admin">Supplemental Gallery Image URLs (one per line)</label>
                        <textarea name="galleryImageUrls" rows="3" class="form-control-admin" placeholder="https://images.unsplash.com/photo-1&#10;https://images.unsplash.com/photo-2"></textarea>
                    </div>

                    <div class="form-group-admin" style="margin-top: 16px;">
                        <label class="form-label-admin"><i class="fa-solid fa-truck-fast"></i> White-Glove Delivery & Installation Tier</label>
                        <select name="deliveryOption" class="form-control-admin">
                            <option value="Complimentary White-Glove Delivery" selected>Complimentary White-Glove Delivery (Room of choice + Assembly)</option>
                            <option value="Specialized Architectural Assembly">Specialized Architectural Assembly (Master Carpenter Included)</option>
                            <option value="Express Pan-India Air Courier">Express Pan-India Air Courier</option>
                            <option value="Standard Atelier Ground Shipping">Standard Atelier Ground Shipping</option>
                        </select>
                    </div>

                    <div style="display: flex; gap: 32px; align-items: center; margin-top: 20px;">
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-weight: 500;">
                            <input type="checkbox" name="isFeatured" value="true">
                            <span>Feature in Front Atelier Highlights</span>
                        </label>

                        <div style="display: flex; align-items: center; gap: 10px;">
                            <label class="form-label-admin" style="margin: 0;">Publishing State:</label>
                            <select name="status" class="form-control-admin" style="width: 140px;">
                                <option value="ACTIVE">ACTIVE</option>
                                <option value="INACTIVE">INACTIVE</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div style="display: flex; gap: 16px; margin-bottom: 48px;">
                <button type="submit" class="btn-admin btn-admin-primary" style="padding: 12px 28px;">
                    <i class="fa-solid fa-cloud-arrow-up"></i> Publish to Collection
                </button>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn-admin btn-admin-secondary" style="padding: 12px 28px;">
                    Cancel
                </a>
            </div>
        </form>
    </main>
</div>

<script>
    function filterSubcategories(catId) {
        const select = document.getElementById('subcategorySelect');
        const options = select.querySelectorAll('option');
        select.value = "0";
        options.forEach(opt => {
            const optCat = opt.getAttribute('data-category');
            if (!optCat || optCat === catId || !catId) {
                opt.style.display = 'block';
            } else {
                opt.style.display = 'none';
            }
        });
    }
</script>

<%@ include file="/WEB-INF/views/admin/common/admin-footer.jsp" %>
