USE home_interior_db;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product_reviews;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS subcategories;
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    category_image VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE subcategories (
    subcategory_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    subcategory_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    subcategory_id INT,
    product_name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount_percent DECIMAL(5,2) DEFAULT 0.00,
    stock_quantity INT NOT NULL DEFAULT 10,
    material VARCHAR(100),
    color VARCHAR(50),
    size VARCHAR(100),
    dimensions VARCHAR(100),
    style VARCHAR(100),
    brand VARCHAR(100) DEFAULT 'Gruhu Atelier',
    rating DECIMAL(2,1) DEFAULT 4.9,
    is_featured BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    rooms VARCHAR(120) DEFAULT 'living_room,hall',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(subcategory_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE product_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_path VARCHAR(500) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 1,
    view_type VARCHAR(50) DEFAULT 'Studio Full View',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_customer_product (customer_id, product_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    shipping_fee DECIMAL(10,2) DEFAULT 0.00,
    final_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) DEFAULT 'PROCESSING',
    payment_status VARCHAR(30) DEFAULT 'PAID',
    payment_method VARCHAR(50) DEFAULT 'Credit Card / UPI',
    shipping_address_id INT,
    tracking_number VARCHAR(100),
    order_notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
INSERT INTO categories (category_id, category_name, description, image_url, category_image, is_active, status) VALUES
(1, 'Furniture', 'Architectural sofas, lounge chairs, solid wood platform beds, dining ensembles and storage', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80', TRUE, 'ACTIVE'),
(2, 'Lights', 'Minimalist Scandinavian floor lamps, ceramic table lamps, brass wall sconces and washi paper pendants', 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80', TRUE, 'ACTIVE'),
(3, 'Mirrors', 'Beveled solid oak round mirrors, brass vanity rectangles, and monumental cathedral arch full length mirrors', 'https://images.unsplash.com/photo-1618220179428-22790b461013?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1618220179428-22790b461013?auto=format&fit=crop&w=800&q=80', TRUE, 'ACTIVE'),
(4, 'Accessories', 'Mindful interior accents: minimal wall clocks, tactile plaster relief art, stoneware vases and solid brass candle stands', 'https://images.unsplash.com/photo-1581783342308-f792dbdd27c5?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1581783342308-f792dbdd27c5?auto=format&fit=crop&w=800&q=80', TRUE, 'ACTIVE');

INSERT INTO subcategories (subcategory_id, category_id, subcategory_name, description) VALUES
(1, 1, 'Sofas', 'Two-seater, three-seater, and 4-seater modular sectionals'),
(2, 1, 'Chairs', 'Armchairs, bar stools, office chairs, dining chairs, and folding chairs'),
(3, 1, 'Beds', 'Solid white oak platform beds, upholstered frames, and cane headboards'),
(4, 1, 'Tables', 'Coffee tables, dining tables, side tables, and office work tables'),
(5, 1, 'Storage', 'Fluted oak sideboards, soft-close drawers, and architectural chests'),
(6, 2, 'Floor Lamps', 'Architectural brass floor luminaires and tripod light sculptures'),
(7, 2, 'Table Lamps', 'Ceramic, alabaster, travertine, and cordless rechargeable accent lamps'),
(8, 2, 'Wall Lamps', 'Opal glass sconces, articulated swing arms, and backlit wall discs'),
(9, 2, 'Ceiling Lamps', 'Washi paper lantern pendants and geometric chandeliers'),
(10, 3, 'Round Mirrors', 'Solid oak beveled round mirrors and razor-thin brass wall circles'),
(11, 3, 'Rectangle Mirrors', 'Mitered timber frames, antique bronze rims, and shadowbox vanity mirrors'),
(12, 3, 'Full Length Mirrors', 'Cathedral arch full-length standing mirrors and free-standing timber frames'),
(13, 4, 'Wall Clocks', 'Minimalist solid oak, brushed brass, slate, and terrazzo silent sweep clocks'),
(14, 4, 'Wall Paintings', 'Textured mineral canvas paintings and tactile gesso plaster reliefs'),
(15, 4, 'Vases', 'Unglazed stoneware amphoras, fluted glass silhouettes, and ikebana vessels'),
(16, 4, 'Candle Stands', 'Solid cast brass sculptural candelabras and turned smoked oak pillar stands');
