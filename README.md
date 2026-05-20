# SweetBake - Cake Shop Management System

> Full-stack mobile application untuk manajemen toko kue dengan fitur bundling dan persistent cart

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![PHP](https://img.shields.io/badge/PHP-8.0+-777BB4?logo=php)
![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?logo=mysql)

## Tentang Proyek

SweetBake adalah aplikasi mobile e-commerce untuk toko kue yang dibangun dengan Flutter (frontend) dan PHP + MySQL (backend). Aplikasi ini dibuat sebagai tugas akhir mata kuliah Pemrograman Mobile dengan fokus pada user experience dan fitur-fitur modern seperti persistent cart dan bundle pricing.

### Fitur Unggulan

- **Paket Bundling** - Admin bisa bikin paket kue dengan harga promo, customer bisa beli dalam satu paket
- **Persistent Cart** - Keranjang belanja tersimpan otomatis walau app ditutup
- **Mixed Cart** - Checkout produk dan bundle sekaligus dalam satu transaksi
- **Real-time Order Tracking** - Customer bisa tracking status pesanan secara real-time
- **Wishlist** - Simpan produk favorit untuk dibeli nanti

## Screenshot

<!-- Tambahkan screenshot aplikasi kamu di sini -->

## Tech Stack

**Frontend:**
- Flutter 3.0+ (Dart)
- Provider (State Management)
- SharedPreferences (Local Storage)
- Cached Network Image
- Google Fonts

**Backend:**
- PHP 8.0+ dengan PDO
- MySQL 8.0+
- RESTful API
- CORS enabled

**Server:**
- Laragon / XAMPP

## Fitur Lengkap

### Admin Panel
- Dashboard dengan statistik real-time (pendapatan, pesanan, pelanggan)
- CRUD produk dan kategori
- Kelola paket bundling dengan harga promo
- Manajemen pesanan dengan update status
- Kelola ongkos kirim per kota
- Manajemen data pelanggan

### Customer App
- Registrasi dan login
- Browse produk dengan search dan filter kategori
- Detail produk dengan wishlist
- Keranjang belanja (persistent)
- Tambah bundling ke keranjang
- Checkout dengan kalkulasi ongkir otomatis
- Riwayat pesanan dengan tracking
- Profil pengguna

## Instalasi

### Prerequisites
- Flutter SDK 3.0+
- Laragon atau XAMPP
- Android Studio / VS Code
- Emulator Android atau device fisik

### Quick Start

1. **Clone repository**
```bash
git clone https://github.com/username/sweetbake.git
cd sweetbake
```

2. **Setup Database**
- Buka Laragon → Start All
- Buka phpMyAdmin: `http://localhost/phpmyadmin`
- Import file `backend/database/sweetbake.sql`

3. **Setup Backend**
- Copy folder `backend` ke `C:\laragon\www\sweetbake\backend\`
- Test API: `http://localhost/sweetbake/backend/api/products.php`

4. **Setup Flutter**
```bash
flutter pub get
```

5. **Konfigurasi API**

Edit `lib/config/api_config.dart`:
```dart
// Emulator Android
static const String baseUrl = 'http://10.0.2.2/sweetbake/backend/api';

// Device fisik (ganti dengan IP komputer kamu)
static const String baseUrl = 'http://192.168.x.x/sweetbake/backend/api';

// Windows/Web
static const String baseUrl = 'http://localhost/sweetbake/backend/api';
```

6. **Run aplikasi**
```bash
flutter run              # auto-detect device
flutter run -d windows   # Windows desktop
flutter run -d chrome    # Web browser
```

### Demo Account

- **Admin:** admin@sweetbake.com / password
- **Customer:** Daftar sendiri di aplikasi

## Dokumentasi

- [Panduan Instalasi Lengkap](PANDUAN_INSTALL_KELOMPOK.md)
- [Dokumentasi Fitur Bundling](BUNDLING.md)
- [Panduan Presentasi](Panduan_Presentasi_Kelompok.md)

## Database Schema

Aplikasi menggunakan 10 tabel:
- `users` - Akun admin dan customer
- `products` - Katalog produk kue
- `categories` - Kategori produk
- `orders` - Data pesanan
- `order_items` - Detail item dalam pesanan
- `order_tracking` - Riwayat status pesanan
- `shipping_costs` - Ongkos kirim per kota
- `wishlists` - Produk favorit
- `bundles` - Paket bundling
- `bundle_items` - Produk dalam paket

## API Endpoints

```
POST   /auth.php                    - Login & Register
GET    /products.php                - Get all products
POST   /products.php                - Create product
PUT    /products.php                - Update product
DELETE /products.php?id={id}        - Delete product
GET    /orders.php                  - Get all orders
POST   /orders.php                  - Create order
GET    /bundles.php                 - Get all bundles
POST   /bundles.php                 - Create bundle
...dan lainnya
```

## Struktur Project

```
sweetbake/
├── lib/
│   ├── config/          # API & theme config
│   ├── models/          # Data models
│   ├── providers/       # State management
│   ├── services/        # API services
│   ├── views/           # UI screens
│   │   ├── admin/       # Admin pages
│   │   ├── customer/    # Customer pages
│   │   └── auth/        # Login & register
│   └── widgets/         # Reusable widgets
├── backend/
│   ├── api/             # REST API endpoints
│   ├── config/          # Database config
│   └── database/        # SQL files
└── README.md
```

## Kontribusi

Proyek ini dibuat untuk tugas akhir mata kuliah. Jika kamu tertarik untuk berkontribusi atau punya saran, silakan buat issue atau pull request.

## License

[MIT License](LICENSE)

## Tim Pengembang

- **Izzul** - Backend & Database
- **Linda** - Admin Panel & Product Management
- **Aul** - Customer UI/UX
- **Dilla** - Cart & Checkout
- **Miya** - Order Management & Analytics

## Acknowledgments

- Terima kasih kepada dosen pembimbing
- Flutter & Dart community
- Stack Overflow untuk troubleshooting

---

⭐ Jangan lupa kasih star kalau proyek ini bermanfaat!

Dibuat dengan ❤️ menggunakan Flutter & PHP
