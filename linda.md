# 👩‍💻 SKRIP PRESENTASI KHUSUS LINDA (ADMIN CATALOG & BUNDLE MANAGEMENT)

Tugas kamu cukup banyak dan jadi inti presentasi dari sisi **Admin**. Pastikan saat demo, gerakan _mouse_ kamu lancar dan nggak buru-buru, sambil menjelaskan alur di bawah ini.

---

## 🎬 1. SKRIP DEMO APLIKASI (5 MENIT)
*Maju setelah Izzul selesai opening. Di sini kamu akan mendemokan keseluruhan sisi Admin.*

### A. Login & Dashboard (1 Menit)
> "Selamat pagi/siang. Saya Linda, bertugas untuk mengelola aplikasi dari sisi **Admin Panel**. 
> Pertama, kita login menggunakan akun Admin. *(Klik tombol login)*. 
> Setelah masuk, Admin disambut oleh **Dashboard Statistik** yang menampilkan ringkasan data penting, seperti total pesanan, total pendapatan, dan jumlah pelanggan secara *real-time*."

### B. Kelola Kategori & Produk (1.5 Menit)
> "Selanjutnya, kita masuk ke menu **Kategori**. Di sini Admin bisa menambah kategori baru untuk kue. Kami sudah menambahkan validasi *database* di mana kategori tidak bisa sembarangan dihapus jika masih ada produk di dalamnya, demi menjaga keutuhan data.
> 
> Beralih ke menu **Produk**, Admin bisa melakukan fungsi *CRUD* secara lengkap. Mari kita demokan dengan menambah/mengedit satu produk." 
> *(Aksi: Tunjukkan sekilas form tambah produk atau coba edit harga satu produk)*. 
> "Semua perubahan ini akan otomatis ter-*update* berkat penggunaan `Provider` di Flutter."

### C. Kelola Paket Bundling (2.5 Menit) - **Fitur Utama!**
> "Inovasi utama di aplikasi ini ada di menu **Paket Bundling**. Ini memungkinkan Admin membuat promo gabungan beberapa kue sekaligus. Mari kita buat satu paket baru."
> *(Aksi: Klik 'Tambah Paket', isi form)*
> 
> "Di form ini, saya merancang UI khusus agar Admin bisa menetapkan *Harga Normal* dan *Harga Promo*. Kami juga menambahkan fitur **Upload Gambar** yang fleksibel. Admin bisa menggunakan link URL dari internet, atau meng-upload foto langsung dari penyimpanan komputer (*Lokal*)."
> *(Aksi: Coba pilih gambar lokal / masukin link URL lalu simpan)*
> 
> "Setelah paket bundling berhasil dibuat, tahap terakhir adalah menentukan isinya. Admin tinggal masuk ke halaman **Kelola Produk Bundling** dan mencentang/menambahkan kue apa saja yang masuk ke dalam paket promo tersebut."
> *(Aksi: Tambah 2 atau 3 produk ke dalam paket yang baru dibuat).*

---

## ❓ 2. JIKA DOSEN BERTANYA: "Tugas kamu (Linda) bagian apa?"

**Skrip Jawaban:**
> "Bagian saya sangat berfokus pada **Admin Catalog Management dan Antarmuka Pengguna (UI)** pak/bu. 
> 
> Saya bertanggung jawab penuh mengatur seluruh logika CRUD (Create, Read, Update, Delete) untuk Produk, Kategori, dan fitur andalan **Paket Bundling**. Selain mendesain halaman halamannya di Flutter (`admin_products_page.dart` hingga `bundle_form_page.dart`), saya juga bertugas mengaitkannya (*integrate*) ke *Backend* menggunakan *State Management Provider*, serta memastikan fungsi validasi form dan *Upload Gambar* dari perangkat lokal berjalan dengan lancar."

---

