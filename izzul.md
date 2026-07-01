# 👑 SKRIP PRESENTASI KHUSUS IZZUL (KETUA KELOMPOK)

Bawa catatan ini atau buka di layar sebelahnya pas presentasi biar aman dan lancar!

---

## 🎤 1. PEMBUKAAN (OPENING) - Diawal Banget
*Maju paling depan, ngomongnya santai tapi tegas karena lu ketua.*

**Skrip:**
> "Selamat pagi/siang Bapak/Ibu Dosen dan teman-teman. Kami dari tim pengembang aplikasi **SweetBake** akan mempresentasikan hasil akhir dari proyek kami.
> 
> SweetBake ini adalah Sistem Informasi Penjualan Kue (E-Commerce) yang kami bangun secara *Native*. Untuk Frontend-nya, kami menggunakan **Flutter** agar aplikasinya bisa lintas *platform* (Android/iOS). Sedangkan untuk Backend dan API-nya, kami tidak memakai framework siap saji, melainkan merakit sendiri dari nol menggunakan **PHP Native dengan konsep PDO (PHP Data Objects)** agar lebih ringan dan aman, didukung dengan database **MySQL**.
> 
> Aplikasi ini punya fitur yang sangat lengkap, mulai dari Manajemen Produk, Keranjang Belanja (*Cart*), *Checkout*, *Tracking* Pesanan, hingga fitur andalan kami yaitu **Paket Bundling**. 
> 
> Untuk demo lengkap aplikasinya dari sisi Admin dan Customer, akan dilanjutkan oleh rekan-rekan tim saya. Silakan."

---

## ❓ 2. JIKA DOSEN BERTANYA: "Tugas kamu (Izzul) bagian apa?"

**Skrip:**
> "Sebagai ketua, saya bertugas merancang fondasi inti aplikasinya pak/bu. Jadi bagian saya adalah **Core System, Arsitektur Database, dan Keamanan (Authentication)**.
>
> Saya yang membuat skema database MySQL-nya, membangun koneksi backend API-nya menggunakan PDO agar kebal dari *SQL Injection*, serta membuat sistem Login/Register di mana *password* pengguna kami enkripsi menggunakan *Bcrypt*. Saya juga yang merancang logika *Backend* untuk fitur relasi yang cukup rumit, yaitu **Paket Bundling**."

---

## 💻 3. JIKA DOSEN MENYURUH: "Coba tunjukkan kodenya dan jelaskan!"
*(Kalau dosen ngomong gini, lu buka VS Code, buka 5 file di bawah ini secara bergantian, lalu blok kode yang lagi lu jelasin pakai mouse!)*

### A. Buka File: `backend/config/database.php`
**Cara Jelasin:**
> "Ini adalah file koneksi utama ke database yang saya buat. Saya sengaja menggunakan **PDO (PHP Data Objects)**, bukan `mysqli` biasa. Alasannya adalah keamanan pak/bu. PDO mendukung *Prepared Statements*, sehingga aplikasi kami aman dari peretasan metode *SQL Injection*. Selain itu, di bagian ini saya juga mengatur **CORS headers** agar API backend ini bisa diakses dari Flutter."

### B. Buka File: `backend/api/auth.php`
**Cara Jelasin:**
> "Ini adalah file untuk mengurus Login dan Registrasi. Nah, poin pentingnya ada di sini pak/bu *(tunjuk baris tempat fungsi password_hash berada)*. Saat user mendaftar, password mereka tidak kami simpan secara mentah (*plaintext*). Saya mengenkripsinya menggunakan fungsi **`password_hash()`** bawaan PHP. Lalu saat mereka login, saya menggunakan fungsi **`password_verify()`** untuk membandingkannya. Ini adalah standar keamanan aplikasi modern."

### C. Buka File: `backend/api/bundles.php`
**Cara Jelasin:**
> "Nah yang ini adalah arsitektur Backend untuk fitur **Paket Bundling**. Ini sedikit menantang karena melibatkan relasi *One-to-Many* antara tabel `bundles` dan `bundle_items`. Saya membuat *query* dengan `LEFT JOIN` untuk mengambil data produk di dalam paket.
> 
> Lalu untuk penghapusannya, saya menerapkan konsep **Cascade Delete**. Jadi kalau Admin menghapus sebuah Paket Bundling, otomatis semua produk yang ada di dalam paket tersebut akan ikut terhapus di database. Jadi datanya tetap bersih."

### D. Buka File: `lib/config/api_config.dart`
**Cara Jelasin:**
> "File ini adalah konfigurasi inti untuk menyambungkan aplikasi Flutter dengan Backend PHP kita pak/bu. Karena saat ini kita masih di tahap *development* lokal, saya mengatur *Base URL*-nya untuk menunjuk ke IP *localhost* (*Network IP*) komputer server. Dengan memisahkan URL ini ke dalam satu *file config* khusus, nantinya saat aplikasi mau di-*deploy* ke internet (production), saya cukup mengganti satu baris kode di sini saja tanpa perlu mengubah seluruh file aplikasi."

### E. Buka File: `lib/providers/auth_provider.dart`
**Cara Jelasin:**
> "Setelah Backend-nya siap, saya menghubungkannya ke sisi Frontend (Flutter) melalui `AuthProvider` ini. Di sini saya menangani logika sesi pengguna. Saat login berhasil, API akan mengembalikan token/data *user*, lalu saya menyimpannya ke dalam **SharedPreferences**. Sehingga, apabila *customer* atau admin menutup aplikasinya dan membukanya lagi besok, mereka tidak perlu *login* ulang karena datanya sudah tersimpan persisten secara lokal."

---

## 💡 TIPS MENTAL BUAT KETUA
1. **Jangan kelihatan panik** kalau ada teman kelompok yang gagal demo atau error. Langsung ambil alih ngomong: *"Mohon maaf pak/bu, mungkin ini ada sedikit kendala koneksi lokal (IP Address) ke server kami, namun secara logika bisnis fiturnya sudah berjalan sesuai rencana."*
2. Jawab pertanyaan dengan tempo lambat. Biar kelihatan lu ngerti konsepnya, bukan ngafal.
3. Kalau ada komentar bahasa Indonesia di kodingan lu, bilang aja: *"Sengaja kami beri sedikit anotasi agar teman-teman kelompok yang lain mudah memahami alurnya saat penggabungan tugas."*

**GASS!!🔥 LAKSANAKAN PRESENTASI DENGAN GAYA TECH LEAD! 😎**
