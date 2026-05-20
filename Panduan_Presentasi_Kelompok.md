# PANDUAN PRESENTASI & PEMBAGIAN TUGAS KELOMPOK (SWEETBAKE)

Dokumen ini berisi pembagian tugas untuk aplikasi SweetBake (Sistem Informasi Penjualan Kue). Setiap anggota punya fokus spesifik dari Backend (PHP/MySQL) sampe Frontend (Flutter). 

Baca, pahami, dan gunain contekan penjelasan di bawah ini pas presentasi atau tanya jawab sama dosen/penguji.

## OVERVIEW APLIKASI SWEETBAKE

Teknologi:
- Frontend: Flutter (Dart) dengan Provider State Management
- Backend: PHP dengan PDO (aman dari SQL Injection)
- Database: MySQL (10 tabel)
- Server: Laragon/XAMPP (Apache + MySQL)

Fitur Utama:
1. Authentication (Login/Register)
2. CRUD Produk & Kategori
3. Keranjang Belanja (Persistent)
4. Checkout & Ongkir
5. Order Management & Tracking
6. Wishlist
7. Paket Bundling (FITUR BARU!)
8. Bundle Cart (FITUR TERBARU!)

## FITUR BARU: PAKET BUNDLING & BUNDLE CART

Penjelasan Umum untuk Semua Anggota:

Apa itu Bundling?
"Bundling itu fitur paket kue dengan harga promo. Misalnya, 'Paket Hemat Lebaran' isinya 3 jenis kue dengan harga Rp 199.000 (hemat 20% dari harga normal Rp 250.000). Customer bisa beli paket ini dan tambahin ke keranjang kayak produk biasa."

Teknologi yang Digunakan:
- Database: 2 tabel baru (`bundles` dan `bundle_items`)
- Backend: API `bundles.php` dengan CRUD lengkap
- Frontend: Model `Bundle`, Provider `BundleProvider`, dan UI khusus bundle
- Cart Integration: CartItem sekarang support 2 tipe (Product & Bundle)

Keunggulan Implementasi:
- Type-safe dengan enum `CartItemType`
- Backward compatible (ga break existing code)
- Persistent cart (bundle tersimpan di SharedPreferences)
- Mixed cart (bisa checkout product + bundle sekaligus)

## SKENARIO DEMO PRESENTASI

Urutan Demo yang Disarankan:

1. Opening (Izzul - 2 menit)
- Perkenalan aplikasi SweetBake
- Penjelasan teknologi yang digunakan
- Overview fitur-fitur utama

2. Admin Flow (Linda - 5 menit)
- Login sebagai admin
- Dashboard statistik
- CRUD produk
- CRUD paket bundling (BARU!)
- Kelola pesanan

3. Customer Flow (Aul, Dilla - 8 menit)
- Login sebagai customer
- Browse produk di beranda
- Lihat paket bundling (BARU!)
- Tambah produk ke cart
- Tambah bundle ke cart (BARU!)
- Wishlist
- Checkout
- Tracking pesanan

4. Technical Deep Dive (Miya - 3 menit)
- Penjelasan arsitektur
- Database schema
- API endpoints
- State management

5. Q&A (Semua - 5 menit)

## TIPS UMUM UNTUK SEMUA ANGGOTA SAAT PRESENTASI

Persiapan Teknis:
- Siapkan Emulator / HP Fisik - Demo langsung lebih meyakinkan
- Backend Running - Pastikan Laragon Start All sebelum presentasi
- Data Sample - Pastikan ada produk dan bundle di database
- Internet Stabil - Buat load gambar produk
- Backup Plan - Screenshot/video kalo ada masalah teknis

Cara Menjelaskan:
- JANGAN: Menghafal kode baris per baris
- LAKUKAN: Jelaskan alur logika dan konsep
- JANGAN: Panik pas ada error
- LAKUKAN: Tenang dan jelaskan "ini bagian integrasi yang lagi disempurnain"

Saling Melengkapi:
- Karena SweetBake adalah aplikasi terintegrasi, tugas kalian saling berkaitan
- Kalo ada pertanyaan di luar bagian kamu, boleh minta bantuan teman
- Tunjukin teamwork yang solid

