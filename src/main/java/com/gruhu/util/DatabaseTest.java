package com.gruhu.util;

import java.sql.Connection;

public class DatabaseTest {

    public static void main(String[] args) {

        try (Connection connection = DBConnection.getConnection()) {

            if (connection != null && !connection.isClosed()) {
                System.out.println("MySQL database connection successful.");
            }

        } catch (Exception exception) {
            System.out.println("Database connection failed.");
            exception.printStackTrace();
        }
    }
}