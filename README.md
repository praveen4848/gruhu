# Gruhu — Scandinavian Architectural Interior Atelier

> **"Tailored to live in union with its atmosphere"**

Gruhu is an architectural e-commerce boutique and spatial interior atelier inspired by Scandinavian serenity and honest natural materiality. Built on modern Java (Jakarta Servlet 6.0 / Tomcat 10.1) and powered by the flagship **Atelier AI Spatial Stylist** (Google Gemini 2.5 Flash + Spatial Heuristics).

---

## Key Highlights

- **Atelier AI Spatial Stylist**: Dual-engine multimodal interior stylist. Accepts room photos for spatial lighting & proportion diagnosis, curates 4-swatch harmonious color palettes, and recommends catalog-grounded 3-piece ensembles with 1-click bundle acquisition.
- **Curated Storefront**: Infinite horizontal category carousel with smooth continuous motion, room environment filtering (Living Room, Bedroom, Dining, Grand Hall), and instant search.
- **Booking & Checkout**: White-glove delivery settlement, interactive UPI app selection (Google Pay, PhonePe, Paytm, BHIM, Amazon Pay), and celebratory canvas fireworks blast.
- **Curator Administration Console**: Real-time business metrics, catalog object management, image galleries, stock reserves control with low/depleted filtering, and customer inquiry management.
- **Architectural Branding**: Custom 3D house monogram wax seal, typography, and full-screen ambient video hero banner.

---

## Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Language** | Java 21 LTS |
| **Web Framework** | Jakarta Servlet 6.0 (Jakarta EE 10) |
| **View Engine** | JavaServer Pages (JSP), JSTL |
| **Application Server** | Apache Tomcat 10.1+ |
| **Database** | MySQL 8.0 (JDBC Connection Pooling) |
| **AI Integration** | Google Gemini 2.5 Flash Multimodal REST API |
| **Build Tool** | Apache Maven |
| **Containerization** | Docker (Multi-stage build) |

---

## Local Setup

### Prerequisites
- JDK 21+
- Apache Tomcat 10.1+
- MySQL 8.0+

### Database Configuration
Import the database schema and seed data into MySQL (`home_interior_db`):
```sql
CREATE DATABASE home_interior_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Configure connection in `src/main/resources/db.properties` or set environment variables:
```properties
db.url=jdbc:mysql://localhost:3306/home_interior_db?useSSL=false&serverTimezone=Asia/Kolkata
db.username=root
db.password=YOUR_PASSWORD
```

---

## Cloud Deployment (Render / Docker)

This repository includes a multi-stage `Dockerfile`.

1. Fork or push this repository to GitHub.
2. In **Render.com**, create a **New Web Service** and select this repository.
3. Set Environment Variables:
   - `DB_URL`: `jdbc:mysql://YOUR_DB_HOST:3306/YOUR_DB_NAME?useSSL=false`
   - `DB_USERNAME`: `YOUR_DB_USER`
   - `DB_PASSWORD`: `YOUR_DB_PASSWORD`
   - `GEMINI_API_KEY`: *(Optional)* Your Google Gemini API Key.
4. Render will automatically build the WAR package and start Tomcat on port `8080`.

---

## License

Proprietary & Craftsmanship Rights &copy; 2026 Gruhu Atelier. All rights reserved.
