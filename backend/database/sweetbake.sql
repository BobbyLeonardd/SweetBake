-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: sweetbake
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` text,
  `phone` varchar(20) DEFAULT NULL,
  `delivery_cost` decimal(10,2) NOT NULL DEFAULT '0.00',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'Cabang Pusat','Jl. Utama No. 1, Jakarta','021-1234567',15000.00,1,'2026-05-25 14:27:26'),(2,'Cabang Selatan','Jl. Raya Selatan No. 5, Jakarta Selatan','021-7654321',20000.00,1,'2026-05-25 14:27:26'),(3,'Cabang Timur','Jl. Timur Raya No. 10, Jakarta Timur','021-9876543',18000.00,1,'2026-05-25 14:27:26');
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bundle_items`
--

DROP TABLE IF EXISTS `bundle_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bundle_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bundle_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `bundle_id` (`bundle_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `bundle_items_ibfk_1` FOREIGN KEY (`bundle_id`) REFERENCES `bundles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bundle_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bundle_items`
--

LOCK TABLES `bundle_items` WRITE;
/*!40000 ALTER TABLE `bundle_items` DISABLE KEYS */;
INSERT INTO `bundle_items` VALUES (1,1,9,1,'2026-05-25 14:09:06'),(2,1,11,1,'2026-05-25 14:09:26'),(3,1,10,1,'2026-05-25 14:09:40');
/*!40000 ALTER TABLE `bundle_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bundles`
--

DROP TABLE IF EXISTS `bundles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bundles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `original_price` decimal(10,2) NOT NULL,
  `promo_price` decimal(10,2) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bundles`
--

LOCK TABLES `bundles` WRITE;
/*!40000 ALTER TABLE `bundles` DISABLE KEYS */;
INSERT INTO `bundles` VALUES (1,'Paket Hemat Lebaran','Paket spesial untuk merayakan Lebaran dengan berbagai kue kering favorit',250000.00,199000.00,'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=800&q=80',1,'2026-05-19 06:18:59','2026-05-19 07:52:41'),(2,'Paket Ulang Tahun Anak','Paket lengkap untuk pesta ulang tahun anak dengan kue dan cupcakes',350000.00,299000.00,'https://images.unsplash.com/photo-1587668178277-295251f900ce?auto=format&fit=crop&w=800&q=80',1,'2026-05-19 06:18:59','2026-05-19 07:52:41'),(3,'Paket Arisan Keluarga','Paket ekonomis untuk acara arisan dengan berbagai kue tradisional',180000.00,149000.00,'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?auto=format&fit=crop&w=800&q=80',1,'2026-05-19 06:18:59','2026-05-19 07:52:41'),(4,'Paket Premium Wedding','Paket mewah untuk acara pernikahan dengan kue pengantin dan dessert box',500000.00,449000.00,'https://images.unsplash.com/photo-1535254973040-607b474cb50d?auto=format&fit=crop&w=800&q=80',1,'2026-05-19 06:18:59','2026-05-19 07:52:41');
/*!40000 ALTER TABLE `bundles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Kue Ulang Tahun','Kue untuk perayaan ulang tahun','2026-05-11 22:04:25'),(2,'Kue Tradisional','Kue-kue tradisional Indonesia','2026-05-11 22:04:25'),(3,'Kue Kering','Aneka kue kering untuk lebaran dan acara','2026-05-11 22:04:25'),(4,'Roti & Pastry','Roti dan pastry segar','2026-05-11 22:04:25'),(5,'Kue Custom','Kue pesanan khusus sesuai keinginan','2026-05-11 22:04:25');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (2,2,1,1,250000.00,250000.00),(4,4,6,1,45000.00,45000.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_tracking`
--

DROP TABLE IF EXISTS `order_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_tracking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `status` varchar(50) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `order_tracking_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_tracking`
--

LOCK TABLES `order_tracking` WRITE;
/*!40000 ALTER TABLE `order_tracking` DISABLE KEYS */;
INSERT INTO `order_tracking` VALUES (3,2,'pending','Pesanan dibuat','2026-05-12 09:08:15'),(5,4,'pending','Pesanan dibuat','2026-05-12 09:09:26'),(6,4,'processing','','2026-05-12 09:16:43');
/*!40000 ALTER TABLE `order_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `order_number` varchar(50) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `shipping_cost` decimal(10,2) DEFAULT '0.00',
  `shipping_address` text NOT NULL,
  `shipping_city` varchar(100) DEFAULT NULL,
  `branch_id` int DEFAULT NULL,
  `branch_name` varchar(100) DEFAULT NULL,
  `delivery_method` varchar(20) NOT NULL DEFAULT 'delivery',
  `payment_method` varchar(50) NOT NULL DEFAULT 'cash',
  `status` enum('pending','confirmed','processing','shipped','delivered','cancelled') DEFAULT 'pending',
  `payment_status` enum('unpaid','paid') DEFAULT 'unpaid',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (2,3,'SB202605123787',250000.00,15000.00,'jl slamet','Jakarta',NULL,NULL,'delivery','pending','unpaid','\n','2026-05-12 09:08:15','2026-05-12 09:08:15'),(4,3,'SB202605127753',45000.00,40000.00,'jl. slamet gg rinjani no.3A, panggung','Makassar',NULL,NULL,'delivery','processing','unpaid','','2026-05-12 09:09:26','2026-05-12 09:16:43');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock` int DEFAULT '0',
  `image_url` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Kue Ulang Tahun Coklat','Kue ulang tahun dengan lapisan coklat lembut dan krim mentega',250000.00,9,'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 09:08:15'),(2,1,'Kue Ulang Tahun Red Velvet','Kue red velvet dengan cream cheese frosting',280000.00,7,'https://images.unsplash.com/photo-1616541823729-00fe0aacd32c?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 09:08:50'),(3,1,'Kue Ulang Tahun Vanilla Fruit','Kue vanilla lembut dengan topping buah-buahan segar',300000.00,5,'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33'),(4,2,'Klepon','Kue klepon isi gula merah dengan kelapa parut',35000.00,50,'https://images.unsplash.com/photo-1631188622990-0e6e0e8f7d12?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 09:14:10'),(5,2,'Lemper','Lemper ayam dengan ketan gurih',40000.00,40,'https://images.unsplash.com/photo-1562802378-063ec186a863?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 09:14:30'),(6,2,'Kue Lapis','Kue lapis legit manis dengan tekstur kenyal',45000.00,29,'https://images.unsplash.com/photo-1600289031464-74d374b64991?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 09:09:26'),(7,2,'Dadar Gulung','Dadar gulung hijau isi unti kelapa manis',30000.00,45,'https://images.unsplash.com/photo-1590080874088-eec64895b423?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33'),(8,3,'Nastar Premium','Kue nastar dengan selai nanas pilihan',75000.00,30,'https://images.unsplash.com/photo-1509365465985-25d11c17e812?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33'),(9,3,'Kastengel Keju','Kue kastengel dengan keju edam asli',85000.00,25,'https://images.unsplash.com/photo-1605807646983-377bc5a76493?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33'),(10,3,'Putri Salju','Kue kering bertabur gula halus lumer di mulut',70000.00,35,'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33'),(11,3,'Lidah Kucing','Kue lidah kucing renyah dan gurih',65000.00,40,'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33'),(12,4,'Croissant Butter','Croissant dengan butter premium',25000.00,20,'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 09:14:49'),(13,4,'Roti Sobek Coklat','Roti sobek lembut dengan isian coklat',45000.00,15,'https://images.unsplash.com/photo-1598373182133-52452f7691ef?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33'),(14,4,'Cinnamon Roll','Roti gulung kayu manis dengan cream cheese',30000.00,25,'https://images.unsplash.com/photo-1550617931-e17a7b70dce2?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33'),(15,4,'Baguette','Roti Prancis panjang yang renyah di luar',20000.00,15,'https://images.unsplash.com/photo-1568471173242-461f0a730452?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 09:15:13'),(16,5,'Wedding Cake 3 Tiers','Kue pengantin 3 tingkat desain elegan',1500000.00,2,'https://images.unsplash.com/photo-1535254973040-607b474cb50d?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33'),(17,5,'Custom Character Cake','Kue ulang tahun desain karakter kartun',400000.00,5,'https://images.unsplash.com/photo-1542826438-bd32f43d626f?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 09:15:28'),(18,5,'Cupcake Set Custom','Set 12 cupcake dengan desain sesuai tema',200000.00,10,'https://images.unsplash.com/photo-1587668178277-295251f900ce?auto=format&fit=crop&w=800&q=80',1,'2026-05-12 07:10:38','2026-05-12 07:36:33');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipping_costs`
--

DROP TABLE IF EXISTS `shipping_costs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_costs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `city` varchar(100) NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  `estimated_days` int DEFAULT '3',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipping_costs`
--

LOCK TABLES `shipping_costs` WRITE;
/*!40000 ALTER TABLE `shipping_costs` DISABLE KEYS */;
INSERT INTO `shipping_costs` VALUES (1,'Jakarta',15000.00,1,'2026-05-11 22:04:25','2026-05-11 22:04:25'),(2,'Bandung',20000.00,2,'2026-05-11 22:04:25','2026-05-11 22:04:25'),(3,'Surabaya',25000.00,3,'2026-05-11 22:04:25','2026-05-11 22:04:25'),(4,'Yogyakarta',22000.00,2,'2026-05-11 22:04:25','2026-05-11 22:04:25'),(5,'Semarang',23000.00,3,'2026-05-11 22:04:25','2026-05-11 22:04:25'),(6,'Medan',35000.00,4,'2026-05-11 22:04:25','2026-05-11 22:04:25'),(7,'Makassar',40000.00,5,'2026-05-11 22:04:25','2026-05-11 22:04:25'),(8,'Bali',30000.00,3,'2026-05-11 22:04:25','2026-05-11 22:04:25'),(9,'Tegal',10000.00,1,'2026-05-12 09:22:24','2026-05-12 09:23:49');
/*!40000 ALTER TABLE `shipping_costs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `role` enum('admin','customer') DEFAULT 'customer',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin SweetBake','admin@sweetbake.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',NULL,NULL,'admin','2026-05-11 22:04:24','2026-05-11 22:04:24'),(3,'linda cantik','lindacantikbgt@gmail.com','$2y$12$1Du5CWWJa5SzV7gjrknuEeo696pQJd0ChuGHLjicMI6wQjVbbKEHe','089637619541','jl. slamet gg rinjani no.3A, panggung','customer','2026-05-12 09:06:23','2026-05-12 09:06:23'),(4,'Bobby','bobby1@gmail.com','$2y$12$Ab8zZJQORYYB11zHVXL6NudSEen1Pw9bjNOCq2/lT3spQlfxpy.sS','124124124','qwertyewfwefwef','customer','2026-05-19 07:43:28','2026-05-19 07:43:28');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlists`
--

DROP TABLE IF EXISTS `wishlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_wishlist` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlists`
--

LOCK TABLES `wishlists` WRITE;
/*!40000 ALTER TABLE `wishlists` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'sweetbake'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-25 21:35:57
