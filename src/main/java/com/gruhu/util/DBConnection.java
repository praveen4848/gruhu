package com.gruhu.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Proxy;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

public class DBConnection {

    private static String url;
    private static String username;
    private static String password;
    private static String driver;

    private static final int MAX_POOL_SIZE = 15;
    private static final BlockingQueue<Connection> pool = new LinkedBlockingQueue<>(MAX_POOL_SIZE);

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
        Connection conn = null;
        try {
            conn = pool.poll(50, TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        if (conn != null) {
            try {
                if (!conn.isClosed() && conn.isValid(1)) {
                    return conn;
                }
            } catch (SQLException ignored) {
            }
        }

        Connection real = DriverManager.getConnection(url, username, password);
        return wrap(real);
    }

    private static Connection wrap(Connection real) {
        return (Connection) Proxy.newProxyInstance(
                DBConnection.class.getClassLoader(),
                new Class<?>[]{Connection.class},
                (proxy, method, args) -> {
                    String name = method.getName();
                    if ("close".equals(name)) {
                        try {
                            if (!real.isClosed()) {
                                if (!real.getAutoCommit()) {
                                    real.setAutoCommit(true);
                                }
                                if (real.isValid(1)) {
                                    if (!pool.offer((Connection) proxy)) {
                                        real.close();
                                    }
                                    return null;
                                }
                            }
                        } catch (Exception e) {
                            try { real.close(); } catch (Exception ignored) {}
                            return null;
                        }
                        try { real.close(); } catch (Exception ignored) {}
                        return null;
                    }
                    if ("isClosed".equals(name)) {
                        return real.isClosed();
                    }
                    try {
                        return method.invoke(real, args);
                    } catch (InvocationTargetException ite) {
                        throw ite.getCause();
                    }
                }
        );
    }
}