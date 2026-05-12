# 📖 Panduan Setup SweetBake - Step by Step

## 📋 Prerequisites

Pastikan sudah terinstall:
- ✅ Flutter SDK (3.0+)
- ✅ XAMPP atau WAMP (Apache + MySQL + PHP)
- ✅ Android Studio / VS Code
- ✅ Android Emulator atau iOS Simulator

---

## 🗄️ STEP 1: Setup Database MySQL

### 1.1 Start XAMPP/WAMP/Laragon
1. Buka **XAMPP Control Panel**
2. Start **Apache** dan **MySQL**
3. Pastikan keduanya running (hijau)

### 1.2 Import Database
1. Buka browser, akses: `http://localhost/phpmyadmin`
2. Klik tab **"Import"**
3. Klik **"Choose File"**
4. Pilih file: `sweetbake/backend/database/sweetbake.sql`
5. Klik **"Go"** atau **"Import"**
6. Database `sweetbake` akan terbuat otomatis

### 1.3 Verifikasi Database
1. Klik database **"sweetbake"** di sidebar kiri
2. Pastikan ada tabel:
   - users
   - products
   - orders
   - order_items
   - order_tracking
   - categories
   - shipping_costs

---

## 🔧 STEP 2: Setup Backend PHP

### 2.1 Copy Backend ke htdocs, www, atau folder lainnya
1. Copy folder `backend` dari project
2. Paste ke folder htdocs XAMPP:
   ```
   Windows: C:/xampp/htdocs/sweetbake/backend/
   Mac: /Applications/XAMPP/htdocs/sweetbake/backend/
   ```

   1. Copy folder `backend` dari project
   2. Paste ke folder www Laragon:
   ```
   Windows: C:/laragon/www/sweetbake/backend/
   Mac: /Applications/laragon/www/sweetbake/backend/
   ```

### 2.2 Konfigurasi Database (Opsional)
Jika username/password MySQL berbeda, edit file:
`backend/config/database.php`

```php
private $host = "localhost";
private $db_name = "sweetbake";
private $username = "root";        // Ganti jika berbeda
private $password = "";            // Ganti jika ada password
```

### 2.3 Test Backend API
Buka browser dan test endpoint:

**Test Products API:**
```
http://localhost/sweetbake/backend/api/products.php
```

**Response yang benar:**
```json
{
  "success": true,
  "data": [...]
}
```

**Test Categories API:**
```
http://localhost/sweetbake/backend/api/categories.php
```

Jika muncul data JSON, backend sudah OK! ✅

---

## 📱 STEP 3: Setup Flutter Frontend

### 3.1 Install Dependencies
Buka terminal di folder `sweetbake`:

```bash
cd sweetbake
flutter pub get
```

Tunggu sampai semua package terinstall.

### 3.2 Konfigurasi API URL

Edit file: `lib/config/api_config.dart`

**Pilih sesuai environment:**

#### A. Untuk Android Emulator
```dart
static const String baseUrl = 'http://10.0.2.2/sweetbake/backend/api';
```

#### B. Untuk iOS Simulator
```dart
static const String baseUrl = 'http://localhost/sweetbake/backend/api';
```

#### C. Untuk Device Fisik (HP)
1. Cek IP komputer:
   - Windows: `ipconfig` di CMD
   - Mac/Linux: `ifconfig` di Terminal
   - Cari IP seperti: `192.168.x.x`

2. Gunakan IP tersebut:
```dart
static const String baseUrl = 'http://192.168.1.100/sweetbake/backend/api';
```

**PENTING:** Pastikan HP dan komputer dalam jaringan WiFi yang sama!

### 3.3 Jalankan Aplikasi

#### Untuk Emulator/Simulator:
```bash
flutter run
```

#### Untuk Device Fisik:
1. Enable **USB Debugging** di HP Android
2. Sambungkan HP ke komputer
3. Jalankan:
```bash
flutter run
```

---

## 🧪 STEP 4: Testing Aplikasi

### 4.1 Login sebagai Admin
1. Buka aplikasi
2. Klik **Login**
3. Gunakan akun:
   - **Email:** admin@sweetbake.com
   - **Password:** password
4. Anda akan masuk ke **Admin Dashboard**

### 4.2 Test Fitur Admin
- ✅ Lihat statistik di dashboard
- ✅ Kelola produk (tambah, edit, hapus)
- ✅ Lihat daftar pesanan
- ✅ Update status pesanan

### 4.3 Registrasi sebagai Customer
1. Logout dari admin
2. Klik **"Daftar"** di halaman login
3. Isi form registrasi
4. Login dengan akun baru

### 4.4 Test Fitur Customer
- ✅ Browse produk kue
- ✅ Lihat detail produk
- ✅ Tambah ke keranjang
- ✅ Checkout pesanan
- ✅ Lihat riwayat pesanan

---

## ❗ Troubleshooting

### Problem 1: "Connection refused" atau "Failed to connect"

**Solusi:**
1. Pastikan Apache & MySQL running di XAMPP
2. Test API di browser terlebih dahulu
3. Cek URL di `api_config.dart` sudah benar
4. Untuk device fisik, pastikan firewall tidak memblokir

### Problem 2: "No data" atau data kosong

**Solusi:**
1. Pastikan database sudah di-import
2. Cek di phpMyAdmin apakah ada data di tabel `products`
3. Test API products di browser

### Problem 3: CORS Error

**Solusi:**
1. Pastikan file `.htaccess` ada di folder `backend`
2. Enable mod_rewrite di Apache (biasanya sudah default)
3. Restart Apache

### Problem 4: "404 Not Found" saat akses API

**Solusi:**
1. Pastikan folder backend ada di `htdocs/sweetbake/backend`
2. Cek URL: `http://localhost/sweetbake/backend/api/products.php`
3. Pastikan Apache running

### Problem 5: Flutter build error

**Solusi:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🎯 Checklist Setup

Gunakan checklist ini untuk memastikan semua sudah OK:

### Backend
- [ ] XAMPP/WAMP terinstall
- [ ] Apache & MySQL running
- [ ] Database `sweetbake` sudah di-import
- [ ] Folder backend ada di htdocs
- [ ] API products bisa diakses di browser

### Frontend
- [ ] Flutter SDK terinstall
- [ ] Dependencies sudah di-install (`flutter pub get`)
- [ ] API URL di `api_config.dart` sudah benar
- [ ] Aplikasi bisa running tanpa error

### Testing
- [ ] Bisa login sebagai admin
- [ ] Bisa registrasi customer baru
- [ ] Bisa browse produk
- [ ] Bisa tambah ke keranjang
- [ ] Bisa checkout pesanan

---

## 📞 Bantuan Lebih Lanjut

Jika masih ada masalah:

1. **Cek log error:**
   - Flutter: Lihat di terminal/console
   - PHP: Cek `error_log` di folder Apache

2. **Test API manual:**
   - Gunakan Postman atau browser
   - Test setiap endpoint satu per satu

3. **Restart semua:**
   - Restart Apache & MySQL
   - Restart Flutter app
   - Clear cache: `flutter clean`

---

## 🎉 Selamat!

Jika semua checklist sudah ✅, aplikasi SweetBake siap digunakan!

**Next Steps:**
- Customize design sesuai kebutuhan
- Tambah fitur payment gateway
- Deploy ke production
- Publish ke Play Store/App Store

**Happy Coding! 🚀**
