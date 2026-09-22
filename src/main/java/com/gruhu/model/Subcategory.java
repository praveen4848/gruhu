package com.gruhu.model;

import java.io.Serializable;

public class Subcategory implements Serializable {

    private static final long serialVersionUID = 1L;

    private int subcategoryId;
    private int categoryId;
    private String subcategoryName;
    private String description;
    private String status;
    private String categoryName;

    public Subcategory() {
    }

    public Subcategory(int subcategoryId, int categoryId, String subcategoryName,
                       String description, String status) {
        this.subcategoryId = subcategoryId;
        this.categoryId = categoryId;
        this.subcategoryName = subcategoryName;
        this.description = description;
        this.status = status;
    }

    public int getSubcategoryId() {
        return subcategoryId;
    }

    public void setSubcategoryId(int subcategoryId) {
        this.subcategoryId = subcategoryId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getSubcategoryName() {
        return subcategoryName;
    }

    public void setSubcategoryName(String subcategoryName) {
        this.subcategoryName = subcategoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    @Override
    public String toString() {
        return "Subcategory{" +
                "subcategoryId=" + subcategoryId +
                ", categoryId=" + categoryId +
                ", subcategoryName='" + subcategoryName + '\'' +
                '}';
    }
}
