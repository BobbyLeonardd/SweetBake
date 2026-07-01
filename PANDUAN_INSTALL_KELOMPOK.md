# PANDUAN INSTALL SWEETBAKE - UNTUK ANGGOTA KELOMPOK

Panduan ini buat temen-temen yang mau jalanin proyek SweetBake di laptop masing-masing. Ikutin step by step dari atas ke bawah ya, jangan di-skip!

## BACA INI DULU

Proyek SweetBake ada 2 bagian yang harus jalan bareng:

- Backend (Server): PHP + MySQL di folder `backend/`
- Frontend (Aplikasi): Flutter di folder `lib/`

Backend jalan di Laragon (atau XAMPP), Flutter jalan di emulator Android atau HP fisik.

## YANG HARUS DIINSTALL DULU

Sebelum mulai, pastikan laptop sudah punya semua ini:

### 1. Laragon (Buat Backend)
- Download di: https://laragon.org/download/
- Pilih Laragon Full (udah include Apache + MySQL + PHP)
- Install biasa aja, next-next-finish
- Abis install, buka Laragon terus klik Start All

Kalau udah punya XAMPP, bisa pakai XAMPP. Caranya sama, tinggal ganti folder `htdocs` di langkah backend.

### 2. Flutter SDK
- Download di: https://flutter.dev/docs/get-started/install/windows
- Extract ke `C:\flutter` (jangan di folder yang ada spasi)
- Tambahin `C:\flutter\bin` ke PATH sistem Windows:
  - Cari "Edit the system environment variables" di Windows search
  - Klik Environment Variables
  - Di System variables, pilih `Path` → Edit → New → tambahin `C:\flutter\bin`
  - OK → OK → OK
- Restart terminal/VS Code abis ini

### 3. Android Studio
- Download di: https://developer.android.com/studio
- Install, terus buka Android Studio
- Buka AVD Manager (ikon HP di toolbar) → bikin emulator Android baru
- Pilih device (contoh: Pixel 6) + Android 12/13, download, finish

### 4. VS Code (Editor Kode)
- Download di: https://code.visualstudio.com/
- Install extension Flutter dan Dart di VS Code (cari di marketplace)

### 5. Git (Opsional, kalo dapet proyek via GitHub)
- Download di: https://git-scm.com/download/win

## STEP 0: DAPATKAN PROYEK

### Cara A: Dapet dari teman via ZIP/Flash Disk
1. Copy folder `sweetbake` ke mana aja di laptop kamu (contoh: `C:\flutter\kiro\sweetbake`)
2. Lanjut ke Step 1

### Cara B: Dapet dari GitHub
```bash
git clone https://github.com/[username]/sweetbake.git
cd sweetbake
```

## STEP 1: SETUP DATABASE (MySQL)

### 1.1 Jalankan Laragon
1. Buka Laragon
2. Klik tombol "Start All"
3. Pastikan Apache dan MySQL statusnya hijau/running

### 1.2 Buka phpMyAdmin
1. Di Laragon, klik menu Database atau buka browser ke:
   ```
   http://localhost/phpmyadmin
   ```
2. Login (default: username `root`, password kosong)

### 1.3 Import Database SweetBake
1. Di phpMyAdmin, klik tab "Import" di bagian atas
2. Klik "Choose File"
3. Cari dan pilih file:
   ```
   [folder_project]\backend\database\sweetbake.sql
   ```
4. Scroll ke bawah, klik tombol "Go" atau "Import"
5. Tunggu proses selesai

NOTE: File `sweetbake.sql` udah include gambar bundling! Ga perlu import file tambahan.

### 1.4 Verifikasi Database
Di sidebar kiri phpMyAdmin, harus ada database `sweetbake` dengan tabel-tabel:
- `users` (ada 1 admin default)
- `products` (ada 18 produk sample)
- `categories`
- `orders`
- `order_items`
- `order_tracking`
- `shipping_costs`
- `wishlists`
- `bundles` (ada 4 paket bundling dengan gambar)
- `bundle_items` (produk dalam bundling)

