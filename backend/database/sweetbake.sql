-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 19, 2026 at 06:45 AM
-- Server version: 8.0.30
-- PHP Version: 8.4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sweetbake`
--

-- --------------------------------------------------------

--
-- Table structure for table `bundles`
--

CREATE TABLE `bundles` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `original_price` decimal(10,2) NOT NULL,
  `promo_price` decimal(10,2) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bundles`
--

INSERT INTO `bundles` (`id`, `name`, `description`, `original_price`, `promo_price`, `image_url`, `is_available`, `created_at`, `updated_at`) VALUES
(1, 'Paket Hemat Lebaran', 'Paket spesial untuk merayakan Lebaran dengan berbagai kue kering favorit', 250000.00, 199000.00, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=800&q=80', 1, '2026-05-19 06:18:59', '2026-05-19 06:18:59'),
(2, 'Paket Ulang Tahun Anak', 'Paket lengkap untuk pesta ulang tahun anak dengan kue dan cupcakes', 350000.00, 299000.00, 'https://images.unsplash.com/photo-1587668178277-295251f900ce?auto=format&fit=crop&w=800&q=80', 1, '2026-05-19 06:18:59', '2026-05-19 06:18:59'),
(3, 'Paket Arisan Keluarga', 'Paket ekonomis untuk acara arisan dengan berbagai kue tradisional', 180000.00, 149000.00, 'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?auto=format&fit=crop&w=800&q=80', 1, '2026-05-19 06:18:59', '2026-05-19 06:18:59'),
(4, 'Paket Premium Wedding', 'Paket mewah untuk acara pernikahan dengan kue pengantin dan dessert box', 500000.00, 449000.00, 'https://images.unsplash.com/photo-1535254973040-607b474cb50d?auto=format&fit=crop&w=800&q=80', 1, '2026-05-19 06:18:59', '2026-05-19 06:18:59');

-- --------------------------------------------------------

--
-- Table structure for table `bundle_items`
--

CREATE TABLE `bundle_items` (
  `id` int NOT NULL,
  `bundle_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'Kue Ulang Tahun', 'Kue untuk perayaan ulang tahun', '2026-05-11 22:04:25'),
(2, 'Kue Tradisional', 'Kue-kue tradisional Indonesia', '2026-05-11 22:04:25'),
(3, 'Kue Kering', 'Aneka kue kering untuk lebaran dan acara', '2026-05-11 22:04:25'),
(4, 'Roti & Pastry', 'Roti dan pastry segar', '2026-05-11 22:04:25'),
(5, 'Kue Custom', 'Kue pesanan khusus sesuai keinginan', '2026-05-11 22:04:25');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int NOT NULL,
  `customer_id` int NOT NULL,
  `order_number` varchar(50) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `shipping_cost` decimal(10,2) DEFAULT '0.00',
  `shipping_address` text NOT NULL,
  `shipping_city` varchar(100) DEFAULT NULL,
  `status` enum('pending','confirmed','processing','shipped','delivered','cancelled') DEFAULT 'pending',
  `payment_status` enum('unpaid','paid') DEFAULT 'unpaid',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customer_id`, `order_number`, `total_amount`, `shipping_cost`, `shipping_address`, `shipping_city`, `status`, `payment_status`, `notes`, `created_at`, `updated_at`) VALUES
(1, 2, 'SB202605111767', 280000.00, 20000.00, 'qwerty', 'Bandung', 'shipped', 'unpaid', '', '2026-05-11 23:15:24', '2026-05-12 07:55:01'),
(2, 3, 'SB202605123787', 250000.00, 15000.00, 'jl slamet', 'Jakarta', 'pending', 'unpaid', '\n', '2026-05-12 09:08:15', '2026-05-12 09:08:15'),
(3, 2, 'SB202605126660', 280000.00, 15000.00, 'qwerty', 'Jakarta', 'pending', 'unpaid', '', '2026-05-12 09:08:50', '2026-05-12 09:08:50'),
(4, 3, 'SB202605127753', 45000.00, 40000.00, 'jl. slamet gg rinjani no.3A, panggung', 'Makassar', 'processing', 'unpaid', '', '2026-05-12 09:09:26', '2026-05-12 09:16:43');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int NOT NULL,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`, `subtotal`) VALUES
(1, 1, 2, 1, 280000.00, 280000.00),
(2, 2, 1, 1, 250000.00, 250000.00),
(3, 3, 2, 1, 280000.00, 280000.00),
(4, 4, 6, 1, 45000.00, 45000.00);

-- --------------------------------------------------------

--
-- Table structure for table `order_tracking`
--

CREATE TABLE `order_tracking` (
  `id` int NOT NULL,
  `order_id` int NOT NULL,
  `status` varchar(50) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `order_tracking`
--

INSERT INTO `order_tracking` (`id`, `order_id`, `status`, `description`, `created_at`) VALUES
(1, 1, 'pending', 'Pesanan dibuat', '2026-05-11 23:15:24'),
(2, 1, 'shipped', 'sedang dalam perjalanan', '2026-05-12 07:55:01'),
(3, 2, 'pending', 'Pesanan dibuat', '2026-05-12 09:08:15'),
(4, 3, 'pending', 'Pesanan dibuat', '2026-05-12 09:08:50'),
(5, 4, 'pending', 'Pesanan dibuat', '2026-05-12 09:09:26'),
(6, 4, 'processing', '', '2026-05-12 09:16:43');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock` int DEFAULT '0',
  `image_url` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `description`, `price`, `stock`, `image_url`, `is_available`, `created_at`, `updated_at`) VALUES
