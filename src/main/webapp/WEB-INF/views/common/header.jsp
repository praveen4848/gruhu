<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Gruhu — Architectural Living & Home Interior'}</title>

    <!-- SEO Meta Tags -->
    <meta name="description" content="Gruhu Atelier — Architectural Living & Nordic Interior Objects. Handcrafted 2-4 seater sofas, lounge chairs, lamps, solid oak mirrors, and tactile decor.">
    <meta name="keywords" content="Gruhu, Scandinavian furniture, architectural living, sofas, armchairs, dining tables, lamps, mirrors, storage, minimalist home decor">
    <meta name="author" content="Gruhu Atelier">
    <meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large">

    <!-- Open Graph / Social SEO -->
    <meta property="og:title" content="${not empty pageTitle ? pageTitle : 'Gruhu — Architectural Living & Home Interior'}">
    <meta property="og:description" content="Mindfully designed interior objects crafted from sustainably harvested hardwood, organic textiles, and honest stone.">
    <meta property="og:type" content="website">
    <meta property="og:site_name" content="Gruhu Atelier">
    <meta property="og:locale" content="en_IN">

    <!-- Twitter Card SEO -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="${not empty pageTitle ? pageTitle : 'Gruhu — Architectural Living'}">
    <meta name="twitter:description" content="Mindfully designed Scandinavian furniture and architectural home decor.">

    <!-- Schema.org JSON-LD for Google Rich Results -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FurnitureStore",
      "name": "Gruhu Atelier",
      "description": "Architectural living, minimalist furniture, lamps, mirrors, and home decor.",
      "url": "http://localhost:8081/gruhu/",
      "priceRange": "₹₹₹",
      "currenciesAccepted": "INR"
    }
    </script>

    <!-- 1. Core Stylesheet (Loaded FIRST so page is NEVER unstyled) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=3.0">

    <!-- 2. Conditional Module Stylesheets -->
    <%
        String extraCss = (String) request.getAttribute("extraCss");
        if (extraCss != null && !extraCss.isEmpty()) {
            String[] cssFiles = extraCss.split(",");
            for (String cssFile : cssFiles) {
                String trimmed = cssFile.trim();
                if (!trimmed.isEmpty()) {
    %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/<%= trimmed %>?v=3.0">
    <%          }
            }
        }
    %>

    <!-- 3. Google Fonts (Plus Jakarta Sans & Playfair Display) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,400&display=swap" rel="stylesheet">

    <!-- 4. FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <!-- Announcement Bar -->
    <div class="top-announcement-bar">
        <span><i class="fa-solid fa-sparkles"></i> Complimentary White-Glove Delivery Across India &bull; 10-Year Architectural Woodwork Warranty</span>
    </div>