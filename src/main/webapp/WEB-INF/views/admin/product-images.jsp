<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gruhu.model.Product" %>
<%@ page import="com.gruhu.model.ProductImage" %>

<%
    Product product = (Product) request.getAttribute("product");
    List<ProductImage> images = (product != null) ? product.getImages() : null;
    String success = request.getParameter("success");
%>

<%@ include file="/WEB-INF/views/admin/common/admin-header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/admin-sidebar.jsp" %>

<div class="admin-main">
    <header class="admin-topbar">
        <div class="topbar-left">
            <h1 class="topbar-page-title">Visual Portfolio: <%= product != null ? product.getProductName() : "Product" %></h1>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/admin/products" class="btn-admin btn-admin-secondary">
                <i class="fa-solid fa-arrow-left"></i> Back to Products
            </a>
        </div>
    </header>

    <main class="admin-content">

        <% if ("imageAdded".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>New photo added to exhibition gallery.</span>
            </div>
        <% } else if ("imageDeleted".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Image removed from the collection.</span>
            </div>
        <% } else if ("primarySet".equals(success)) { %>
            <div class="admin-alert admin-alert-success">
                <i class="fa-solid fa-check"></i>
                <span>Primary exhibition hero image updated.</span>
            </div>
        <% } %>

        <!-- Add Image Form -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h2 class="admin-card-title">Add Photo to Gallery</h2>
            </div>
            <div class="admin-card-body">
                <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data" style="display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
                    <input type="hidden" name="action" value="addImage">
                    <input type="hidden" name="productId" value="<%= product != null ? product.getProductId() : 0 %>">

                    <div style="flex: 1; min-width: 250px;">
                        <label class="form-label-admin">Upload Photo File (JPG / PNG)</label>
                        <input type="file" name="imageFile" accept="image/jpeg,image/png,image/webp" class="form-control-admin">
                    </div>

                    <div style="flex: 1; min-width: 250px;">
                        <label class="form-label-admin">Or Direct Image URL</label>
                        <input type="url" name="imageUrl" class="form-control-admin" placeholder="https://images.unsplash.com/photo-...">
                    </div>

                    <div style="margin-bottom: 10px;">
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.88rem;">
                            <input type="checkbox" name="isPrimary" value="true">
                            <span>Set as Primary Hero</span>
                        </label>
                    </div>

                    <div>
                        <button type="submit" class="btn-admin btn-admin-primary">
                            <i class="fa-solid fa-plus"></i> Add to Portfolio
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Existing Gallery Grid -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h2 class="admin-card-title">Current Photographic Portfolio (<%= images != null ? images.size() : 0 %>)</h2>
            </div>
            <div class="admin-card-body">
                <% if (images != null && !images.isEmpty()) { %>
                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px;">
                        <% for (ProductImage img : images) { %>
                            <div style="border: 1px solid var(--admin-border); border-radius: var(--admin-radius); overflow: hidden; position: relative; background: #faf8f5;">
                                <img src="<%= img.getImagePath() %>" alt="Product Angle" 
                                     style="width: 100%; height: 180px; object-fit: cover; display: block;">

                                <% if (img.isPrimary()) { %>
                                    <span class="admin-badge badge-active" style="position: absolute; top: 10px; left: 10px;">
                                        <i class="fa-solid fa-star"></i> Primary Hero
                                    </span>
                                <% } %>

                                <div style="padding: 12px; display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--admin-border); background: #ffffff;">
                                    <% if (!img.isPrimary()) { %>
                                        <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="setPrimaryImage">
                                            <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                            <input type="hidden" name="imageId" value="<%= img.getImageId() %>">
                                            <button type="submit" class="btn-admin btn-admin-secondary btn-admin-sm" title="Set as main thumbnail">
                                                Make Hero
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <span style="font-size: 0.75rem; color: var(--admin-text-muted); font-weight: 500;">Default</span>
                                    <% } %>

                                    <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display: inline;"
                                          onsubmit="return confirm('Delete this image permanently?');">
                                        <input type="hidden" name="action" value="deleteImage">
                                        <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                        <input type="hidden" name="imageId" value="<%= img.getImageId() %>">
                                        <button type="submit" class="btn-admin btn-admin-danger btn-admin-sm" title="Delete image">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div style="text-align: center; color: var(--admin-text-muted); padding: 48px;">
                        No images uploaded for this piece yet. Add a photograph above.
                    </div>
                <% } %>
            </div>
        </div>

    </main>
</div>

<%@ include file="/WEB-INF/views/admin/common/admin-footer.jsp" %>
