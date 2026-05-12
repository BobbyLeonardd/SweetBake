# SweetBake - Sistem Informasi Penjualan Kue

Aplikasi mobile modern untuk sistem penjualan kue dengan fitur lengkap untuk Admin dan Customer.

## 🎯 Fitur Utama

### Admin
- ✅ Dashboard dengan statistik
- ✅ CRUD Produk Kue
- ✅ Kelola Pesanan Customer
- ✅ Update Status Pesanan
- ✅ Tracking Pesanan
- ✅ Kelola Ongkos Kirim

### Customer
- ✅ Registrasi & Login
- ✅ Browse Produk Kue
- ✅ Detail Produk
- ✅ Keranjang Belanja
- ✅ Checkout Pesanan
- ✅ Tracking Status Pesanan
- ✅ Riwayat Pesanan

## 🛠️ Teknologi

### Frontend
- **Flutter** - Framework UI
- **Provider** - State Management
- **HTTP** - API Communication
- **Shared Preferences** - Local Storage
- **Google Fonts** - Typography
- **Cached Network Image** - Image Caching

### Backend
- **PHP** - Server-side Logic
- **MySQL** - Database
- **PDO** - Database Connection

## 📁 Struktur Project

```
sweetbake/
├── lib/
│   ├── config/           # Konfigurasi (API, Theme)
│   ├── models/           # Data Models
│   ├── providers/        # State Management
│   ├── services/         # API Services
│   ├── utils/            # Helper Functions
│   ├── views/            # UI Pages
│   │   ├── admin/        # Admin Pages
│   │   ├── customer/     # Customer Pages
│   │   └── auth/         # Auth Pages
│   ├── widgets/          # Reusable Widgets
│   └── main.dart         # Entry Point
│
├── backend/
│   ├── api/              # API Endpoints
│   │   ├── auth.php
│   │   ├── products.php
│   │   ├── orders.php
│   │   ├── categories.php
│   │   └── shipping.php
│   ├── config/           # Database Config
│   └── database/         # SQL Schema
│
└── README.md
```

## 🚀 Cara Install & Menjalankan

### 1. Setup Database

1. Buka **phpMyAdmin**
2. Import file `backend/database/sweetbake.sql`
3. Database `sweetbake` akan otomatis terbuat dengan data sample

### 2. Setup Backend (PHP)

1. Copy folder `backend` ke folder `htdocs` (XAMPP) atau `www` (WAMP)
   ```
   C:/xampp/htdocs/sweetbake/backend/
   ```

2. Edit `backend/config/database.php` jika perlu (default sudah OK):
   ```php
   private $host = "localhost";
   private $db_name = "sweetbake";
   private $username = "root";
   private $password = "";
   ```

3. Start **Apache** dan **MySQL** di XAMPP/WAMP

4. Test API di browser:
   ```
   http://localhost/sweetbake/backend/api/products.php
   ```

### 3. Setup Frontend (Flutter)

1. Install dependencies:
   ```bash
   cd sweetbake
   flutter pub get
   ```

2. Edit `lib/config/api_config.dart` sesuai environment:
   
   **Untuk Emulator Android:**
   ```dart
   static const String baseUrl = 'http://10.0.2.2/sweetbake/backend/api';
   ```
   
   **Untuk iOS Simulator:**
   ```dart
   static const String baseUrl = 'http://localhost/sweetbake/backend/api';
   ```
   
   **Untuk Device Fisik:**
   ```dart
   static const String baseUrl = 'http://192.168.x.x/sweetbake/backend/api';
   ```
   (Ganti dengan IP komputer Anda)

3. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 👤 Akun Demo

### Admin
- **Email:** admin@sweetbake.com
- **Password:** password

### Customer
- Daftar akun baru melalui halaman registrasi

## 📱 Screenshot & Fitur

### Customer Flow
1. **Login/Register** - Autentikasi user
2. **Home** - Browse produk kue
3. **Product Detail** - Lihat detail & tambah ke keranjang
4. **Cart** - Kelola keranjang belanja
5. **Checkout** - Pilih alamat & ongkir
6. **Orders** - Lihat riwayat & tracking pesanan

### Admin Flow
1. **Dashboard** - Statistik & overview
2. **Manage Products** - CRUD produk
3. **Manage Orders** - Lihat & update status pesanan
4. **Order Detail** - Detail pesanan & tracking

## 🎨 Design System

### Colors
- **Primary:** Pink (#E91E63)
- **Secondary:** Amber (#FFC107)
- **Accent:** Deep Orange (#FF5722)
- **Success:** Green (#4CAF50)
- **Error:** Red (#F44336)

### Typography
- **Font:** Poppins (Google Fonts)
- **Heading 1:** 32px Bold
- **Heading 2:** 24px SemiBold
- **Body:** 14-16px Regular

## 🔧 Troubleshooting

### Error: Connection refused
- Pastikan Apache & MySQL sudah running
- Cek URL di `api_config.dart` sudah benar
- Test API di browser terlebih dahulu

### Error: No data
- Import database `sweetbake.sql`
- Cek koneksi database di `database.php`

### Error: CORS
- Sudah di-handle di `database.php`
- Pastikan header CORS sudah ada

## 📝 API Endpoints

### Auth
- `POST /auth.php` - Login & Register

### Products
- `GET /products.php` - Get all products
- `GET /products.php?id={id}` - Get single product
- `POST /products.php` - Create product (Admin)
- `PUT /products.php` - Update product (Admin)
- `DELETE /products.php?id={id}` - Delete product (Admin)

### Orders
- `GET /orders.php` - Get all orders (Admin)
- `GET /orders.php?customer_id={id}` - Get customer orders
- `GET /orders.php?id={id}` - Get single order
- `POST /orders.php` - Create order
- `PUT /orders.php` - Update order status (Admin)

### Categories
- `GET /categories.php` - Get all categories

### Shipping
- `GET /shipping.php` - Get all shipping costs
- `GET /shipping.php?city={city}` - Get shipping by city

## 🚀 Pengembangan Lebih Lanjut

### Fitur yang Bisa Ditambahkan:
1. **Payment Gateway** - Integrasi Midtrans/Xendit
2. **Push Notifications** - Firebase Cloud Messaging
3. **Image Upload** - Upload gambar produk
4. **Chat** - Customer service chat
5. **Rating & Review** - Review produk
6. **Promo & Voucher** - Sistem diskon
7. **Report** - Laporan penjualan
8. **Multi-role Admin** - Super admin, staff, dll

### Best Practices:
- ✅ Clean Architecture
- ✅ State Management (Provider)
- ✅ Reusable Widgets
- ✅ Responsive Design
- ✅ Error Handling
- ✅ Loading States
- ✅ Form Validation

## 📄 License

MIT License - Free to use for learning and commercial projects.

## 👨‍💻 Developer

Dibuat dengan ❤️ menggunakan Flutter & PHP

---

**Happy Coding! 🎉**
