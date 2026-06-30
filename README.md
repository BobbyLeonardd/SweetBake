# SweetBake

SweetBake adalah aplikasi mobile e-commerce manajemen toko kue. Proyek ini menggunakan Flutter untuk frontend dan PHP (Native) + MySQL untuk backend REST API.

Proyek ini awalnya dikembangkan untuk memenuhi tugas akhir mata kuliah Pemrograman Mobile, dengan implementasi fitur e-commerce dasar seperti keranjang belanja persisten, paket bundling, dan manajemen pesanan.

## Tech Stack

**Frontend:**
- Flutter SDK (>= 3.0.0)
- Provider (State Management)
- SharedPreferences (Local Storage)
- HTTP (API consumption)

**Backend:**
- PHP 8.0+ (PDO)
- MySQL 8.0+

## Fitur Utama

- **Product Bundling:** Dukungan untuk produk paket dengan harga khusus.
- **Persistent Cart:** Data keranjang belanja disimpan di local storage (tidak hilang saat aplikasi ditutup).
- **Order Management:** Sistem tracking pesanan dan update status sederhana.
- **Store Branches:** Manajemen cabang toko dengan kalkulasi ongkos kirim dinamis (termasuk opsi ambil di toko/pickup).
- **Stock Validation:** Pengecekan ketersediaan stok sebelum proses checkout.

## Instalasi & Setup

### Prasyarat
- Flutter SDK 3.0+
- Web Server lokal (Laragon / XAMPP)
- MySQL Database

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone https://github.com/BobbyLeonardd/SweetBake.git
   cd sweetbake
   ```

2. **Setup Database**
   - Jalankan MySQL server.
   - Buat database baru (misal: `sweetbake`).
   - Import file skema database dari `backend/database/sweetbake.sql`.

3. **Setup Backend**
   - Pindahkan folder `backend` ke direktori root server lokal (contoh di Laragon: `C:\laragon\www\sweetbake\backend`).
   - Konfigurasi default database menggunakan user `root` tanpa password. Sesuaikan kredensial di `backend/config/database.php` jika environment kamu berbeda.

4. **Setup Frontend**
   - Install dependencies Flutter:
     ```bash
     flutter pub get
     ```
   - Sesuaikan konfigurasi URL API di `lib/config/api_config.dart`. Default diset untuk emulator Android:
     ```dart
     static const String baseUrl = 'http://10.0.2.2/sweetbake/backend/api';
     ```
     *(Ganti dengan IP lokal kamu jika menggunakan real device, atau `localhost` jika dijalankan di Windows/Web).*

5. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

### Akun Demo (Testing)
- **Admin:** `admin@sweetbake.com` / `password`
- **Customer:** Buat akun baru via menu register di aplikasi.

## Struktur Direktori

```text
sweetbake/
├── lib/
│   ├── config/          # Konfigurasi API dan tema
│   ├── models/          # Model data (DTOs)
│   ├── providers/       # State management logic
│   ├── services/        # HTTP client & service layer
│   ├── views/           # UI Screens (admin/customer/auth)
│   └── widgets/         # Komponen UI reusable
├── backend/
│   ├── api/             # Endpoint REST API (auth.php, products.php, dll)
│   ├── config/          # Konfigurasi koneksi database
│   └── database/        # Skema SQL
└── README.md
```

## Dokumentasi Internal

Referensi dokumen tambahan terkait pengembangan proyek:
- [Panduan Instalasi Lengkap](PANDUAN_INSTALL_KELOMPOK.md)
- [Dokumentasi Fitur Bundling](BUNDLING.md)
- [Panduan Presentasi](Panduan_Presentasi_Kelompok.md)

## Lisensi

Proyek ini didistribusikan di bawah [MIT License](LICENSE).
