package com.gruhu.dao;

import com.gruhu.model.Product;
import com.gruhu.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private final ProductImageDAO imageDAO = new ProductImageDAO();

    private static final String BASE_SELECT =
            "SELECT p.*, c.category_name, s.subcategory_name, " +
            "(SELECT image_path FROM product_images pi WHERE pi.product_id = p.product_id ORDER BY pi.is_primary DESC, pi.image_id ASC LIMIT 1) AS primary_img " +
            "FROM products p " +
            "LEFT JOIN categories c ON p.category_id = c.category_id " +
            "LEFT JOIN subcategories s ON p.subcategory_id = s.subcategory_id ";

    public List<Product> getAllActiveProducts(String sortBy) {
        String sql = BASE_SELECT + " WHERE p.status = 'ACTIVE' " + buildOrderBy(sortBy);
        return executeQueryList(sql);
    }

    public List<Product> getFeaturedProducts(int limit) {
        String sql = BASE_SELECT + " WHERE p.status = 'ACTIVE' AND p.is_featured = TRUE ORDER BY p.category_id ASC, p.rating DESC, p.product_id ASC LIMIT " + limit;
        return executeQueryList(sql);
    }

    public List<Product> getProductsByCategory(int categoryId, String sortBy) {
        String sql = BASE_SELECT + " WHERE p.status = 'ACTIVE' AND p.category_id = ? " + buildOrderBy(sortBy);
        return executeQueryListWithInt(sql, categoryId);
    }

    public List<Product> getProductsBySubcategory(int subcategoryId, String sortBy) {
        String sql = BASE_SELECT + " WHERE p.status = 'ACTIVE' AND p.subcategory_id = ? " + buildOrderBy(sortBy);
        return executeQueryListWithInt(sql, subcategoryId);
    }

    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllActiveProducts("featured");
        }

        String raw = keyword.trim();
        String singular = raw.toLowerCase();
        if (singular.endsWith("s") && singular.length() > 3) {
            singular = singular.substring(0, singular.length() - 1);
        }

        String sql = BASE_SELECT + " WHERE p.status = 'ACTIVE' AND (" +
                     "p.product_name LIKE ? OR p.description LIKE ? OR p.material LIKE ? OR " +
                     "p.brand LIKE ? OR p.color LIKE ? OR p.style LIKE ? OR p.rooms LIKE ? OR " +
                     "c.category_name LIKE ? OR s.subcategory_name LIKE ? OR " +
                     "p.product_name LIKE ? OR c.category_name LIKE ? OR s.subcategory_name LIKE ?) " +
                     "ORDER BY p.is_featured DESC, p.rating DESC";

        List<Product> list = new ArrayList<>();
        String searchParam1 = "%" + raw + "%";
        String searchParam2 = "%" + singular + "%";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, searchParam1);
            ps.setString(2, searchParam1);
            ps.setString(3, searchParam1);
            ps.setString(4, searchParam1);
            ps.setString(5, searchParam1);
            ps.setString(6, searchParam1);
            ps.setString(7, searchParam1);
            ps.setString(8, searchParam1);
            ps.setString(9, searchParam1);
            ps.setString(10, searchParam2);
            ps.setString(11, searchParam2);
            ps.setString(12, searchParam2);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = mapResultSetToProduct(rs);
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsByRoom(String room, String sortBy) {
        if (room == null || room.trim().isEmpty() || "all".equalsIgnoreCase(room) || "hall".equalsIgnoreCase(room)) {
            return getAllActiveProducts(sortBy);
        }
        String sql = BASE_SELECT + " WHERE p.status = 'ACTIVE' AND p.rooms LIKE ? " + buildOrderBy(sortBy);
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + room.trim().toLowerCase() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> filterProducts(Integer categoryId, Integer subcategoryId,
                                        BigDecimal minPrice, BigDecimal maxPrice,
                                        String material, String color, String sortBy) {
        return filterProducts(categoryId, subcategoryId, minPrice, maxPrice, material, color, null, sortBy);
    }

    public List<Product> filterProducts(Integer categoryId, Integer subcategoryId,
                                        BigDecimal minPrice, BigDecimal maxPrice,
                                        String material, String color, String room, String sortBy) {

        StringBuilder sql = new StringBuilder(BASE_SELECT).append(" WHERE p.status = 'ACTIVE' ");
        List<Object> params = new ArrayList<>();

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id = ? ");
            params.add(categoryId);
        }

        if (subcategoryId != null && subcategoryId > 0) {
            sql.append(" AND p.subcategory_id = ? ");
            params.add(subcategoryId);
        }

        if (minPrice != null && minPrice.compareTo(BigDecimal.ZERO) >= 0) {
            sql.append(" AND p.price >= ? ");
            params.add(minPrice);
        }

        if (maxPrice != null && maxPrice.compareTo(BigDecimal.ZERO) > 0) {
            sql.append(" AND p.price <= ? ");
            params.add(maxPrice);
        }

        if (material != null && !material.trim().isEmpty()) {
            sql.append(" AND p.material LIKE ? ");
            params.add("%" + material.trim() + "%");
        }

        if (color != null && !color.trim().isEmpty()) {
            sql.append(" AND p.color LIKE ? ");
            params.add("%" + color.trim() + "%");
        }

        if (room != null && !room.trim().isEmpty() && !"all".equalsIgnoreCase(room) && !"hall".equalsIgnoreCase(room)) {
            sql.append(" AND p.rooms LIKE ? ");
            params.add("%" + room.trim().toLowerCase() + "%");
        }

        sql.append(buildOrderBy(sortBy));

        List<Product> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int productId) {
        String sql = BASE_SELECT + " WHERE p.product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    product.setImages(imageDAO.getImagesByProductId(productId));
                    return product;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> getRelatedProducts(int categoryId, int excludeProductId, int limit) {
        String sql = BASE_SELECT + " WHERE p.status = 'ACTIVE' AND p.category_id = ? AND p.product_id != ? ORDER BY p.rating DESC, p.product_id DESC LIMIT " + limit;
        List<Product> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ps.setInt(2, excludeProductId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getAllProductsForAdmin() {
        String sql = BASE_SELECT + " ORDER BY p.product_id DESC";
        return executeQueryList(sql);
    }

    public List<Product> getLowStockProducts(int threshold) {
        String sql = BASE_SELECT + " WHERE p.stock_quantity <= ? AND p.status = 'ACTIVE' ORDER BY p.stock_quantity ASC";
        return executeQueryListWithInt(sql, threshold);
    }

    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (category_id, subcategory_id, product_name, description, price, " +
                     "discount_percent, stock_quantity, material, color, size, dimensions, style, brand, " +
                     "rating, is_featured, status, rooms, delivery_option, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, product.getCategoryId());
            if (product.getSubcategoryId() != null && product.getSubcategoryId() > 0) {
                ps.setInt(2, product.getSubcategoryId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, product.getProductName());
            ps.setString(4, product.getDescription());
            ps.setBigDecimal(5, product.getPrice());
            ps.setBigDecimal(6, product.getDiscountPercent());
            ps.setInt(7, product.getStockQuantity());
            ps.setString(8, product.getMaterial());
            ps.setString(9, product.getColor());
            ps.setString(10, product.getSize());
            ps.setString(11, product.getDimensions());
            ps.setString(12, product.getStyle());
            ps.setString(13, product.getBrand());
            ps.setBigDecimal(14, product.getRating());
            ps.setBoolean(15, product.isFeatured());
            ps.setString(16, product.getStatus() != null ? product.getStatus() : "ACTIVE");
            ps.setString(17, product.getRooms() != null ? product.getRooms() : "living_room,hall");
            ps.setString(18, product.getDeliveryOption());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        product.setProductId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET category_id = ?, subcategory_id = ?, product_name = ?, description = ?, " +
                     "price = ?, discount_percent = ?, stock_quantity = ?, material = ?, color = ?, size = ?, " +
                     "dimensions = ?, style = ?, brand = ?, rating = ?, is_featured = ?, status = ?, rooms = ?, delivery_option = ?, updated_at = NOW() " +
                     "WHERE product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, product.getCategoryId());
            if (product.getSubcategoryId() != null && product.getSubcategoryId() > 0) {
                ps.setInt(2, product.getSubcategoryId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, product.getProductName());
            ps.setString(4, product.getDescription());
            ps.setBigDecimal(5, product.getPrice());
            ps.setBigDecimal(6, product.getDiscountPercent());
            ps.setInt(7, product.getStockQuantity());
            ps.setString(8, product.getMaterial());
            ps.setString(9, product.getColor());
            ps.setString(10, product.getSize());
            ps.setString(11, product.getDimensions());
            ps.setString(12, product.getStyle());
            ps.setString(13, product.getBrand());
            ps.setBigDecimal(14, product.getRating());
            ps.setBoolean(15, product.isFeatured());
            ps.setString(16, product.getStatus());
            ps.setString(17, product.getRooms() != null ? product.getRooms() : "living_room,hall");
            ps.setString(18, product.getDeliveryOption());
            ps.setInt(19, product.getProductId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStock(int productId, int quantityChange) {
        String sql = "UPDATE products SET stock_quantity = stock_quantity + ?, updated_at = NOW() WHERE product_id = ? AND stock_quantity + ? >= 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantityChange);
            ps.setInt(2, productId);
            ps.setInt(3, quantityChange);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean setStock(int productId, int newQuantity) {
        String sql = "UPDATE products SET stock_quantity = ?, updated_at = NOW() WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, Math.max(0, newQuantity));
            ps.setInt(2, productId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteProduct(int productId) {
        String sql = "UPDATE products SET status = 'INACTIVE', updated_at = NOW() WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalProductCount() {
        String sql = "SELECT COUNT(*) FROM products WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private String buildOrderBy(String sortBy) {
        if (sortBy == null || sortBy.trim().isEmpty() || "featured".equalsIgnoreCase(sortBy.trim())) {
            return " ORDER BY p.category_id ASC, p.is_featured DESC, p.product_id ASC";
        }
        switch (sortBy.trim()) {
            case "price_asc":
            case "price_low":
                return " ORDER BY p.price ASC, p.product_id ASC";
            case "price_desc":
            case "price_high":
                return " ORDER BY p.price DESC, p.product_id ASC";
            case "rating":
                return " ORDER BY p.rating DESC, p.product_id ASC";
            case "newest":
                return " ORDER BY p.product_id DESC";
            default:
                return " ORDER BY p.category_id ASC, p.is_featured DESC, p.product_id ASC";
        }

    }

    private List<Product> executeQueryList(String sql) {
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Product> executeQueryListWithInt(String sql, int val) {
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, val);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setCategoryId(rs.getInt("category_id"));
        int subcat = rs.getInt("subcategory_id");
        if (!rs.wasNull()) {
            p.setSubcategoryId(subcat);
        }
        p.setProductName(rs.getString("product_name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setDiscountPercent(rs.getBigDecimal("discount_percent"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        p.setMaterial(rs.getString("material"));
        p.setColor(rs.getString("color"));
        p.setSize(rs.getString("size"));
        p.setDimensions(rs.getString("dimensions"));
        p.setStyle(rs.getString("style"));
        p.setBrand(rs.getString("brand"));
        p.setRating(rs.getBigDecimal("rating"));
        p.setFeatured(rs.getBoolean("is_featured"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));

        try {
            p.setCategoryName(rs.getString("category_name"));
            p.setSubcategoryName(rs.getString("subcategory_name"));
            p.setPrimaryImageUrl(rs.getString("primary_img"));
        } catch (SQLException ignored) {
        }
        try {
            p.setRooms(rs.getString("rooms"));
        } catch (SQLException ignored) {
        }
        try {
            String dOpt = rs.getString("delivery_option");
            if (dOpt != null && !dOpt.trim().isEmpty()) {
                p.setDeliveryOption(dOpt);
            }
        } catch (SQLException ignored) {
        }
        return p;
    }
}
