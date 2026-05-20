# SweetBake API Documentation

Base URL: `http://localhost/sweetbake/backend/api`

Semua response menggunakan format JSON:
```json
{ "success": true/false, "data": ..., "message": "..." }
```

---

## Authentication

### Login
**Endpoint:** `POST /auth.php`

Request:
```json
{
  "action": "login",
  "email": "admin@sweetbake.com",
  "password": "password"
}
```

Response sukses:
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "id": 1,
    "name": "Admin SweetBake",
    "email": "admin@sweetbake.com",
    "role": "admin"
  }
}
```

---

### Register
**Endpoint:** `POST /auth.php`

Request:
```json
{
  "action": "register",
  "name": "Budi Santoso",
  "email": "budi@example.com",
  "password": "password123",
  "phone": "08123456789",
  "address": "Jl. Mawar No. 5, Bandung"
}
```

---

## Products

### Ambil semua produk
`GET /products.php`

### Ambil satu produk
`GET /products.php?id=1`

### Tambah produk (Admin)
`POST /products.php`

Request:
```json
{
  "category_id": 1,
  "name": "Kue Lapis Surabaya",
  "description": "Kue lapis klasik dengan lapisan coklat dan vanila",
  "price": 180000,
  "stock": 15,
  "image_url": "https://example.com/gambar.jpg",
  "is_available": 1
}
```

### Update produk (Admin)
`PUT /products.php` — sama seperti POST, tambahkan field `id`

### Hapus produk (Admin)
`DELETE /products.php?id=1`

---

## Orders

### Semua pesanan (Admin)
`GET /orders.php`

### Pesanan milik customer tertentu
`GET /orders.php?customer_id=2`

### Detail satu pesanan
`GET /orders.php?id=1`

Response menyertakan detail item dan riwayat tracking:
```json
{
  "success": true,
  "data": {
    "id": "1",
    "order_number": "SB202401011234",
    "total_amount": "500000.00",
    "shipping_cost": "15000.00",
    "shipping_city": "Bandung",
    "status": "pending",
    "items": [ ... ],
    "tracking": [ ... ]
  }
}
```

### Buat pesanan baru
`POST /orders.php`

Request:
```json
{
  "customer_id": 2,
  "total_amount": 500000,
  "shipping_cost": 20000,
  "shipping_address": "Jl. Mawar No. 5, Bandung",
  "shipping_city": "Bandung",
  "notes": "Tolong dikemas rapi",
  "items": [
    { "product_id": 1, "quantity": 2, "price": 250000, "subtotal": 500000 }
  ]
}
```

### Update status pesanan (Admin)
`PUT /orders.php`

Request:
```json
{
  "id": 1,
  "status": "confirmed",
  "description": "Pesanan sudah dikonfirmasi, mulai diproses"
}
```

Status yang tersedia: `pending` → `confirmed` → `processing` → `shipped` → `delivered` / `cancelled`

---

## Categories

### Ambil semua kategori
`GET /categories.php`

Response:
```json
{
  "success": true,
  "data": [
    { "id": "1", "name": "Kue Ulang Tahun", "description": "..." },
    { "id": "2", "name": "Kue Tradisional", "description": "..." }
  ]
}
```

---

## Shipping

### Semua data ongkos kirim
`GET /shipping.php`

### Ongkos kirim untuk kota tertentu
`GET /shipping.php?city=Bandung`

Response:
```json
{
  "success": true,
  "data": {
    "city": "Bandung",
    "cost": "20000.00",
    "estimated_days": "2"
  }
}
```

---

## Error Response

Format error:
```json
{
  "success": false,
  "message": "Pesan error di sini"
}
```

Pesan error umum:
- `"User not found"` — email tidak terdaftar
- `"Invalid password"` — password salah
- `"Email already registered"` — email sudah dipakai
- `"Product not found"` — produk tidak ditemukan
- `"Connection error: ..."` — koneksi database bermasalah

---

## Catatan

- CORS header sudah diaktifkan di semua endpoint
- Untuk request POST dan PUT, gunakan `Content-Type: application/json`
- Belum ada JWT / token authentication (bisa ditambahkan nanti)
- Belum ada fitur upload gambar (gambar pakai URL)
