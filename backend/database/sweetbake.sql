-- Database: sweetbake
-- Sistem Informasi Penjualan Kue

CREATE DATABASE IF NOT EXISTS sweetbake;
USE sweetbake;

-- Tabel Users (Admin & Customer)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('admin', 'customer') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabel Categories
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Products (Kue)
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    image_url VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Tabel Shipping Costs
CREATE TABLE shipping_costs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    estimated_days INT DEFAULT 3,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabel Orders
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    shipping_cost DECIMAL(10,2) DEFAULT 0,
    shipping_address TEXT NOT NULL,
    shipping_city VARCHAR(100),
    status ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    payment_status ENUM('unpaid', 'paid') DEFAULT 'unpaid',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabel Order Items
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Tabel Order Tracking
CREATE TABLE order_tracking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Insert Default Admin
INSERT INTO users (name, email, password, role) VALUES 
('Admin SweetBake', 'admin@sweetbake.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');
-- Password: password (hashed dengan bcrypt)

-- Insert Sample Categories
INSERT INTO categories (name, description) VALUES 
('Kue Ulang Tahun', 'Kue untuk perayaan ulang tahun'),
('Kue Tradisional', 'Kue-kue tradisional Indonesia'),
('Kue Kering', 'Aneka kue kering untuk lebaran dan acara'),
('Roti & Pastry', 'Roti dan pastry segar'),
('Kue Custom', 'Kue pesanan khusus sesuai keinginan');

-- Insert Sample Products
INSERT INTO products (category_id, name, description, price, stock, image_url) VALUES 
(1, 'Kue Ulang Tahun Coklat', 'Kue ulang tahun dengan lapisan coklat lembut dan krim mentega', 250000, 10, 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=800&q=80'),
(1, 'Kue Ulang Tahun Red Velvet', 'Kue red velvet dengan cream cheese frosting', 280000, 8, 'https://images.unsplash.com/photo-1616541823729-00fe0aacd32c?auto=format&fit=crop&w=800&q=80'),
(1, 'Kue Ulang Tahun Vanilla Fruit', 'Kue vanilla lembut dengan topping buah-buahan segar', 300000, 5, 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?auto=format&fit=crop&w=800&q=80'),
(2, 'Klepon', 'Kue klepon isi gula merah dengan kelapa parut', 35000, 50, 'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=800&q=80'),
(2, 'Lemper', 'Lemper ayam dengan ketan gurih', 40000, 40, 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?auto=format&fit=crop&w=800&q=80'),
(2, 'Kue Lapis', 'Kue lapis legit manis dengan tekstur kenyal', 45000, 30, 'https://images.unsplash.com/photo-1600289031464-74d374b64991?auto=format&fit=crop&w=800&q=80'),
(2, 'Dadar Gulung', 'Dadar gulung hijau isi unti kelapa manis', 30000, 45, 'https://images.unsplash.com/photo-1590080874088-eec64895b423?auto=format&fit=crop&w=800&q=80'),
(3, 'Nastar Premium', 'Kue nastar dengan selai nanas pilihan', 75000, 30, 'https://images.unsplash.com/photo-1509365465985-25d11c17e812?auto=format&fit=crop&w=800&q=80'),
(3, 'Kastengel Keju', 'Kue kastengel dengan keju edam asli', 85000, 25, 'https://images.unsplash.com/photo-1605807646983-377bc5a76493?auto=format&fit=crop&w=800&q=80'),
(3, 'Putri Salju', 'Kue kering bertabur gula halus lumer di mulut', 70000, 35, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=800&q=80'),
(3, 'Lidah Kucing', 'Kue lidah kucing renyah dan gurih', 65000, 40, 'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?auto=format&fit=crop&w=800&q=80'),
(4, 'Croissant Butter', 'Croissant dengan butter premium', 25000, 20, 'https://images.unsplash.com/photo-1555507036-ab1f40ce88cb?auto=format&fit=crop&w=800&q=80'),
(4, 'Roti Sobek Coklat', 'Roti sobek lembut dengan isian coklat', 45000, 15, 'https://images.unsplash.com/photo-1598373182133-52452f7691ef?auto=format&fit=crop&w=800&q=80'),
(4, 'Cinnamon Roll', 'Roti gulung kayu manis dengan cream cheese', 30000, 25, 'https://images.unsplash.com/photo-1550617931-e17a7b70dce2?auto=format&fit=crop&w=800&q=80'),
(4, 'Baguette', 'Roti Prancis panjang yang renyah di luar', 20000, 15, 'https://images.unsplash.com/photo-1586444248902-2f64eddc13bf?auto=format&fit=crop&w=800&q=80'),
(5, 'Wedding Cake 3 Tiers', 'Kue pengantin 3 tingkat desain elegan', 1500000, 2, 'https://images.unsplash.com/photo-1535254973040-607b474cb50d?auto=format&fit=crop&w=800&q=80'),
(5, 'Custom Character Cake', 'Kue ulang tahun desain karakter kartun', 400000, 5, 'https://images.unsplash.com/photo-1562777717-b6aff340f171?auto=format&fit=crop&w=800&q=80'),
(5, 'Cupcake Set Custom', 'Set 12 cupcake dengan desain sesuai tema', 200000, 10, 'https://images.unsplash.com/photo-1587668178277-295251f900ce?auto=format&fit=crop&w=800&q=80');

-- Insert Sample Shipping Costs
INSERT INTO shipping_costs (city, cost, estimated_days) VALUES 
('Jakarta', 15000, 1),
('Bandung', 20000, 2),
('Surabaya', 25000, 3),
('Yogyakarta', 22000, 2),
('Semarang', 23000, 3),
('Medan', 35000, 4),
('Makassar', 40000, 5),
('Bali', 30000, 3);
