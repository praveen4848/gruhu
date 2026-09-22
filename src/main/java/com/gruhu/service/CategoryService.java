package com.gruhu.service;

import com.gruhu.dao.CategoryDAO;
import com.gruhu.dao.SubcategoryDAO;
import com.gruhu.model.Category;
import com.gruhu.model.Subcategory;

import java.util.List;

public class CategoryService {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SubcategoryDAO subcategoryDAO = new SubcategoryDAO();

    private static volatile List<Category> cachedActiveCategories = null;
    private static volatile List<Category> cachedAllCategories = null;
    private static volatile List<Subcategory> cachedAllSubcategories = null;
    private static volatile long lastActiveCatTime = 0;
    private static volatile long lastAllCatTime = 0;
    private static volatile long lastSubcatTime = 0;
    private static final long CACHE_TTL_MS = 120_000; // 2 minutes cache

    public static synchronized void invalidateCache() {
        cachedActiveCategories = null;
        cachedAllCategories = null;
        cachedAllSubcategories = null;
        lastActiveCatTime = 0;
        lastAllCatTime = 0;
        lastSubcatTime = 0;
    }

    public List<Category> getActiveCategories() {
        long now = System.currentTimeMillis();
        if (cachedActiveCategories != null && (now - lastActiveCatTime < CACHE_TTL_MS)) {
            return cachedActiveCategories;
        }
        synchronized (CategoryService.class) {
            if (cachedActiveCategories == null || (now - lastActiveCatTime >= CACHE_TTL_MS)) {
                cachedActiveCategories = categoryDAO.getAllActiveCategories();
                lastActiveCatTime = now;
            }
        }
        return cachedActiveCategories;
    }

    public List<Category> getAllCategories() {
        long now = System.currentTimeMillis();
        if (cachedAllCategories != null && (now - lastAllCatTime < CACHE_TTL_MS)) {
            return cachedAllCategories;
        }
        synchronized (CategoryService.class) {
            if (cachedAllCategories == null || (now - lastAllCatTime >= CACHE_TTL_MS)) {
                cachedAllCategories = categoryDAO.getAllCategories();
                lastAllCatTime = now;
            }
        }
        return cachedAllCategories;
    }

    public Category getCategoryById(int categoryId) {
        return categoryDAO.getCategoryById(categoryId);
    }

    public boolean addCategory(Category category) {
        boolean ok = categoryDAO.addCategory(category);
        if (ok) invalidateCache();
        return ok;
    }

    public boolean updateCategory(Category category) {
        boolean ok = categoryDAO.updateCategory(category);
        if (ok) invalidateCache();
        return ok;
    }

    public boolean deleteCategory(int categoryId) {
        boolean ok = categoryDAO.deleteCategory(categoryId);
        if (ok) invalidateCache();
        return ok;
    }

    public List<Subcategory> getSubcategoriesByCategory(int categoryId) {
        return subcategoryDAO.getSubcategoriesByCategoryId(categoryId);
    }

    public List<Subcategory> getAllSubcategories() {
        long now = System.currentTimeMillis();
        if (cachedAllSubcategories != null && (now - lastSubcatTime < CACHE_TTL_MS)) {
            return cachedAllSubcategories;
        }
        synchronized (CategoryService.class) {
            if (cachedAllSubcategories == null || (now - lastSubcatTime >= CACHE_TTL_MS)) {
                cachedAllSubcategories = subcategoryDAO.getAllSubcategories();
                lastSubcatTime = now;
            }
        }
        return cachedAllSubcategories;
    }

    public Subcategory getSubcategoryById(int subcategoryId) {
        return subcategoryDAO.getSubcategoryById(subcategoryId);
    }

    public boolean addSubcategory(Subcategory subcategory) {
        boolean ok = subcategoryDAO.addSubcategory(subcategory);
        if (ok) invalidateCache();
        return ok;
    }

    public boolean updateSubcategory(Subcategory subcategory) {
        boolean ok = subcategoryDAO.updateSubcategory(subcategory);
        if (ok) invalidateCache();
        return ok;
    }

    public boolean deleteSubcategory(int subcategoryId) {
        boolean ok = subcategoryDAO.deleteSubcategory(subcategoryId);
        if (ok) invalidateCache();
        return ok;
    }
}
