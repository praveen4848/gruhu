package com.gruhu.util;

import java.math.BigDecimal;
import java.sql.*;

public class SeedDatabase {

    public static void main(String[] args) {
        System.out.println("==========================================================");
        System.out.println("Seeding Gruhu Scandinavian Atelier Catalog (Feldgrau Edition)");
        System.out.println("42 Products across 6 Categories with Coordinated Same-Product Views");
        System.out.println("==========================================================");

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Seed / Ensure Admin
            try (PreparedStatement checkAdmin = conn.prepareStatement("SELECT COUNT(*) FROM admin WHERE username = ?")) {
                checkAdmin.setString(1, "admin");
                ResultSet rs = checkAdmin.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    try (PreparedStatement insertAdmin = conn.prepareStatement(
                            "INSERT INTO admin (username, password_hash, name, email, created_at) VALUES (?, ?, ?, ?, NOW())")) {
                        insertAdmin.setString(1, "admin");
                        insertAdmin.setString(2, PasswordUtil.hashPassword("Admin@123"));
                        insertAdmin.setString(3, "Gruhu Administrator");
                        insertAdmin.setString(4, "admin@gruhu.com");
                        insertAdmin.executeUpdate();
                        System.out.println("Created admin user: admin / Admin@123");
                    }
                }
            }

