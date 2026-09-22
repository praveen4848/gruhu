package com.gruhu.controller;

import com.gruhu.service.AiStylistService;
import com.gruhu.service.AiStylistService.StylistResult;
import com.gruhu.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "AiStylistServlet", urlPatterns = {"/api/ai-stylist"})
public class AiStylistServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final AiStylistService stylistService = new AiStylistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String apiKey = AiStylistService.getApiKey();
        boolean hasGeminiKey = apiKey != null && !apiKey.trim().isEmpty() && !apiKey.contains("PASTE_KEY_HERE");
        String activeEngine = hasGeminiKey ? "Google Gemini 2.5 Flash (Vision & Text)" : "Atelier Spatial Heuristics (Catalog-Grounded)";

        String json = String.format("{\n" +
                "  \"status\": \"ACTIVE\",\n" +
                "  \"engine\": \"%s\",\n" +
                "  \"model\": \"%s\",\n" +
                "  \"hasGeminiApiKey\": %b,\n" +
                "  \"suggestions\": [\n" +
                "    \"Warm Japandi living room with solid oak and textural bouclé\",\n" +
                "    \"Serene bedroom sanctuary with low-slung platform styling under ₹50,000\",\n" +
                "    \"Sculptural dining studio with diffuse pendant illumination\",\n" +
                "    \"Tactile architectural reading corner with arch brass mirror\"\n" +
                "  ]\n" +
                "}", activeEngine, AiStylistService.getModelName(), hasGeminiKey);

        response.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String query = request.getParameter("query");
        String roomType = request.getParameter("roomType");
        String budgetParam = request.getParameter("budget");
        String imageBase64 = request.getParameter("image");
        String mimeType = request.getParameter("mimeType");

        // If body was sent as raw JSON instead of form data, parse fields
        String contentType = request.getContentType();
        if (contentType != null && contentType.contains("application/json")) {
            StringBuilder body = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    body.append(line);
                }
            }
            String rawJson = body.toString();
            if (!rawJson.isEmpty()) {
                query = parseJsonStringField(rawJson, "query", query);
                roomType = parseJsonStringField(rawJson, "roomType", roomType);
                budgetParam = parseJsonStringField(rawJson, "budget", budgetParam);
                imageBase64 = parseJsonStringField(rawJson, "image", imageBase64);
                mimeType = parseJsonStringField(rawJson, "mimeType", mimeType);
            }
        }

        BigDecimal budget = BigDecimal.ZERO;
        if (budgetParam != null && !budgetParam.trim().isEmpty()) {
            try {
                budget = new BigDecimal(budgetParam.replaceAll("[^0-9.]", "").trim());
            } catch (Exception ignored) {
            }
        }

        StylistResult result = stylistService.generateStyling(query, roomType, budget, imageBase64, mimeType);

        String jsonResponse = stylistService.toJson(result);
        response.getWriter().write(jsonResponse);
    }

    private String parseJsonStringField(String json, String field, String defaultValue) {
        String key = "\"" + field + "\"";
        int idx = json.indexOf(key);
        if (idx == -1) return defaultValue;

        int colon = json.indexOf(":", idx + key.length());
        if (colon == -1) return defaultValue;

        // Skip whitespace
        int start = colon + 1;
        while (start < json.length() && Character.isWhitespace(json.charAt(start))) {
            start++;
        }
        if (start >= json.length()) return defaultValue;

        if (json.charAt(start) == '"') {
            StringBuilder sb = new StringBuilder();
            boolean escaped = false;
            for (int i = start + 1; i < json.length(); i++) {
                char c = json.charAt(i);
                if (escaped) {
                    switch (c) {
                        case 'n': sb.append('\n'); break;
                        case 'r': sb.append('\r'); break;
                        case 't': sb.append('\t'); break;
                        case '"': sb.append('"'); break;
                        case '\\': sb.append('\\'); break;
                        default: sb.append(c); break;
                    }
                    escaped = false;
                } else if (c == '\\') {
                    escaped = true;
                } else if (c == '"') {
                    return sb.toString();
                } else {
                    sb.append(c);
                }
            }
            return sb.toString();
        } else {
            // number or boolean
            int end = start;
            while (end < json.length() && json.charAt(end) != ',' && json.charAt(end) != '}' && !Character.isWhitespace(json.charAt(end))) {
                end++;
            }
            return json.substring(start, end).trim();
        }
    }
}
