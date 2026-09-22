package com.gruhu.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static String url;
    private static String username;
    private static String password;
    private static String driver;

    static {
        try (InputStream input = DBConnection.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            Properties properties = new Properties();

            if (input != null) {
                properties.load(input);
            }

            // Priority: Environment variables (Render, Docker, Railway) -> Fallback: db.properties (Local)
            String envUrl = System.getenv("DB_URL");
            url = (envUrl != null && !envUrl.trim().isEmpty()) ? envUrl.trim() : properties.getProperty("db.url");

            String envUser = System.getenv("DB_USERNAME");
            if (envUser == null || envUser.trim().isEmpty()) {
                envUser = System.getenv("DB_USER");
            }
            username = (envUser != null && !envUser.trim().isEmpty()) ? envUser.trim() : properties.getProperty("db.username");

            String envPass = System.getenv("DB_PASSWORD");
            password = (envPass != null) ? envPass : properties.getProperty("db.password");

            driver = properties.getProperty("db.driver");
            if (driver == null || driver.trim().isEmpty()) {
                driver = "com.mysql.cj.jdbc.Driver";
            }

            Class.forName(driver);

        } catch (IOException | ClassNotFoundException exception) {
            throw new RuntimeException(
                    "Unable to load database configuration.",
                    exception
            );
        }
    }

    private DBConnection() {
        // Prevent object creation.
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
}