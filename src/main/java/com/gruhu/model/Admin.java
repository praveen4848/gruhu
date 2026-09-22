package com.gruhu.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Admin implements Serializable {

    private static final long serialVersionUID = 1L;

    private int adminId;
    private String username;
    private String passwordHash;
    private String name;
    private String email;
    private Timestamp createdAt;

    public Admin() {
    }

    public Admin(int adminId, String username, String passwordHash, String name, String email, Timestamp createdAt) {
        this.adminId = adminId;
        this.username = username;
        this.passwordHash = passwordHash;
        this.name = name;
        this.email = email;
        this.createdAt = createdAt;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Admin{" +
                "adminId=" + adminId +
                ", username='" + username + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