Kalo semua tabel ada, database berhasil!

TIP: Cek apakah bundle punya gambar dengan query:
```sql
SELECT id, name, 
  CASE WHEN image_url IS NOT NULL THEN 'Ada' ELSE 'Tidak' END as gambar 
FROM bundles;
```
Semua bundle harus punya gambar.

## STEP 2: SETUP BACKEND PHP

### 2.1 Copy Folder Backend ke Laragon

Copy folder `backend` dari project SweetBake ke folder `www` Laragon:

Dari:
```
[folder_project]\backend\
```

Ke:
```
C:\laragon\www\sweetbake\backend\
```

Struktur akhirnya harus kayak gini:
```
C:\laragon\www\sweetbake\backend\api\auth.php
C:\laragon\www\sweetbake\backend\api\products.php
C:\laragon\www\sweetbake\backend\api\bundles.php  (BARU!)
C:\laragon\www\sweetbake\backend\config\database.php
C:\laragon\www\sweetbake\backend\database\sweetbake.sql
C:\laragon\www\sweetbake\backend\database\bundles_migration.sql  (BARU!)
```

Kalo pakai XAMPP:
```
C:\xampp\htdocs\sweetbake\backend\
```

### 2.2 Cek Konfigurasi Database (Biasanya Ga Perlu Diubah)

Buka file: `C:\laragon\www\sweetbake\backend\config\database.php`

Pastikan isinya kayak gini (default Laragon):
```php
private $host = "localhost";
private $db_name = "sweetbake";
private $username = "root";
private $password = "";  // Laragon default: password kosong
```

Kalo Laragon kamu punya password MySQL, ganti `""` dengan password tersebut.

### 2.3 Test Backend API di Browser

Test API Produk:
```
http://localhost/sweetbake/backend/api/products.php
```

Test API Bundling (BARU!):
```
http://localhost/sweetbake/backend/api/bundles.php
```

Kalo muncul teks JSON kayak gini, backend udah OK:
```json
{"success":true,"data":[{"id":"1","name":"Paket Hemat Lebaran",...}]}
```

Kalo muncul error, lanjut ke bagian Troubleshooting di bawah.

## STEP 3: SETUP FLUTTER (APLIKASI)

### 3.1 Buka Project di VS Code

1. Buka VS Code
2. File → Open Folder → pilih folder `sweetbake` (root project, bukan subfolder)
3. VS Code bakal otomatis detect project Flutter

### 3.2 Install Dependencies Flutter

