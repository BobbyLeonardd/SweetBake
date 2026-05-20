# Fitur Bundling - SweetBake

## Apa itu Bundling?

Bundling itu fitur paket kue dengan harga promo. Admin bisa bikin paket yang isinya beberapa kue dengan harga lebih murah dari harga normal. Customer bisa beli paket ini dan tambahin ke keranjang kayak produk biasa.

Contoh: "Paket Hemat Lebaran" isi 3 jenis kue, harga normal Rp 250.000, dijual Rp 199.000 (hemat 20%).

## Fitur

### Admin:
- Buat paket bundling baru
- Tambah produk ke dalam bundling
- Atur harga normal dan harga promo (diskon otomatis kehitung)
- Edit dan hapus paket bundling
- Kelola produk dalam bundling

### Customer:
- Lihat paket bundling di halaman home
- Detail paket bundling dengan daftar produk
- Lihat persentase diskon dan total hemat
- Tambah bundling ke keranjang
- Update quantity bundling di keranjang
- Checkout bundling bareng produk biasa (mixed cart)

## Database

### Tabel `bundles`
```sql
CREATE TABLE `bundles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `original_price` decimal(10,2) NOT NULL,
  `promo_price` decimal(10,2) NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
```

### Tabel `bundle_items`
```sql
CREATE TABLE `bundle_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bundle_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`bundle_id`) REFERENCES `bundles` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
);
```

## File Structure

### Backend:
- `backend/api/bundles.php` - REST API untuk bundling
- `backend/database/bundles_migration.sql` - SQL migration

### Models:
- `lib/models/bundle_model.dart` - Model Bundle dan BundleItem
- `lib/models/cart_item_model.dart` - Model CartItem (support product & bundle)

### Providers:
- `lib/providers/bundle_provider.dart` - State management bundling
- `lib/providers/cart_provider.dart` - State management cart (support bundle)

### Views Admin:
- `lib/views/admin/admin_bundles_page.dart` - Halaman kelola bundling
- `lib/views/admin/admin_bundle_items_page.dart` - Kelola produk dalam bundle

### Views Customer:
- `lib/views/customer/bundle_detail_page.dart` - Detail paket bundling
- `lib/views/customer/cart_page.dart` - Keranjang (support bundle)

### Widgets:
- `lib/widgets/bundle_card.dart` - Card component untuk bundling

## API Endpoints

### GET `/api/bundles.php`
Ambil semua bundling

### GET `/api/bundles.php?id=1`
Ambil detail bundling by ID

### POST `/api/bundles.php`
Buat bundling baru
```json
{
  "name": "Paket Hemat",
  "description": "Deskripsi",
  "original_price": 250000,
  "promo_price": 199000,
  "is_available": 1
}
```

### PUT `/api/bundles.php`
Update bundling

### DELETE `/api/bundles.php?id=1`
Hapus bundling

### POST `/api/bundles.php?action=add_item`
Tambah produk ke bundling
```json
{
  "bundle_id": 1,
  "product_id": 5,
  "quantity": 2
}
```

### DELETE `/api/bundles.php?action=remove_item&item_id=1`
Hapus produk dari bundling

## Cara Install

### 1. Setup Database
Buka phpMyAdmin, pilih database `sweetbake`, klik tab SQL, copy-paste SQL di atas (tabel bundles dan bundle_items), klik Go.

### 2. Update Flutter
```bash
flutter pub get
```

### 3. Restart Aplikasi
```bash
flutter run
```

## Cara Pakai

### Admin:
1. Login admin
2. Klik menu "Kelola Paket Bundling"
3. Klik "+ Tambah Paket"
4. Isi nama, deskripsi, harga normal, harga promo
5. Simpan
6. Klik menu ⋮ → "Kelola Produk" buat nambahin produk ke paket

### Customer:
1. Login customer
2. Scroll ke section "Paket Bundling" di home
3. Klik card bundling buat lihat detail
4. Klik "Tambah ke Keranjang"
5. Lihat di keranjang, bisa update quantity atau hapus
6. Checkout bareng produk lain

## Implementasi Teknis

### CartItem Model
Model `CartItem` sekarang support 2 tipe: Product dan Bundle. Pake enum `CartItemType` buat type safety.

```dart
enum CartItemType { product, bundle }

class CartItem {
  final Product? product;
  final Bundle? bundle;
  final CartItemType type;
  int quantity;
  
  // Constructor untuk product
  factory CartItem.fromProduct(Product product, {int quantity = 1})
  
  // Constructor untuk bundle
  factory CartItem.fromBundle(Bundle bundle, {int quantity = 1})
}
```

### Cart Persistence
Cart disimpen ke `SharedPreferences` biar ga hilang pas app ditutup. Support product dan bundle.

### Mixed Cart
Customer bisa checkout product dan bundle sekaligus dalam satu transaksi.

## Troubleshooting

### Error: "Tabel bundles tidak ditemukan"
Jalankan SQL migration di phpMyAdmin.

### Bundling ga muncul di home
1. Pastikan ada data bundling di database
2. Pastikan `is_available = 1`
3. Restart aplikasi

### API bundles.php not found
1. Pastikan file `backend/api/bundles.php` ada
2. Cek base URL di `api_config.dart`
3. Restart Laragon/XAMPP

## Contoh Data

```
Nama: Paket Hemat Lebaran
Deskripsi: Paket spesial untuk merayakan Lebaran
Harga Normal: Rp 250.000
Harga Promo: Rp 199.000
Diskon: 20%
Hemat: Rp 51.000

Isi Paket:
- 2x Nastar Premium (Rp 75.000)
- 1x Kastengel Keju (Rp 85.000)
- 1x Putri Salju (Rp 90.000)
```

## Yang Bisa Ditambah Nanti

- Upload gambar bundling
- Filter bundling by kategori
- Bundling terlaris
- Notifikasi bundling baru
- Wishlist bundling
- Review bundling
- Bundle stock management