(1, 1, 'Kue Ulang Tahun Coklat', 'Kue ulang tahun dengan lapisan coklat lembut dan krim mentega', 250000.00, 9, 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 09:08:15'),
(2, 1, 'Kue Ulang Tahun Red Velvet', 'Kue red velvet dengan cream cheese frosting', 280000.00, 7, 'https://images.unsplash.com/photo-1616541823729-00fe0aacd32c?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 09:08:50'),
(3, 1, 'Kue Ulang Tahun Vanilla Fruit', 'Kue vanilla lembut dengan topping buah-buahan segar', 300000.00, 5, 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33'),
(4, 2, 'Klepon', 'Kue klepon isi gula merah dengan kelapa parut', 35000.00, 50, 'http://10.0.2.2/sweetbake/backend/images/klepon_hd.png', 1, '2026-05-12 07:10:38', '2026-05-12 09:14:10'),
(5, 2, 'Lemper', 'Lemper ayam dengan ketan gurih', 40000.00, 40, 'http://10.0.2.2/sweetbake/backend/images/lemper_hd.png', 1, '2026-05-12 07:10:38', '2026-05-12 09:14:30'),
(6, 2, 'Kue Lapis', 'Kue lapis legit manis dengan tekstur kenyal', 45000.00, 29, 'https://images.unsplash.com/photo-1600289031464-74d374b64991?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 09:09:26'),
(7, 2, 'Dadar Gulung', 'Dadar gulung hijau isi unti kelapa manis', 30000.00, 45, 'https://images.unsplash.com/photo-1590080874088-eec64895b423?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33'),
(8, 3, 'Nastar Premium', 'Kue nastar dengan selai nanas pilihan', 75000.00, 30, 'https://images.unsplash.com/photo-1509365465985-25d11c17e812?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33'),
(9, 3, 'Kastengel Keju', 'Kue kastengel dengan keju edam asli', 85000.00, 25, 'https://images.unsplash.com/photo-1605807646983-377bc5a76493?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33'),
(10, 3, 'Putri Salju', 'Kue kering bertabur gula halus lumer di mulut', 70000.00, 35, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33'),
(11, 3, 'Lidah Kucing', 'Kue lidah kucing renyah dan gurih', 65000.00, 40, 'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33'),
(12, 4, 'Croissant Butter', 'Croissant dengan butter premium', 25000.00, 20, 'http://10.0.2.2/sweetbake/backend/images/croissant_hd.png', 1, '2026-05-12 07:10:38', '2026-05-12 09:14:49'),
(13, 4, 'Roti Sobek Coklat', 'Roti sobek lembut dengan isian coklat', 45000.00, 15, 'https://images.unsplash.com/photo-1598373182133-52452f7691ef?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33'),
(14, 4, 'Cinnamon Roll', 'Roti gulung kayu manis dengan cream cheese', 30000.00, 25, 'https://images.unsplash.com/photo-1550617931-e17a7b70dce2?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33'),
(15, 4, 'Baguette', 'Roti Prancis panjang yang renyah di luar', 20000.00, 15, 'http://10.0.2.2/sweetbake/backend/images/baguette_hd.png', 1, '2026-05-12 07:10:38', '2026-05-12 09:15:13'),
(16, 5, 'Wedding Cake 3 Tiers', 'Kue pengantin 3 tingkat desain elegan', 1500000.00, 2, 'https://images.unsplash.com/photo-1535254973040-607b474cb50d?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33'),
(17, 5, 'Custom Character Cake', 'Kue ulang tahun desain karakter kartun', 400000.00, 5, 'http://10.0.2.2/sweetbake/backend/images/character_cake_hd.png', 1, '2026-05-12 07:10:38', '2026-05-12 09:15:28'),
(18, 5, 'Cupcake Set Custom', 'Set 12 cupcake dengan desain sesuai tema', 200000.00, 10, 'https://images.unsplash.com/photo-1587668178277-295251f900ce?auto=format&fit=crop&w=800&q=80', 1, '2026-05-12 07:10:38', '2026-05-12 07:36:33');

-- --------------------------------------------------------

--
-- Table structure for table `shipping_costs`
--

CREATE TABLE `shipping_costs` (
  `id` int NOT NULL,
  `city` varchar(100) NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  `estimated_days` int DEFAULT '3',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `shipping_costs`
--

INSERT INTO `shipping_costs` (`id`, `city`, `cost`, `estimated_days`, `created_at`, `updated_at`) VALUES
(1, 'Jakarta', 15000.00, 1, '2026-05-11 22:04:25', '2026-05-11 22:04:25'),
(2, 'Bandung', 20000.00, 2, '2026-05-11 22:04:25', '2026-05-11 22:04:25'),
(3, 'Surabaya', 25000.00, 3, '2026-05-11 22:04:25', '2026-05-11 22:04:25'),
(4, 'Yogyakarta', 22000.00, 2, '2026-05-11 22:04:25', '2026-05-11 22:04:25'),
(5, 'Semarang', 23000.00, 3, '2026-05-11 22:04:25', '2026-05-11 22:04:25'),
(6, 'Medan', 35000.00, 4, '2026-05-11 22:04:25', '2026-05-11 22:04:25'),
(7, 'Makassar', 40000.00, 5, '2026-05-11 22:04:25', '2026-05-11 22:04:25'),
(8, 'Bali', 30000.00, 3, '2026-05-11 22:04:25', '2026-05-11 22:04:25'),
(9, 'Tegal', 10000.00, 1, '2026-05-12 09:22:24', '2026-05-12 09:23:49');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `role` enum('admin','customer') DEFAULT 'customer',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `address`, `role`, `created_at`, `updated_at`) VALUES
(1, 'Admin SweetBake', 'admin@sweetbake.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NULL, 'admin', '2026-05-11 22:04:24', '2026-05-11 22:04:24'),
(2, 'bobby', 'bobby@gmail.com', '$2y$12$BvWsPh/EGXJY2.qmXxB/vOtDV3gNd/p7dNJPeror863wrnexc3si6', '12345', 'qwerty', 'customer', '2026-05-11 22:28:07', '2026-05-11 22:28:07'),
(3, 'linda cantik', 'lindacantikbgt@gmail.com', '$2y$12$1Du5CWWJa5SzV7gjrknuEeo696pQJd0ChuGHLjicMI6wQjVbbKEHe', '089637619541', 'jl. slamet gg rinjani no.3A, panggung', 'customer', '2026-05-12 09:06:23', '2026-05-12 09:06:23');

-- --------------------------------------------------------

--
-- Table structure for table `wishlists`
--

CREATE TABLE `wishlists` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bundles`
--
ALTER TABLE `bundles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bundle_items`
--
ALTER TABLE `bundle_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bundle_id` (`bundle_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `order_tracking`
--
ALTER TABLE `order_tracking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `shipping_costs`
--
ALTER TABLE `shipping_costs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_wishlist` (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bundles`
--
ALTER TABLE `bundles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `bundle_items`
--
ALTER TABLE `bundle_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `order_tracking`
--
ALTER TABLE `order_tracking`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `shipping_costs`
--
ALTER TABLE `shipping_costs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bundle_items`
--
ALTER TABLE `bundle_items`
  ADD CONSTRAINT `bundle_items_ibfk_1` FOREIGN KEY (`bundle_id`) REFERENCES `bundles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bundle_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_tracking`
--
ALTER TABLE `order_tracking`
  ADD CONSTRAINT `order_tracking_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