Buka Terminal di VS Code (Ctrl + ` atau menu Terminal → New Terminal), terus jalanin:
```bash
flutter pub get
```

Tunggu sampe selesai. Kalo ada error, coba:
```bash
flutter clean
flutter pub get
```

### 3.3 Konfigurasi IP Address (PENTING!)

Buka file: `lib\config\api_config.dart`

```dart
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2/sweetbake/backend/api';
  // ...
}
```

Ganti URL sesuai platform yang kamu pakai:

#### Emulator Android
Biarkan kayak gini, ga perlu diubah:
```dart
static const String baseUrl = 'http://10.0.2.2/sweetbake/backend/api';
```
`10.0.2.2` adalah IP khusus emulator Android buat akses `localhost` komputer kamu.

#### HP Fisik (Android)
Kamu perlu tau IP komputer kamu:
1. Buka CMD di Windows
2. Ketik: `ipconfig`
3. Cari baris "IPv4 Address" yang biasanya kayak `192.168.x.x`

Ganti URL jadi:
```dart
static const String baseUrl = 'http://192.168.1.xxx/sweetbake/backend/api';
//                                        ↑ ganti dengan IP komputer kamu
```

PENTING: HP dan laptop harus konek ke WiFi yang sama!

#### Windows Desktop
Pake localhost biasa:
```dart
static const String baseUrl = 'http://localhost/sweetbake/backend/api';
```

#### Chrome / Web Browser
Sama kayak Windows, pake localhost:
```dart
static const String baseUrl = 'http://localhost/sweetbake/backend/api';
```

NOTE: Kalo run di web, pastikan CORS udah diset di backend PHP (udah diset by default).

### 3.4 Jalankan Aplikasi

#### Emulator Android:
1. Buka Android Studio → AVD Manager → Start emulator
2. Kembali ke VS Code, di pojok kanan bawah pilih device emulator
3. Tekan F5 atau jalankan:
```bash
flutter run
```

#### HP Fisik:
1. Aktifkan Developer Options di HP Android:
   - Buka Settings → About Phone → Tap "Build Number" 7 kali
2. Masuk ke Developer Options → aktifkan USB Debugging
3. Colokkan HP ke laptop via USB
4. Kalo muncul popup "Allow USB Debugging?" di HP → pilih Allow
5. Jalankan:
```bash
flutter run
```

#### Windows Desktop:
1. Pastikan Flutter Windows support udah diinstall:
```bash
flutter config --enable-windows-desktop
```
2. Jalankan:
```bash
flutter run -d windows
```

#### Chrome / Web:
1. Pastikan Flutter Web support udah diinstall:
```bash
flutter config --enable-web
```
2. Jalankan:
```bash
flutter run -d chrome
```

Atau bisa pilih device di VS Code (pojok kanan bawah) terus tekan F5.

---

## ✅ STEP 4: TEST APLIKASI

### Login sebagai Admin:
- **Email:** `admin@sweetbake.com`
- **Password:** `password`

### Login sebagai Customer:
- Klik **"Daftar Sekarang"** di halaman login
- Isi form registrasi
- Login dengan akun yang baru dibuat

### Cek Semua Fitur Berjalan:

#### **Fitur Dasar:**
- [ ] Bisa login admin → masuk ke Dashboard
- [ ] Dashboard tampil statistik
- [ ] Halaman Produk tampil 18 produk sample
- [ ] Bisa tambah/edit/hapus produk
- [ ] Bisa login customer → masuk ke Beranda
- [ ] Produk kue tampil di beranda
- [ ] Bisa tambah ke keranjang
- [ ] Bisa checkout pesanan
- [ ] Pesanan muncul di halaman admin

#### **Fitur Bundling (LENGKAP!):** 🎁
- [ ] **Admin:** Menu "Kelola Paket Bundling" muncul di dashboard
- [ ] **Admin:** Bisa lihat 4 paket bundling sample
- [ ] **Admin:** Bisa tambah paket bundling baru
- [ ] **Admin:** Bisa edit paket bundling
- [ ] **Admin:** Bisa hapus paket bundling
- [ ] **Admin:** Bisa kelola produk dalam bundling
- [ ] **Customer:** Section "Paket Bundling" muncul di home
- [ ] **Customer:** Bisa lihat detail bundling
- [ ] **Customer:** Badge "HEMAT!" dan diskon muncul

#### **Fitur Bundle Cart (BARU!):** 🛒
- [ ] **Customer:** Bisa tambah bundling ke keranjang ⭐
- [ ] **Customer:** Bisa lihat bundling di keranjang dengan badge "PAKET" ⭐
- [ ] **Customer:** Bisa update quantity bundling ⭐
- [ ] **Customer:** Bisa hapus bundling dari keranjang ⭐
- [ ] **Customer:** Bisa checkout bundling bersama produk (mixed cart) ⭐
- [ ] **Customer:** Cart bundling tersimpan walau app ditutup ⭐
- [ ] **Customer:** Badge cart di home update otomatis ⭐

---

## 🎁 FITUR BARU: BUNDLING KUE

### Apa itu Bundling?
Bundling adalah fitur paket kue dengan harga promo. Admin bisa membuat paket yang berisi beberapa kue dengan harga lebih murah dari harga normal.

### Cara Test Fitur Bundling:

#### **Sebagai Admin:**
1. Login admin
2. Scroll dashboard ke bawah
3. Klik menu **"Kelola Paket Bundling"** (icon 🎁 warna pink)
4. Lihat 4 paket sample yang sudah ada
5. Coba tambah paket baru:
   - Klik **"+ Tambah Paket"**
   - Isi nama, deskripsi, harga normal, harga promo
   - Klik **"Simpan"**
6. Coba kelola produk dalam paket:
   - Klik menu **⋮** pada paket
   - Pilih **"Kelola Produk"**
   - Tambah produk ke paket
7. Coba edit dan hapus paket

#### **Sebagai Customer:**
1. Login customer
2. Scroll home ke bawah
3. Lihat section **"🎁 Paket Bundling [HEMAT!]"**
4. Scroll horizontal untuk lihat semua paket
5. Klik salah satu paket untuk lihat detail
6. Lihat badge diskon, harga promo, dan daftar produk

---

## ❗ TROUBLESHOOTING — Solusi Masalah Umum

### ❌ "Connection refused" / App loading terus / Data tidak muncul

**Penyebab:** Backend tidak bisa dijangkau aplikasi

**Solusi:**
1. Pastikan **Laragon Start All** sudah dijalankan
2. Test URL ini di browser: `http://localhost/sweetbake/backend/api/products.php`
   - Kalau di browser muncul data → masalah di IP Flutter
   - Kalau di browser juga error → masalah di backend/Laragon
