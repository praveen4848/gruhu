package com.gruhu.util;

import java.math.BigDecimal;
import java.util.regex.Pattern;

public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[0-9]{10,15}$");

    private ValidationUtil() {
    }

    public static boolean isValidEmail(String email) {
        if (email == null) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (phone == null) {
            return false;
        }
        String digits = phone.replaceAll("[^0-9]", "");
        return PHONE_PATTERN.matcher(digits).matches();
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static String sanitize(String input) {
        if (input == null) {
            return "";
        }
        return input.trim()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }

    public static int parseInt(String str, int defaultValue) {
        if (str == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(str.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static BigDecimal parseBigDecimal(String str, BigDecimal defaultValue) {
        if (str == null) {
            return defaultValue;
        }
        try {
            return new BigDecimal(str.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