Highlight Fitur Baru:
- Pastikan demo fitur bundling dan bundle cart
- Jelasin keunggulan implementasi (type-safe, backward compatible)
- Tunjukin mixed cart (product + bundle)

## SCRIPT DEMO LENGKAP

### **Demo 1: Admin - Kelola Bundling (3 menit)**

**Narasi:**
"Sekarang saya akan mendemonstrasikan fitur terbaru kami, yaitu Paket Bundling. Fitur ini memungkinkan admin membuat paket kue dengan harga promo."

**Aksi:**
1. Login admin → Dashboard
2. Scroll ke bawah → Klik "Kelola Paket Bundling"
3. Tampilkan 4 paket sample
4. Klik "Tambah Paket" → Isi form:
   - Nama: "Paket Demo Presentasi"
   - Harga Normal: 200000
   - Harga Promo: 150000
5. Simpan → Paket muncul di list
6. Klik menu ⋮ → "Kelola Produk"
7. Tambah 2-3 produk ke paket
8. Kembali ke list bundling

**Penjelasan Teknis:**
"Di backend, kami menggunakan 2 tabel: `bundles` untuk data paket, dan `bundle_items` untuk produk dalam paket. API `bundles.php` menangani CRUD dengan relasi CASCADE DELETE, jadi saat paket dihapus, produk di dalamnya juga otomatis terhapus."

---

### **Demo 2: Customer - Belanja Bundle (5 menit)**

**Narasi:**
"Sekarang dari sisi customer, mereka bisa melihat dan membeli paket bundling ini."

**Aksi:**
1. Login customer → Beranda
2. Scroll ke section "🎁 Paket Bundling [HEMAT!]"
3. Klik salah satu bundle → Detail page
4. Tunjukkan:
   - Badge diskon (20% OFF)
   - Harga normal (coret)
   - Harga promo (bold)
   - Total hemat
   - List produk dalam paket
5. Klik "Tambah ke Keranjang"
6. Lihat indicator "1 paket di keranjang"
7. Klik icon cart → Cart page
8. Tunjukkan bundle dengan badge "PAKET"
9. Tambah produk biasa ke cart
10. Tunjukkan mixed cart (product + bundle)
11. Update quantity bundle
12. Checkout → Isi alamat → Pilih kota → Buat Pesanan
13. Pesanan berhasil → Cart kosong

**Penjelasan Teknis:**
"Untuk implementasi cart, kami menggunakan model `CartItem` yang fleksibel dengan enum `CartItemType`. Model ini bisa menampung product atau bundle. Data cart disimpan ke `SharedPreferences` agar persistent. Saat checkout, sistem otomatis menghitung total dari product dan bundle."

## PERTANYAAN YANG MUNGKIN DITANYA & JAWABANNYA

Q1: Kenapa pakai Flutter, bukan native Android?
A: "Flutter bisa bikin aplikasi cross-platform (Android & iOS) dengan satu codebase. Ini lebih efisien dan hemat waktu. Plus, Flutter punya hot reload yang bikin development lebih cepat."

Q2: Bagaimana keamanan password di aplikasi ini?
A: "Password di-hash pake `PASSWORD_BCRYPT` sebelum disimpen ke database. Pas login, kita pakai `password_verify()` buat ngecek. Jadi password asli ga pernah kesimpen di database."

Q3: Bagaimana cara nangani SQL Injection?
A: "Kita pake PDO dengan prepared statements. Semua input user di-bind sebagai parameter, bukan digabung langsung ke query. Ini mencegah SQL Injection."

Q4: Kenapa pakai Provider buat state management?
A: "Provider itu solusi state management yang direkomendasiin Flutter. Lebih ringan dari Redux, gampang dipahami, dan cocok buat aplikasi skala menengah kayak SweetBake."

Q5: Gimana bundle bisa masuk ke cart bareng product?
A: "Kita pake model `CartItem` yang fleksibel dengan enum `CartItemType`. Model ini bisa nampung product atau bundle. Pas checkout, sistem bedain tipe item dan proses sesuai jenisnya."