3. Kalau pakai HP fisik, cek IP sudah benar di `api_config.dart`
4. Pastikan HP dan laptop satu WiFi

---

### ❌ "404 Not Found" saat test di browser

**Penyebab:** Folder backend tidak ada di tempat yang benar

**Solusi:**
1. Cek apakah folder ada di: `C:\laragon\www\sweetbake\backend\`
2. Cek di browser: `http://localhost/sweetbake/backend/api/auth.php`
3. Kalau masih 404, restart Laragon (Stop All → Start All)

---

### ❌ Bundling tidak muncul / Error "Table 'bundles' doesn't exist"

**Penyebab:** Tabel bundling belum dibuat

**Solusi:**
1. Buka phpMyAdmin
2. Pilih database `sweetbake`
3. Klik tab "SQL"
4. Copy-paste SQL dari **Step 1.4** di atas
5. Klik "Go"
6. Restart aplikasi Flutter

---

### ❌ Flutter error: "No pubspec.yaml file found"

**Penyebab:** VS Code dibuka di folder yang salah

**Solusi:**
- Pastikan buka folder **root project** (`sweetbake/`), bukan subfolder
- Di terminal, pastikan kamu berada di dalam folder `sweetbake`:
  ```bash
  # Harus ada output: pubspec.yaml
  ls pubspec.yaml
  ```

---

### ❌ Flutter error: "Could not find a file named 'pubspec.yaml'"

**Solusi:**
```bash
cd [path_ke_folder_sweetbake]
flutter pub get
```

---

### ❌ "Unhandled Exception: Connection error" di aplikasi

**Penyebab:** IP salah atau server tidak aktif

**Solusi:**
1. Pastikan Laragon aktif
2. Buka `lib/config/api_config.dart`
3. Kalau pakai emulator: ganti ke `http://10.0.2.2/sweetbake/backend/api`
4. Kalau pakai HP: cek IP dengan `ipconfig` di CMD

---

### ❌ Database tidak ada / tabel kosong

**Penyebab:** Import SQL belum dilakukan atau gagal

**Solusi:**
1. Buka phpMyAdmin: `http://localhost/phpmyadmin`
2. Hapus database `sweetbake` kalau ada (klik → Drop)
3. Buat database baru bernama `sweetbake`
4. Import ulang file `backend/database/sweetbake.sql`
5. Jalankan SQL bundling dari **Step 1.4**

---

### ❌ flutter pub get gagal / timeout

**Solusi:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

---

### ❌ Emulator tidak muncul di VS Code

**Solusi:**
1. Pastikan Android Studio sudah install emulator
2. Buka AVD Manager di Android Studio → Start emulator
3. Tunggu emulator fully booted
4. Di VS Code klik area device di pojok kanan bawah