## 💻 3. JIKA DOSEN MENYURUH: "Coba tunjukkan kodenya dan jelaskan!"
*(Buka file di VS Code sesuai yang ditanyakan dosen. Ini daftar contekan argumennya!)*

### 1. File Backend API: `backend/api/products.php`
> "Untuk API Produk, saya merancangnya menggunakan metode **RESTful API**. Di bagian awal kode *(tunjuk baris `if ($method == 'POST')` dll)*, saya menggunakan `$_SERVER['REQUEST_METHOD']` untuk mengecek *request*. `GET` untuk menarik data, `POST` untuk menambah, dan `PUT/DELETE` untuk edit/hapus. Semua datanya di-*parsing* dari dan ke format JSON."

### 2. File Backend API: `backend/api/categories.php`
> "Sama seperti API Produk, API Kategori ini juga *RESTful*. Namun di sini saya menambahkan logika **Validasi Relasi**. Saat fungsi *DELETE* dipanggil, sistem akan mengecek dulu apakah masih ada produk yang menggunakan kategori ini. Jika ada, maka penghapusan akan ditolak demi menjaga integritas data."

### 3. File State Management: `lib/providers/product_provider.dart`
> "Untuk mengatur data produk dan kategori di aplikasi, saya menggunakan `Provider`. Jadi ketika Admin melakukan *delete* atau *create* dari UI, Provider akan memanggil API, lalu memanggil fungsi `notifyListeners()`. Hal ini membuat halaman aplikasi me-*reload* tampilannya otomatis tanpa perlu di-*refresh* paksa."

### 4. File State Management: `lib/providers/bundle_provider.dart`
> "Provider ini khusus menangani *State* untuk **Paket Bundling**. Logikanya sedikit lebih kompleks karena Provider ini harus mengurus dua hal sekaligus: pembuatan *Parent Bundle*-nya, dan pengaturan *Item* apa saja yang masuk ke dalam *Bundle* tersebut."

### 5. File UI: `lib/views/admin/admin_products_page.dart`
> "Ini adalah halaman UI untuk manajemen produk pak/bu. Saya menggunakan *ListView* untuk menampilkan daftar kuenya. Kalau Admin klik tombol *tambah* atau *edit*, akan muncul form untuk mengisi nama, harga, deskripsi, dan kategori dari produk tersebut."

### 6. File UI: `lib/views/admin/admin_bundles_page.dart`
> "Halaman ini khusus untuk menampilkan daftar **Paket Bundling**. Di UI ini, saya sudah mengatur agar sistem menghitung dan menampilkan persentase diskon secara otomatis berdasarkan perbandingan *Harga Normal* dan *Harga Promo* yang dimasukkan Admin."

### 7. File UI: `lib/views/admin/admin_bundle_items_page.dart`
> "Setelah paket bundling dibuat, Admin akan diarahkan ke halaman UI ini. Halaman ini berfungsi untuk memilih dan mengelola kue apa saja yang dimasukkan ke dalam paket *(Bundle Items)*. Admin cukup mencentang atau menambah *quantity* kue yang diinginkan, dan datanya akan langsung terkirim ke *database*."

---

## 💡 TIPS MENTAL BUAT LINDA
1. **Lancar Mainin Mouse:** Karena bagian kamu adalah yang paling banyak demo input data, pastikan tangan lu luwes pas ngeklik dan ngetik. Jangan kaku biar dosen yakin lu yang bikin fiturnya.
2. **Kuasai Istilah "RESTful":** Kalau ditanya dosen *"Apa itu RESTful?"* Jawab: *"Itu arsitektur standar pembuatan API pak/bu, yang membedakan fungsinya (seperti simpan, edit, hapus) berdasarkan tipe HTTP (GET, POST, PUT, DELETE)."*
3. **Pede sama UI-nya:** Sisi Admin adalah sisi yang fiturnya paling lengkap dan paling rapi di aplikasi ini. Banggakan hasil karyamu! Semangat Lin! 🚀