Q6: Apa yang terjadi kalo bundle dihapus tapi masih ada di cart customer?
A: "Saat ini, bundle yang udah di cart bakal tetep ada sampe customer checkout. Buat improvement, kita bisa tambahin validasi pas checkout buat cek availability bundle."

Q7: Gimana kalo stok produk dalam bundle habis?
A: "Saat ini bundle ga punya stock management. Ini bisa jadi future enhancement dengan nambahin validasi stok produk dalam bundle pas checkout."

Q8: Kenapa cart ga hilang pas app ditutup?
A: "Kita pake `SharedPreferences` buat nyimpen data cart secara lokal di device. Pas app dibuka lagi, cart di-load dari SharedPreferences."

## PEMBAGIAN TUGAS DETAIL

### 1. IZZUL (Ketua) - Core System & Bundle Backend

Tanggung Jawab:
- Database configuration & schema
- Authentication system (Login/Register)
- API configuration
- Bundle API (`bundles.php`)

File yang Harus Dipahami:
- `backend/config/database.php`
- `backend/api/auth.php`
- `backend/api/bundles.php`
- `lib/config/api_config.dart`
- `lib/providers/auth_provider.dart`

Contekan Penjelasan:

1. Database & PDO:
"Kita pake PDO buat koneksi database karena lebih aman dari SQL Injection. PDO pake prepared statements yang misahin query dan data. CORS headers juga kita set biar API bisa dipanggil dari Flutter."

2. Authentication:
"Sistem auth pake bcrypt buat hashing password. Pas register, password di-hash dengan `password_hash()`. Pas login, kita verifikasi dengan `password_verify()`. Token session disimpen di SharedPreferences Flutter."

3. Bundle API:
"API bundles.php nangani CRUD paket bundling. Kita pake relasi database dengan `LEFT JOIN` buat ambil produk dalam bundle. Pas bundle dihapus, produk di dalamnya juga otomatis kehapus karena `ON DELETE CASCADE`."

Demo yang Harus Bisa:
- Jelasin database schema
- Tunjukin file `database.php`
- Test API bundles di browser
- Jelasin CORS headers

### **2. LINDA - Admin Catalog & Bundle Management**

**Tanggung Jawab:**
- CRUD Produk & Kategori
- **CRUD Paket Bundling** 🎁
- **Kelola Produk dalam Bundle** 🎁
- Admin product management UI

**File yang Harus Dipahami:**
- `backend/api/products.php`
- `backend/api/categories.php`
- `lib/providers/product_provider.dart`
- `lib/providers/bundle_provider.dart` 🎁
- `lib/views/admin/admin_products_page.dart`
- `lib/views/admin/admin_bundles_page.dart` 🎁
- `lib/views/admin/admin_bundle_items_page.dart` 🎁

**Contekan Penjelasan:**

**1. CRUD Produk:**
"API products.php menggunakan metode RESTful: GET untuk ambil data, POST untuk tambah, PUT untuk update, DELETE untuk hapus. Di Flutter, kami pakai Provider untuk state management agar UI otomatis update saat data berubah."

**2. Relasi Kategori:**
"Produk dan kategori punya relasi foreign key. Saat hapus kategori, sistem cek dulu apakah ada produk di kategori tersebut. Kalau ada, kategori tidak bisa dihapus untuk menjaga integritas data."

**3. Bundle Management:** 🎁
"Fitur bundling memungkinkan admin membuat paket kue dengan harga promo. Admin bisa tambah produk ke bundle dengan quantity tertentu. UI menampilkan diskon persentase otomatis berdasarkan harga normal dan promo."

**Demo yang Harus Bisa:**
- Tambah/edit/hapus produk
- Tambah/edit/hapus kategori
- **Tambah paket bundling baru** 🎁
- **Kelola produk dalam bundle** 🎁
- Tunjukkan validasi form

---

### **3. AUL - Customer Experience & Bundle Display**

**Tanggung Jawab:**
- Customer home page
- Product catalog & search
- Product detail page
- Wishlist
- **Bundle display di home** 🎁
- **Bundle detail page** 🎁