---

## 🎁 **FITUR BARU: BUNDLE CART**

### **Apa yang Baru?**
Sekarang customer bisa **menambahkan paket bundling ke keranjang**, mengelola quantity, dan checkout bersama produk biasa!

### **Cara Test Fitur Bundle Cart:**

#### **1. Tambah Bundle ke Cart:**
1. Login customer
2. Scroll home ke section "🎁 Paket Bundling"
3. Klik salah satu bundle
4. Klik "Tambah ke Keranjang"
5. ✅ Lihat SnackBar konfirmasi
6. ✅ Lihat indicator "X paket di keranjang"

#### **2. Lihat Bundle di Cart:**
1. Klik icon cart di home
2. ✅ Bundle muncul dengan badge "PAKET"
3. ✅ Badge diskon persentase tampil (contoh: "20% OFF")
4. ✅ Info "X produk dalam paket" tampil

#### **3. Mixed Cart (Product + Bundle):**
1. Tambah produk biasa ke cart
2. Tambah bundle ke cart
3. ✅ Keduanya muncul di cart page
4. ✅ Total harga gabungan benar

#### **4. Update & Hapus:**
1. Klik tombol [+] atau [-] pada bundle
2. ✅ Quantity berubah, subtotal update
3. Klik icon 🗑️ untuk hapus
4. ✅ Konfirmasi dialog muncul
5. ✅ Bundle terhapus setelah konfirmasi

#### **5. Checkout Bundle:**
1. Cart berisi bundle (dan/atau produk)
2. Klik "Checkout"
3. Isi alamat dan pilih kota
4. ✅ Subtotal termasuk bundle
5. ✅ Order berhasil dibuat
6. ✅ Cart dikosongkan

#### **6. Cart Persistence:**
1. Tambah bundle ke cart
2. Close app (kill process)
3. Buka app lagi
4. ✅ Bundle masih ada di cart

---

## 📊 **RANGKUMAN CHECKLIST**

Simpan ini sebagai panduan cepat:

```
BACKEND:
  ✅ Laragon Start All (Apache + MySQL hijau)
  ✅ Database sweetbake sudah di-import
  ✅ Tabel bundles & bundle_items sudah dibuat
  ✅ Folder backend ada di: C:\laragon\www\sweetbake\backend\
  ✅ Test di browser: http://localhost/sweetbake/backend/api/products.php → muncul JSON
  ✅ Test bundling: http://localhost/sweetbake/backend/api/bundles.php → muncul JSON

FLUTTER:
  ✅ flutter pub get berhasil
  ✅ URL di api_config.dart sudah sesuai (emulator: 10.0.2.2, HP fisik: 192.168.x.x)
  ✅ Emulator/HP sudah terdeteksi di VS Code
  ✅ flutter run berhasil, app terbuka

TEST FITUR DASAR:
  ✅ Login admin berhasil
  ✅ Login customer berhasil
  ✅ Produk tampil di beranda
  ✅ Bisa tambah produk ke cart
  ✅ Bisa checkout

TEST FITUR BUNDLING:
  ✅ Menu "Kelola Paket Bundling" muncul di admin
  ✅ Section "Paket Bundling" muncul di customer home
  ✅ Bisa tambah bundle ke cart ⭐
  ✅ Bundle muncul di cart dengan badge ⭐
  ✅ Bisa update quantity bundle ⭐
  ✅ Bisa checkout bundle ⭐
  ✅ Cart persistence works ⭐
```

---

## 💬 Info Akun Default

| Role | Email | Password |
|---|---|---|
| Admin | admin@sweetbake.com | password |
| Customer | Daftar sendiri di aplikasi | — |

---


---

## 📞 Kalau Masih Bingung

Hubungi **Izzul** (ketua kelompok) karena dia yang paling paham keseluruhan sistem dari database sampai Flutter.

**Semangat! 🚀 Tim SweetBake pasti bisa!**