            // Clean existing catalog tables to allow fresh re-seeding
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET FOREIGN_KEY_CHECKS = 0");
                stmt.execute("TRUNCATE TABLE product_images");
                stmt.execute("TRUNCATE TABLE wishlist");
                stmt.execute("TRUNCATE TABLE cart_items");
                stmt.execute("TRUNCATE TABLE order_items");
                stmt.execute("TRUNCATE TABLE products");
                stmt.execute("TRUNCATE TABLE subcategories");
                stmt.execute("TRUNCATE TABLE categories");
                stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
                System.out.println("Reset catalog tables cleanly.");
            }

            // 2. Categories (6 categories)
            String[][] categories = {
                {"Living Room", "Thoughtfully sculpted sofas, serene lounge chairs, and organic travertine tables crafted for peaceful living.", "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1000&q=80"},
                {"Bedroom", "Sanctuary-grade platform beds, minimalist nightstands, and breathable organic fabrics for restorative rest.", "https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&w=1000&q=80"},
                {"Dining & Kitchen", "Architectural dining tables, sculpted seating, and tactile storage built for timeless gatherings.", "https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=1000&q=80"},
                {"Lighting", "Atmospheric pendants, tactile ceramic table lamps, and brushed brass fixtures casting gentle ambient warmth.", "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=1000&q=80"},
                {"Mirrors & Wall Decor", "Organic curved mirrors, understated brass frames, and textured canvases capturing soft light.", "https://images.unsplash.com/photo-1618220179428-22790b461013?auto=format&fit=crop&w=1000&q=80"},
                {"Curtains & Textiles", "Heavyweight Belgian linens, plush wool carpets, and earthy woven throws for acoustic and tactile comfort.", "https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?auto=format&fit=crop&w=1000&q=80"}
            };

            int[] catIds = new int[categories.length];
            String catSql = "INSERT INTO categories (category_name, description, category_image, status, created_at) VALUES (?, ?, ?, 'ACTIVE', NOW())";
            for (int i = 0; i < categories.length; i++) {
                try (PreparedStatement pstmt = conn.prepareStatement(catSql, Statement.RETURN_GENERATED_KEYS)) {
                    pstmt.setString(1, categories[i][0]);
                    pstmt.setString(2, categories[i][1]);
                    pstmt.setString(3, categories[i][2]);
                    pstmt.executeUpdate();
                    ResultSet keys = pstmt.getGeneratedKeys();
                    if (keys.next()) catIds[i] = keys.getInt(1);
                }
            }
            System.out.println("Seeded 6 Categories with IDs 1 to 6.");

            // 3. Subcategories (2 per category = 12 subcategories)
            Object[][] subcats = {
                {catIds[0], "Sofas & Sectionals", "Low-profile architectural sofas and modular seating."},
                {catIds[0], "Lounge Chairs & Tables", "Sculptural accent chairs, travertine and oak tables."},
                {catIds[1], "Platform Beds & Headboards", "Solid timber beds and upholstered sanctuary bedframes."},
                {catIds[1], "Nightstands & Storage", "Floating timber tables and fluted dressers."},
                {catIds[2], "Dining Tables & Credenzas", "Pill-shaped solid oak tables and storage sideboards."},
                {catIds[2], "Dining Chairs & Stools", "Woven paper cord seating and curved wood dining chairs."},
                {catIds[3], "Pendants & Chandeliers", "Hand-folded washi paper and architectural ceiling fixtures."},
                {catIds[3], "Lamps & Sconces", "Ceramic bases, marble foundation lamps, and wall luminaires."},
                {catIds[4], "Floor & Standing Mirrors", "Monumental arched brass and timber standing mirrors."},
                {catIds[4], "Wall Mirrors & Decor", "Organic pebble frames, fluted shelves, and textured canvas art."},
                {catIds[5], "Linen Curtains & Drapes", "Long-staple Belgian linen panels and blackout drapery."},
                {catIds[5], "Wool Carpets & Rugs", "Hand-knotted New Zealand wool rugs and jute runners."}
            };

            int[] subcatIds = new int[subcats.length];
            String subSql = "INSERT INTO subcategories (category_id, subcategory_name, description, status) VALUES (?, ?, ?, 'ACTIVE')";
            for (int i = 0; i < subcats.length; i++) {
                try (PreparedStatement pstmt = conn.prepareStatement(subSql, Statement.RETURN_GENERATED_KEYS)) {
                    pstmt.setInt(1, (Integer) subcats[i][0]);
                    pstmt.setString(2, (String) subcats[i][1]);
                    pstmt.setString(3, (String) subcats[i][2]);
                    pstmt.executeUpdate();
                    ResultSet keys = pstmt.getGeneratedKeys();
                    if (keys.next()) subcatIds[i] = keys.getInt(1);
                }
            }
            System.out.println("Seeded 12 Subcategories.");

            // 4. Products definition: exactly 7 per category = 42 products
            // Each product contains 15 attribute fields + 1 base high-res photo URL = 16 elements
            Object[][] products = {
                // ==================== CATEGORY 1: LIVING ROOM (7 Products) ====================
                {catIds[0], subcatIds[0], "Koto Boucle 3-Seater Sofa",
                 "Designed with low slung proportions, rounded contours, and upholstered in premium textured boucle. Features high-density resilient foam cushioning and FSC-certified kiln-dried solid beech frame.",
                 new BigDecimal("68999.00"), new BigDecimal("15.0"), 12, "Italian Boucle & Solid Beech", "Warm Oat", "3-Seater", "230 x 95 x 72 cm", "Scandinavian Modern", "Gruhu Atelier", new BigDecimal("4.9"), true,
                 "https://images.unsplash.com/photo-1555041469-a586c61ea9bc"},

                {catIds[0], subcatIds[1], "Astrid Sculptural Lounge Chair",
                 "A harmonious union of sculpted solid white oak and organic boucle upholstery. Generous seat angle engineered for deep ergonomic relaxation with an architectural profile from every angle.",
                 new BigDecimal("28499.00"), new BigDecimal("10.0"), 18, "Solid White Oak & Linen Blend", "Sand Beige", "Medium", "82 x 78 x 75 cm", "Japandi", "Gruhu Atelier", new BigDecimal("4.8"), true,
                 "https://images.unsplash.com/photo-1586023492125-27b2c045efd7"},

                {catIds[0], subcatIds[1], "Oresund Travertine Coffee Table",
                 "Hand-cut honed Roman travertine marble atop twin sculptural fluted oak plinths. Every piece displays unique porous mineral veining and natural warm earth patina.",
                 new BigDecimal("34999.00"), new BigDecimal("0.0"), 8, "Natural Travertine & Oak", "Warm Ivory / Natural Oak", "Standard", "120 x 70 x 36 cm", "Warm Minimalist", "Gruhu Stone", new BigDecimal("4.9"), true,
                 "https://images.unsplash.com/photo-1533090161767-e6ffed986c88"},

                {catIds[0], subcatIds[0], "Viggo Modular L-Shape Sectional",
                 "Architectural deep-seating modular sectional featuring down-feather wrapped high resilience core and stain-resistant woven flax tweed. Configurable left or right orientation.",
                 new BigDecimal("84999.00"), new BigDecimal("12.0"), 6, "Belgian Flax & Kiln-Dried Pine", "Feldgrau Mist", "4-Seater Corner", "290 x 175 x 70 cm", "Scandinavian Modern", "Gruhu Atelier", new BigDecimal("4.9"), true,
                 "https://images.unsplash.com/photo-1550254478-ead40cc54513"},

                {catIds[0], subcatIds[0], "Nordic Haven Minimalist Daybed",
                 "Solid ash timber frame with leather bolster restraint straps and removable organic wool mattress. Ideal as an architectural room divider or reading alcove.",
                 new BigDecimal("42999.00"), new BigDecimal("8.0"), 10, "Solid Ash & Saddle Leather", "Natural Ash / Moss", "Single Daybed", "200 x 85 x 42 cm", "Nordic", "Gruhu Craft", new BigDecimal("4.7"), false,
                 "https://images.unsplash.com/photo-1506898667547-42e22a468add"},

                {catIds[0], subcatIds[1], "Saga Curved Velvet Club Chair",
                 "Curved barrel silhouette upholstered in rich moss-green matte velvet. Concealed 360-degree silent swivel mechanism on a low-profile burnished brass base.",
                 new BigDecimal("31999.00"), new BigDecimal("5.0"), 14, "Matte Velvet & Brushed Brass", "Feldgrau Sage", "Standard", "80 x 82 x 74 cm", "Modernist", "Gruhu Atelier", new BigDecimal("4.8"), false,
                 "https://images.unsplash.com/photo-1580481077195-731da03fed61"},

                {catIds[0], subcatIds[1], "Arne Fluted Oak Media Console",
                 "Precision fluted solid white oak tambour sliding doors with integrated cable management conduits and solid brass pull detailing. Accommodates up to 75-inch screens.",
                 new BigDecimal("49999.00"), new BigDecimal("10.0"), 9, "Solid White Oak & Brass", "Smoked Natural Oak", "Large (180cm)", "180 x 45 x 52 cm", "Scandinavian Modern", "Gruhu Atelier", new BigDecimal("4.9"), false,
                 "https://images.unsplash.com/photo-1595428774223-ef52624120d2"},

                // ==================== CATEGORY 2: BEDROOM (7 Products) ====================
                {catIds[1], subcatIds[2], "Malmo Solid Oak Platform Bed",
                 "Low-profile bedstead crafted from sustainably harvested European white oak with soft radiused corners and integrated floating nightstand brackets. Designed for breathable slat airflow.",
                 new BigDecimal("54999.00"), new BigDecimal("12.0"), 10, "European Solid White Oak", "Natural Matte Oak", "King", "215 x 195 x 85 cm", "Nordic", "Gruhu Atelier", new BigDecimal("4.9"), true,
                 "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85"},

                {catIds[1], subcatIds[2], "Kobenhavn Upholstered Wing Bed",
                 "Tall winged headboard upholstered in thick Belgian linen tweed with exposed steam-bent solid ash feet. Ultra-quiet multi-ply European pine slat system.",
                 new BigDecimal("61999.00"), new BigDecimal("15.0"), 8, "Belgian Linen & Ash Wood", "Field Stone Grey", "King", "220 x 205 x 120 cm", "Scandinavian Modern", "Gruhu Atelier", new BigDecimal("4.8"), true,
                 "https://images.unsplash.com/photo-1616594039964-ae9021a400a0"},

                {catIds[1], subcatIds[3], "Freja Fluted Timber Nightstand",
                 "Hand-fluted drawer frontage with seamless push-to-open soft closing undermount runners. Solid oak frame with a honed marble top inlay for resistance to nightstand spills.",
                 new BigDecimal("14499.00"), new BigDecimal("5.0"), 24, "Solid Oak & Carrara Marble", "Light Oak", "Single Drawer", "50 x 40 x 48 cm", "Scandinavian", "Gruhu Atelier", new BigDecimal("4.7"), false,
                 "https://images.unsplash.com/photo-1532372320572-cda25653a26d"},

                {catIds[1], subcatIds[3], "Alva Floating Wall Nightstand",
                 "Cantilevered wall-mounted bedside table with a discreet cordless phone grommet and soft-close drawer. Liberates floor area for a clean, weightless aesthetic.",
                 new BigDecimal("9999.00"), new BigDecimal("0.0"), 30, "Bleached Ash & Solid Brass", "Bleached Ash", "Floating", "45 x 35 x 18 cm", "Warm Minimalist", "Gruhu Craft", new BigDecimal("4.8"), false,
                 "https://images.unsplash.com/photo-1540518614846-7ede433c4550"},

                {catIds[1], subcatIds[3], "Oslo 6-Drawer Architectural Dresser",
                 "Six full-extension deep drawers joined with traditional English dovetail joints and recessed continuous finger pulls. Finished in matte organic protective hardwax oil.",
                 new BigDecimal("47999.00"), new BigDecimal("10.0"), 7, "Solid White Oak", "Natural White Oak", "6-Drawer Double", "160 x 50 x 82 cm", "Nordic Craft", "Gruhu Atelier", new BigDecimal("4.9"), false,
                 "https://images.unsplash.com/photo-1538688525198-9b88f6f53126"},

                {catIds[1], subcatIds[2], "Stellana Cane & Oak Low Bedstead",
                 "Hand-woven Indonesian cane webbing set into an arched solid white oak frame. Provides gentle visual transparency and organic texture for airy bedroom sanctuaries.",
                 new BigDecimal("57999.00"), new BigDecimal("14.0"), 9, "Natural Rattan & White Oak", "Warm Honey Oak", "Queen", "210 x 165 x 95 cm", "Japandi", "Gruhu Craft", new BigDecimal("4.8"), true,
                 "https://images.unsplash.com/photo-1512917774080-9991f1c4c750"},

                {catIds[1], subcatIds[3], "Birka Minimalist Bedside Bench",
                 "Steam-bent ash bench featuring hand-laced natural paper cord seating. Sits gracefully at the foot of king and queen beds for throws, morning coffee, and books.",
                 new BigDecimal("16999.00"), new BigDecimal("0.0"), 15, "Solid Ash & Paper Cord", "Natural Ash", "Long Bench", "130 x 40 x 45 cm", "Scandinavian Modern", "Gruhu Craft", new BigDecimal("4.7"), false,
                 "https://images.unsplash.com/photo-1503602642458-232111445657"},

                // ==================== CATEGORY 3: DINING & KITCHEN (7 Products) ====================
                {catIds[2], subcatIds[4], "Lund Pill-Shaped Solid Oak Table",
                 "Architectural pill-shaped dining tabletop seating 6 to 8 people comfortably. Softly beveled edges with heavy conical cylindrical timber base for stable leg clearance.",
                 new BigDecimal("62999.00"), new BigDecimal("10.0"), 7, "Solid White Oak", "Oiled Natural Oak", "8-Seater", "220 x 100 x 76 cm", "Architectural", "Gruhu Atelier", new BigDecimal("5.0"), true,
                 "https://images.unsplash.com/photo-1617806118233-18e1de247200"},

                {catIds[2], subcatIds[5], "Hans Woven Cord Dining Chair (Set of 2)",
                 "Curved steam-bent solid ash backrest paired with a hand-woven Danish paper cord seat. Durable, lightweight, and engineered for hours of dinner party ease.",
                 new BigDecimal("21999.00"), new BigDecimal("8.0"), 30, "Solid Ash & Danish Paper Cord", "Bleached Ash", "Set of 2", "54 x 50 x 78 cm", "Mid-Century Nordic", "Gruhu Craft", new BigDecimal("4.8"), false,
                 "https://images.unsplash.com/photo-1581539250439-c96689b516dd"},

                {catIds[2], subcatIds[4], "Soren Fluted Oak Credenza Sideboard",
                 "Three seamless touch-latch soft closing doors reveal adjustable shelving and wire-routing channels. Standing on slender powder-coated matte black steel dowel legs.",
                 new BigDecimal("46999.00"), new BigDecimal("12.0"), 9, "European Oak Veneer & Steel", "Smoked Oak", "Large", "175 x 45 x 75 cm", "Scandinavian Modern", "Gruhu Atelier", new BigDecimal("4.8"), true,
                 "https://images.unsplash.com/photo-1598300042247-d088f8ab3a91"},

                {catIds[2], subcatIds[4], "Fjord Circular White Travertine Dining Table",
                 "Substantial circular tabletop of honed unfilled Italian travertine stone seated on an intersecting fluted timber column pedestal. Comfortably hosts 5 to 6 seats.",
                 new BigDecimal("74999.00"), new BigDecimal("15.0"), 5, "Honed Travertine & Solid Oak", "Pietra Beige / Oak", "135cm Round", "135 x 135 x 76 cm", "Architectural", "Gruhu Stone", new BigDecimal("5.0"), true,
                 "https://images.unsplash.com/photo-1577140917170-285929fb55b7"},

                {catIds[2], subcatIds[5], "Signe Sculptural Curved Dining Chair",
                 "3D molded ash ply back shell cradling the lumbar comfortably, wrapped in full-grain cognac saddle leather. Minimalist steel subframe powder-coated in matte feldgrau.",
                 new BigDecimal("18999.00"), new BigDecimal("0.0"), 20, "Ash Ply & Full-Grain Leather", "Cognac Tan", "Single Chair", "52 x 54 x 80 cm", "Modernist", "Gruhu Atelier", new BigDecimal("4.8"), false,
                 "https://images.unsplash.com/photo-1567538096630-e0c55bd6374c"},

                {catIds[2], subcatIds[5], "Elin Minimalist Oak Barstool (Set of 2)",
                 "Counter-height stools crafted with an organically sculpted saddle timber seat and an integrated solid brass footrest rail. Perfect for open kitchen islands.",
                 new BigDecimal("19499.00"), new BigDecimal("10.0"), 16, "Solid Oak & Brass", "Oiled Oak", "Counter Height (65cm)", "42 x 38 x 65 cm", "Scandinavian", "Gruhu Craft", new BigDecimal("4.7"), false,
                 "https://images.unsplash.com/photo-1519947486511-46149fa0a254"},

                {catIds[2], subcatIds[4], "Karna Glass Door Display Cabinet",
                 "Slender architectural display vitrine with reeded fluted glass doors and integrated soft warm LED interior strip lights. Ideal for ceramics and glassware.",
                 new BigDecimal("52999.00"), new BigDecimal("5.0"), 8, "Fluted Glass & Smoked Ash", "Smoked Ash", "Tall (190cm)", "90 x 42 x 190 cm", "Architectural", "Gruhu Atelier", new BigDecimal("4.9"), false,
                 "https://images.unsplash.com/photo-1524758631624-e2822e304c36"},

                // ==================== CATEGORY 4: LIGHTING (7 Products) ====================
                {catIds[3], subcatIds[6], "Solstice Washi Paper Pendant Light",
                 "Hand-folded Japanese mulberry paper shade supported on an ultra-minimal wire armature with brass canopy. Casts a poetic, shadow-free warm glow throughout living and dining areas.",
                 new BigDecimal("11499.00"), new BigDecimal("15.0"), 25, "Mulberry Washi Paper & Brass", "Cloud White", "Large (60cm)", "60 x 60 x 50 cm", "Japandi", "Gruhu Light", new BigDecimal("4.9"), true,
                 "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15"},

                {catIds[3], subcatIds[7], "Forma Matte Ceramic Table Lamp",
                 "Chunky hand-thrown terracotta ceramic base with an unglazed chalk-white slip finish. Paired with a raw linen drum shade and solid brass rotary dimmer.",
                 new BigDecimal("7999.00"), new BigDecimal("0.0"), 35, "Unglazed Ceramic & Natural Linen", "Chalk White", "Medium", "32 x 32 x 46 cm", "Wabi-Sabi", "Gruhu Light", new BigDecimal("4.7"), false,
                 "https://images.unsplash.com/photo-1540932239986-30128078f3c5"},

                {catIds[3], subcatIds[7], "Pillar Slender Brass Floor Lamp",
                 "Solid weighted Nero Marquina marble disc foundation rising into an elegant brushed brass cantilever arm. Integrated warm 2700K glare-free LED diffuser.",
                 new BigDecimal("18999.00"), new BigDecimal("20.0"), 14, "Brushed Brass & Black Marble", "Aged Brass", "Tall", "35 x 35 x 150 cm", "Modernist", "Gruhu Light", new BigDecimal("4.8"), true,
                 "https://images.unsplash.com/photo-1513694203232-719a280e022f"},

                {catIds[3], subcatIds[7], "Eos Travertine & Smoked Glass Lamp",
                 "Sculpted from solid unpolished travertine stone cube with a mouth-blown frosted smoked glass sphere. Produces an otherworldly warm celestial glow.",
                 new BigDecimal("9499.00"), new BigDecimal("0.0"), 22, "Natural Travertine & Handblown Glass", "Natural Stone", "Compact", "20 x 20 x 28 cm", "Warm Minimalist", "Gruhu Light", new BigDecimal("4.8"), true,
                 "https://images.unsplash.com/photo-1507473885765-e6ed057f782c"},

                {catIds[3], subcatIds[6], "Halo Minimalist Ring Chandelier",
                 "Architectural 80cm diameter continuous brass ring suspending satin frosted quartz glass cylinders. Completely dimmable for mood-shifting dining atmosphere.",
                 new BigDecimal("29999.00"), new BigDecimal("12.0"), 8, "Brushed Brass & Opal Quartz", "Warm Brass", "80cm Diameter", "80 x 80 x 120 cm", "Modernist", "Gruhu Light", new BigDecimal("5.0"), true,
                 "https://images.unsplash.com/photo-1524484485831-a92ffc0de03f"},

                {catIds[3], subcatIds[7], "Aura Opal Glass Wall Sconce (Pair)",
                 "Pair of sphere-and-stem sconces crafted in solid hand-waxed brass with triplex opal blown glass globes. Suitable for bathroom vanities and hallways.",
                 new BigDecimal("12499.00"), new BigDecimal("10.0"), 18, "Opal Glass & Brass", "Raw Brass", "Pair (2 Units)", "16 x 20 x 32 cm", "Mid-Century", "Gruhu Light", new BigDecimal("4.7"), false,
                 "https://images.unsplash.com/photo-1517991104123-1d56a6e81ed9"},

                {catIds[3], subcatIds[6], "Klint Pleated Flax Cord Pendant",
                 "Traditional Danish origami-inspired pleated shade woven with coarse natural flax fibers on a turned solid oak neck. Soft downward and ambient diffusion.",
                 new BigDecimal("8999.00"), new BigDecimal("0.0"), 20, "Woven Flax & Solid Oak", "Sand Flax", "Medium (45cm)", "45 x 45 x 38 cm", "Nordic", "Gruhu Light", new BigDecimal("4.6"), false,
                 "https://images.unsplash.com/photo-1543198126-a8ad8e47fb22"},

                // ==================== CATEGORY 5: MIRRORS & WALL DECOR (7 Products) ====================
                {catIds[4], subcatIds[8], "Haven Arched Full-Length Mirror",
                 "Monumental floor-standing arched mirror encased in a slim 6mm hand-brushed antique brass trim. High-clarity shatterproof copper-free silver glass with anti-tip wall fixtures.",
                 new BigDecimal("22499.00"), new BigDecimal("10.0"), 15, "Solid Brass & Silvered Glass", "Warm Brass", "Full Length", "190 x 85 x 4 cm", "Scandinavian Modern", "Gruhu Glass", new BigDecimal("4.9"), true,
                 "https://images.unsplash.com/photo-1618220179428-22790b461013"},

                {catIds[4], subcatIds[9], "Pebble Organic Asymmetric Wall Mirror",
                 "Fluid organic river stone silhouette framed in steam-curved solid walnut. Hangs in four different orientations to fluidly match your entryway or vanity.",
                 new BigDecimal("12999.00"), new BigDecimal("0.0"), 20, "Solid Walnut & Glass", "Rich Walnut", "Large", "95 x 65 x 3 cm", "Organic Modern", "Gruhu Glass", new BigDecimal("4.6"), true,
                 "https://images.unsplash.com/photo-1616046229478-9901c5536a45"},

                {catIds[4], subcatIds[9], "Astrid Round Fluted Oak Wall Mirror",
                 "Solid white oak circular frame surrounded by hand-carved radial fluting. Creates architectural depth and bounce-reflects natural morning light across corridors.",
                 new BigDecimal("15499.00"), new BigDecimal("8.0"), 12, "Solid White Oak & Glass", "Natural Oak", "80cm Round", "80 x 80 x 5 cm", "Scandinavian", "Gruhu Glass", new BigDecimal("4.8"), false,
                 "https://images.unsplash.com/photo-1594026112284-02bb6f3352fe"},

                {catIds[4], subcatIds[9], "Linnea Minimalist Brass Pill Mirror",
                 "Clean capsule-shaped silhouette framed in brushed antique brass with a deep shadow reveal. May be mounted vertically over double vanities or horizontally.",
                 new BigDecimal("13999.00"), new BigDecimal("12.0"), 17, "Brushed Brass & Silver Glass", "Aged Brass", "Pill Shape", "110 x 50 x 3 cm", "Warm Minimalist", "Gruhu Glass", new BigDecimal("4.7"), false,
                 "https://images.unsplash.com/photo-1584589167171-541ce45f1eea"},

                {catIds[4], subcatIds[8], "Freja Architectural Standing Timber Mirror",
                 "Easel-style solid oak leaning full-length mirror with integrated rear hanging pegs for scarves, hats, and everyday apparel.",
                 new BigDecimal("24999.00"), new BigDecimal("0.0"), 11, "Solid European Oak", "Natural White Oak", "Oversized", "195 x 90 x 6 cm", "Nordic Craft", "Gruhu Atelier", new BigDecimal("4.9"), true,
                 "https://images.unsplash.com/photo-1616486338812-3dadae4b4ace"},

                {catIds[4], subcatIds[9], "Svea Floating Oak Wall Shelf (Set of 2)",
                 "Solid white oak shelves with completely invisible internal steel rod floating mounts. Features an integrated picture-rail groove for lean-displaying art frames.",
                 new BigDecimal("8499.00"), new BigDecimal("0.0"), 28, "FSC Solid Oak", "Natural Oak", "Pair (90cm)", "90 x 20 x 4 cm", "Scandinavian", "Gruhu Craft", new BigDecimal("4.8"), false,
                 "https://images.unsplash.com/photo-1615066390971-03e4e1c36ddf"},

                {catIds[4], subcatIds[9], "Atelier Textured Sand Relief Canvas",
                 "Original sculptural wall artwork crafted using natural lime plaster, mineral feldgrau pigments, and fine quartz sand on heavy Belgian linen canvas framed in oak.",
                 new BigDecimal("18499.00"), new BigDecimal("15.0"), 10, "Lime Plaster & Belgian Linen", "Chalk & Feldgrau", "Large (100x140)", "100 x 140 x 5 cm", "Tactile Minimalist", "Gruhu Atelier", new BigDecimal("4.9"), false,
                 "https://images.unsplash.com/photo-1579783902614-a3fb3927b675"},

                // ==================== CATEGORY 6: CURTAINS & TEXTILES (7 Products) ====================
                {catIds[5], subcatIds[10], "Dune Pure Belgian Linen Curtains (Pair)",
                 "Woven in Flanders from 100% long-staple flax. Pre-washed for decadent softness and relaxed drape. Features dual-purpose header for rod pocket or ring hook styling.",
                 new BigDecimal("13999.00"), new BigDecimal("10.0"), 40, "100% Pure Flax Linen", "Oatmeal Neutral", "Pair (2 Panels)", "140 x 270 cm each", "Relaxed Luxury", "Gruhu Textile", new BigDecimal("4.9"), true,
                 "https://images.unsplash.com/photo-1513694203232-719a280e022f"},

                {catIds[5], subcatIds[11], "Niva Textured New Zealand Wool Rug",
                 "Plush 25mm high-pile rug hand-knotted by master artisans using un-dyed New Zealand wool. Features subtle organic line etchings with raw braided fringe tassels.",
                 new BigDecimal("29999.00"), new BigDecimal("15.0"), 16, "100% Pure New Zealand Wool", "Cream / Charcoal Lines", "8 x 10 ft", "240 x 300 cm", "Nordic Cozy", "Gruhu Textile", new BigDecimal("5.0"), true,
                 "https://images.unsplash.com/photo-1600121848594-d8644e57abab"},

                {catIds[5], subcatIds[11], "Kattegat Braided Jute Area Rug",
                 "Heavyweight natural golden jute hand-braided and stitched with organic cotton thread. Delivers earthy acoustic grounding, natural durability, and rich texture.",
                 new BigDecimal("16999.00"), new BigDecimal("0.0"), 22, "100% Organic Golden Jute", "Natural Raw Jute", "6 x 9 ft", "180 x 270 cm", "Organic Modern", "Gruhu Textile", new BigDecimal("4.8"), false,
                 "https://images.unsplash.com/photo-1579656381226-5fc0f0100c3b"},

                {catIds[5], subcatIds[10], "Skye Blackout Heavy Linen Drapery",
                 "Stonewashed 380 GSM Belgian flax lined with a 100% thermal blackout backing that blocks harsh sun glare while draping in elegant sculptural folds.",
                 new BigDecimal("16499.00"), new BigDecimal("12.0"), 19, "Belgian Flax & Thermal Lining", "Feldgrau Moss", "Pair (2 Panels)", "140 x 280 cm each", "Architectural", "Gruhu Textile", new BigDecimal("4.9"), true,
                 "https://images.unsplash.com/photo-1584100936595-c0654b55a2e2"},

                {catIds[5], subcatIds[11], "Faro Hand-Woven Geometric Flatweave Rug",
                 "Reversible wool-cotton flatweave carpet showcasing understated Scandinavian architectural line work. Thin profile fits seamlessly under swinging doors.",
                 new BigDecimal("21999.00"), new BigDecimal("10.0"), 14, "80% Wool / 20% Cotton", "Feldgrau Slate & Cream", "8 x 10 ft", "240 x 300 cm", "Geometric Minimalist", "Gruhu Textile", new BigDecimal("4.8"), false,
                 "https://images.unsplash.com/photo-1600585154340-be6161a56a0c"},

                {catIds[5], subcatIds[11], "Gotland Chunky Waffle Alpaca Throw",
                 "Spun from hypoallergenic Peruvian baby alpaca fleece and organic cotton in a deep tactile waffle weave. Incredibly cozy yet light and breathable.",
                 new BigDecimal("8499.00"), new BigDecimal("0.0"), 35, "Baby Alpaca & Organic Cotton", "Heather Sage", "Throw Blanket", "150 x 200 cm", "Hyggelig", "Gruhu Textile", new BigDecimal("4.9"), false,
                 "https://images.unsplash.com/photo-1583847268964-b28dc8f51f92"},

                {catIds[5], subcatIds[11], "Nordic Boucle Bolster & Cushion Set",
                 "Set of three architectural accent cushions (1 cylindrical bolster and 2 square cushions) in rich textured wool boucle with feather-down inserts.",
                 new BigDecimal("6999.00"), new BigDecimal("0.0"), 25, "Italian Wool Boucle & Feather Fill", "Warm Oat & Feldgrau", "Set of 3", "Various Sizes", "Scandinavian", "Gruhu Textile", new BigDecimal("4.8"), false,
                 "https://images.unsplash.com/photo-1584100936595-c0654b55a2e2"}
            };

            String prodSql = "INSERT INTO products (category_id, subcategory_id, product_name, description, price, " +
                    "discount_percent, stock_quantity, material, color, size, dimensions, style, brand, rating, " +
                    "is_featured, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'ACTIVE', NOW(), NOW())";

            String imgSql = "INSERT INTO product_images (product_id, image_path, is_primary, created_at) VALUES (?, ?, ?, NOW())";

            int totalProducts = 0;
            int totalImages = 0;

            for (Object[] p : products) {
                int prodId = 0;
                try (PreparedStatement pstmt = conn.prepareStatement(prodSql, Statement.RETURN_GENERATED_KEYS)) {
                    pstmt.setInt(1, (Integer) p[0]);
                    pstmt.setInt(2, (Integer) p[1]);
                    pstmt.setString(3, (String) p[2]);
                    pstmt.setString(4, (String) p[3]);
                    pstmt.setBigDecimal(5, (BigDecimal) p[4]);
                    pstmt.setBigDecimal(6, (BigDecimal) p[5]);
                    pstmt.setInt(7, (Integer) p[6]);
                    pstmt.setString(8, (String) p[7]);
                    pstmt.setString(9, (String) p[8]);
                    pstmt.setString(10, (String) p[9]);
                    pstmt.setString(11, (String) p[10]);
                    pstmt.setString(12, (String) p[11]);
                    pstmt.setString(13, (String) p[12]);
                    pstmt.setBigDecimal(14, (BigDecimal) p[13]);
                    pstmt.setBoolean(15, (Boolean) p[14]);
                    pstmt.executeUpdate();
                    ResultSet keys = pstmt.getGeneratedKeys();
                    if (keys.next()) prodId = keys.getInt(1);
                }

                if (prodId > 0) {
                    totalProducts++;
                    String basePhoto = (String) p[15];

                    // Generate 5 strictly coordinated photographic views of the EXACT SAME product in the EXACT SAME color
                    // View 1: Primary Studio Full Object
                    // View 2: Frontal Silhouette Elevation (1.35x zoom)
                    // View 3: Macro Texture & Material Close-Up (2.20x zoom)
                    // View 4: Joinery, Base & Craft Detail (1.80x zoom)
                    // View 5: Ambient In-Situ Spatial Profile (1.18x view)
                    String[] views = {
                        basePhoto + "?auto=format&fit=crop&w=1200&h=850&q=85",
                        basePhoto + "?auto=format&fit=crop&w=1200&h=850&crop=focalpoint&fp-x=0.50&fp-y=0.50&fp-z=1.35&q=85",
                        basePhoto + "?auto=format&fit=crop&w=1200&h=850&crop=focalpoint&fp-x=0.48&fp-y=0.48&fp-z=2.20&q=85",
                        basePhoto + "?auto=format&fit=crop&w=1200&h=850&crop=focalpoint&fp-x=0.55&fp-y=0.62&fp-z=1.80&q=85",
                        basePhoto + "?auto=format&fit=crop&w=1200&h=850&crop=focalpoint&fp-x=0.42&fp-y=0.44&fp-z=1.18&q=85"
                    };

                    for (int v = 0; v < views.length; v++) {
                        try (PreparedStatement ipstmt = conn.prepareStatement(imgSql)) {
                            ipstmt.setInt(1, prodId);
                            ipstmt.setString(2, views[v]);
                            ipstmt.setBoolean(3, (v == 0)); // View 1 is primary
                            ipstmt.executeUpdate();
                            totalImages++;
                        }
                    }
                }
            }

            System.out.println("Successfully seeded " + totalProducts + " products!");
            System.out.println("Successfully seeded " + totalImages + " coordinated product images (exactly 5 same-color views per product)!");

            conn.commit();
            System.out.println("==========================================================");
            System.out.println("Gruhu Database Seeding Complete & Committed Successfully!");
            System.out.println("==========================================================");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