**File yang Harus Dipahami:**
- `lib/views/customer/customer_home_page.dart`
- `lib/views/customer/product_detail_page.dart`
- `lib/views/customer/bundle_detail_page.dart` 🎁
- `lib/views/customer/wishlist_page.dart`
- `lib/widgets/product_card.dart`
- `lib/widgets/bundle_card.dart` 🎁

**Contekan Penjelasan:**

**1. Home Page:**
"Beranda customer menampilkan produk dalam grid layout. Kami pakai `GridView.builder` untuk performa yang baik. Search menggunakan filter di Provider. Gambar produk di-cache dengan `cached_network_image` agar loading lebih cepat."

**2. Product Detail:**
"Saat customer klik produk, ID produk di-pass ke detail page. Detail page menampilkan info lengkap, tombol tambah ke cart, dan wishlist. Quantity bisa diatur sebelum tambah ke cart."

**3. Bundle Section:** 🎁
"Di home page, ada section khusus untuk paket bundling dengan badge 'HEMAT!'. Bundle ditampilkan horizontal scroll. Saat diklik, customer bisa lihat detail bundle termasuk list produk di dalamnya, diskon persentase, dan total hemat."

**Demo yang Harus Bisa:**
- Browse produk di home
- Search produk
- Lihat detail produk
- **Lihat section bundling** 🎁
- **Klik detail bundle** 🎁
- Tambah/hapus wishlist

---

### **4. DILLA - Shopping Cart & Bundle Cart**

**Tanggung Jawab:**
- Cart management
- **Bundle cart integration** 🛒
- Checkout flow
- Shipping cost calculation
- **Mixed cart (product + bundle)** 🛒

**File yang Harus Dipahami:**
- `lib/providers/cart_provider.dart` 🛒
- `lib/models/cart_item_model.dart` 🛒
- `lib/views/customer/cart_page.dart` 🛒
- `lib/views/customer/checkout_page.dart`
- `backend/api/shipping.php`

**Contekan Penjelasan:**

**1. Cart Management:**
"Cart menggunakan Provider untuk state management dan SharedPreferences untuk persistence. Data cart tersimpan lokal di device, jadi tidak hilang saat app ditutup. Quantity bisa diubah dengan tombol +/-, subtotal otomatis update."

**2. Bundle Cart Integration:** 🛒
"Ini fitur terbaru kami. CartItem sekarang support 2 tipe: Product dan Bundle. Kami pakai enum `CartItemType` untuk type safety. Bundle di cart ditampilkan dengan badge 'PAKET' dan badge diskon. Customer bisa checkout product dan bundle sekaligus dalam satu transaksi."

**3. Checkout Flow:**
"Saat checkout, customer pilih kota tujuan. Sistem otomatis kalkulasi ongkir dari API `shipping.php`. Total = Subtotal Cart + Ongkir. Setelah konfirmasi, data dikirim ke API `orders.php` dan cart dikosongkan."

**Demo yang Harus Bisa:**
- Tambah produk ke cart
- **Tambah bundle ke cart** 🛒
- **Tunjukkan mixed cart** 🛒
- Update quantity
- Hapus item dari cart
- Checkout dengan ongkir
- Cart persistence (tutup & buka app)

---

### **5. MIYA - Order Management & Analytics**

**Tanggung Jawab:**
- Order tracking (customer)
- Order management (admin)
- Order status updates
- Customer management
- Analytics dashboard

**File yang Harus Dipahami:**
- `backend/api/orders.php`
- `backend/api/users.php`
- `backend/api/analytics.php`
- `lib/views/customer/orders_page.dart`
- `lib/views/customer/order_detail_page.dart`
- `lib/views/admin/admin_orders_page.dart`
- `lib/views/admin/admin_dashboard_page.dart`

**Contekan Penjelasan:**

**1. Order Tracking:**
"Customer bisa lihat semua pesanannya di orders page. API filter pesanan berdasarkan `user_id`. Status pesanan ditampilkan dengan warna berbeda: pending (kuning), processing (biru), shipped (hijau), delivered (hijau tua)."

**2. Admin Order Management:**
"Admin bisa lihat semua pesanan dari semua customer. Admin bisa update status pesanan dengan dropdown. Setiap perubahan status tercatat di tabel `order_tracking` untuk audit trail."

