package com.gruhu.service;

import com.gruhu.dao.CategoryDAO;
import com.gruhu.dao.SubcategoryDAO;
import com.gruhu.model.Category;
import com.gruhu.model.Subcategory;

import java.util.List;

public class CategoryService {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SubcategoryDAO subcategoryDAO = new SubcategoryDAO();

    public List<Category> getActiveCategories() {
        return categoryDAO.getAllActiveCategories();
    }

    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }

    public Category getCategoryById(int categoryId) {
        return categoryDAO.getCategoryById(categoryId);
    }

    public boolean addCategory(Category category) {
        return categoryDAO.addCategory(category);
    }

    public boolean updateCategory(Category category) {
        return categoryDAO.updateCategory(category);
    }

    public boolean deleteCategory(int categoryId) {
        return categoryDAO.deleteCategory(categoryId);
    }

    public List<Subcategory> getSubcategoriesByCategory(int categoryId) {
        return subcategoryDAO.getSubcategoriesByCategoryId(categoryId);
    }

    public List<Subcategory> getAllSubcategories() {
        return subcategoryDAO.getAllSubcategories();
    }

    public Subcategory getSubcategoryById(int subcategoryId) {
        return subcategoryDAO.getSubcategoryById(subcategoryId);
    }

    public boolean addSubcategory(Subcategory subcategory) {
        return subcategoryDAO.addSubcategory(subcategory);
    }

    public boolean updateSubcategory(Subcategory subcategory) {
        return subcategoryDAO.updateSubcategory(subcategory);
    }

    public boolean deleteSubcategory(int subcategoryId) {
        return subcategoryDAO.deleteSubcategory(subcategoryId);
    }
}
