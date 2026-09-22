package com.gruhu.service;

import com.gruhu.dao.CartDAO;
import com.gruhu.dao.ProductDAO;
import com.gruhu.dao.WishlistDAO;
import com.gruhu.model.Cart;
import com.gruhu.model.Product;
import com.gruhu.model.Wishlist;

import java.util.List;

public class CartService {

    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    public Cart getCart(int customerId) {
        return cartDAO.getOrCreateCartByCustomerId(customerId);
    }

    public boolean addToCart(int customerId, int productId, int quantity) throws IllegalArgumentException {
        Product product = productDAO.getProductById(productId);
        if (product == null || !"ACTIVE".equalsIgnoreCase(product.getStatus())) {
            throw new IllegalArgumentException("Selected product is no longer available.");
        }

        if (product.getStockQuantity() < quantity) {
            throw new IllegalArgumentException("Only " + product.getStockQuantity() + " unit(s) available in stock.");
        }

        return cartDAO.addItemToCart(customerId, productId, quantity);
    }

    public boolean updateQuantity(int customerId, int cartItemId, int quantity) {
        return cartDAO.updateItemQuantity(customerId, cartItemId, quantity);
    }

    public boolean removeFromCart(int customerId, int cartItemId) {
        return cartDAO.removeItemFromCart(customerId, cartItemId);
    }

    public boolean clearCart(int customerId) {
        return cartDAO.clearCart(customerId);
    }

    public int getCartCount(int customerId) {
        return cartDAO.getCartItemCount(customerId);
    }

    public boolean addToWishlist(int customerId, int productId) {
        return wishlistDAO.addToWishlist(customerId, productId);
    }

    public boolean removeFromWishlist(int customerId, int productId) {
        return wishlistDAO.removeFromWishlist(customerId, productId);
    }

    public boolean isInWishlist(int customerId, int productId) {
        return wishlistDAO.isInWishlist(customerId, productId);
    }

    public List<Wishlist> getWishlist(int customerId) {
        return wishlistDAO.getWishlistByCustomerId(customerId);
    }

    public int getWishlistCount(int customerId) {
        return wishlistDAO.getWishlistCount(customerId);
    }
}