**3. Dashboard Analytics:**
"Dashboard admin menampilkan statistik: total pesanan, total pendapatan, jumlah customer. Data diambil dari API `analytics.php` yang melakukan agregasi dari database."

**Demo yang Harus Bisa:**
- Lihat riwayat pesanan customer
- Lihat detail pesanan
- Update status pesanan (admin)
- Lihat dashboard statistik
- Kelola data customer

---

## 🎬 **SKENARIO PRESENTASI LENGKAP (20 MENIT)**

### **Menit 1-2: Opening (Izzul)**
"Selamat pagi/siang Bapak/Ibu. Kami dari kelompok SweetBake akan mempresentasikan aplikasi Sistem Informasi Penjualan Kue berbasis Flutter dan PHP. Aplikasi ini memiliki 2 role: Admin untuk mengelola toko, dan Customer untuk berbelanja. Fitur unggulan kami adalah Paket Bundling dengan integrasi keranjang yang seamless."

### **Menit 3-7: Admin Demo (Linda)**
1. Login admin
2. Dashboard overview
3. Kelola produk (tambah 1 produk baru)
4. **Kelola bundling (tambah paket baru)** 🎁
5. **Tambah produk ke bundle** 🎁
6. Lihat pesanan masuk

### **Menit 8-15: Customer Demo (Aul & Dilla)**
1. Login customer (Aul)
2. Browse produk di home (Aul)
3. **Lihat section bundling** 🎁 (Aul)
4. **Klik detail bundle** 🎁 (Aul)
5. Tambah produk ke cart (Dilla)
6. **Tambah bundle ke cart** 🛒 (Dilla)
7. **Tunjukkan mixed cart** 🛒 (Dilla)
8. Checkout (Dilla)
9. Lihat pesanan (Aul)

### **Menit 16-18: Technical Explanation (Miya)**
1. Arsitektur aplikasi
2. Database schema (10 tabel)
3. API endpoints
4. State management dengan Provider
5. **Bundle cart implementation** 🛒

### **Menit 19-20: Closing (Izzul)**
"Demikian presentasi kami. Aplikasi SweetBake sudah implement fitur-fitur modern seperti persistent cart, bundle pricing, dan real-time order tracking. Terima kasih. Kami siap menjawab pertanyaan."

---

## 🎯 **CHECKLIST SEBELUM PRESENTASI**

### **1 Hari Sebelum:**
- [ ] Test semua fitur di emulator
- [ ] Backup database
- [ ] Siapkan data sample yang bagus
- [ ] Rehearsal presentasi
- [ ] Siapkan backup plan (screenshot/video)

### **1 Jam Sebelum:**
- [ ] Laragon Start All
- [ ] Test API di browser
- [ ] Buka emulator/HP
- [ ] Test login admin & customer
- [ ] Test fitur bundling
- [ ] Cek internet connection

### **Saat Presentasi:**
- [ ] Laptop tercharge penuh
- [ ] Emulator/HP siap
- [ ] Backend running
- [ ] Semua anggota hadir
- [ ] Percaya diri!

---

## 🎊 **PENUTUP**

### **Key Messages:**
1. ✅ SweetBake adalah aplikasi e-commerce kue yang lengkap
2. ✅ Menggunakan teknologi modern (Flutter + PHP + MySQL)
3. ✅ Fitur unggulan: Paket Bundling dengan Bundle Cart
4. ✅ Implementasi clean, type-safe, dan maintainable
5. ✅ Ready for production!

### **Kelebihan Aplikasi:**
- 🎨 UI/UX yang menarik dan modern
- 🔒 Keamanan password dengan bcrypt
- 💾 Persistent cart dengan SharedPreferences
- 🎁 Bundle pricing untuk promo
- 🛒 Mixed cart (product + bundle)
- 📊 Dashboard analytics untuk admin
- 📱 Cross-platform (Android & iOS ready)

---

## **Semoga Sukses Presentasinya, Tim SweetBake! 🚀**

**"Bukan hanya aplikasi, tapi solusi digital untuk UMKM kue!"**

---

**Document Version:** 2.0  
**Last Updated:** May 19, 2026  
**Team:** SweetBake Development Team
