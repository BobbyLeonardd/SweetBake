# 📡 SweetBake API Documentation

Base URL: `http://localhost/sweetbake/backend/api`

---

## 🔐 Authentication

### Login
**Endpoint:** `POST /auth.php`

**Request Body:**
```json
{
  "action": "login",
  "email": "admin@sweetbake.com",
  "password": "password"
}
```

**Response Success:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "id": 1,
    "name": "Admin SweetBake",
    "email": "admin@sweetbake.com",
    "phone": null,
    "address": null,
    "role": "admin"
  }
}
```

**Response Error:**
```json
{
  "success": false,
  "message": "Invalid password"
}
```

---

### Register
**Endpoint:** `POST /auth.php`

**Request Body:**
```json
{
  "action": "register",
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "08123456789",
  "address": "Jl. Contoh No. 123"
}
```

**Response Success:**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "id": 2,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "customer"
  }
}
```

---

## 🍰 Products

### Get All Products
**Endpoint:** `GET /products.php`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "category_id": "1",
      "name": "Kue Ulang Tahun Coklat",
      "description": "Kue ulang tahun dengan lapisan coklat lembut",
      "price": "250000.00",
      "stock": "10",
      "image_url": "https://via.placeholder.com/300",
      "is_available": "1",
      "category_name": "Kue Ulang Tahun",
      "created_at": "2024-01-01 10:00:00"
    }
  ]
}
```

---

### Get Single Product
**Endpoint:** `GET /products.php?id={id}`

**Example:** `GET /products.php?id=1`

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "1",
    "category_id": "1",
    "name": "Kue Ulang Tahun Coklat",
    "description": "Kue ulang tahun dengan lapisan coklat lembut",
    "price": "250000.00",
    "stock": "10",
    "image_url": "https://via.placeholder.com/300",
    "is_available": "1",
    "category_name": "Kue Ulang Tahun"
  }
}
```

---

### Create Product (Admin Only)
**Endpoint:** `POST /products.php`

**Request Body:**
```json
{
  "category_id": 1,
  "name": "Kue Baru",
  "description": "Deskripsi kue baru",
  "price": 150000,
  "stock": 20,
  "image_url": "https://example.com/image.jpg",
  "is_available": 1
}
```

**Response:**
```json
{
  "success": true,
  "message": "Product created successfully",
  "id": 9
}
```

---

### Update Product (Admin Only)
**Endpoint:** `PUT /products.php`

**Request Body:**
```json
{
  "id": 1,
  "category_id": 1,
  "name": "Kue Updated",
  "description": "Deskripsi updated",
  "price": 200000,
  "stock": 15,
  "image_url": "https://example.com/image.jpg",
  "is_available": 1
}
```

**Response:**
```json
{
  "success": true,
  "message": "Product updated successfully"
}
```

---

### Delete Product (Admin Only)
**Endpoint:** `DELETE /products.php?id={id}`

**Example:** `DELETE /products.php?id=1`

**Response:**
```json
{
  "success": true,
  "message": "Product deleted successfully"
}
```

---

## 📦 Orders

### Get All Orders (Admin)
**Endpoint:** `GET /orders.php`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "customer_id": "2",
      "order_number": "SB202401011234",
      "total_amount": "500000.00",
      "shipping_cost": "15000.00",
      "shipping_address": "Jl. Contoh No. 123",
      "shipping_city": "Jakarta",
      "status": "pending",
      "payment_status": "unpaid",
      "customer_name": "John Doe",
      "created_at": "2024-01-01 10:00:00"
    }
  ]
}
```

---

### Get Customer Orders
**Endpoint:** `GET /orders.php?customer_id={id}`

**Example:** `GET /orders.php?customer_id=2`

---

### Get Single Order
**Endpoint:** `GET /orders.php?id={id}`

**Example:** `GET /orders.php?id=1`

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "1",
    "customer_id": "2",
    "order_number": "SB202401011234",
    "total_amount": "500000.00",
    "shipping_cost": "15000.00",
    "shipping_address": "Jl. Contoh No. 123",
    "shipping_city": "Jakarta",
    "status": "pending",
    "payment_status": "unpaid",
    "customer_name": "John Doe",
    "items": [
      {
        "id": "1",
        "order_id": "1",
        "product_id": "1",
        "quantity": "2",
        "price": "250000.00",
        "subtotal": "500000.00",
        "product_name": "Kue Ulang Tahun Coklat",
        "image_url": "https://via.placeholder.com/300"
      }
    ],
    "tracking": [
      {
        "id": "1",
        "order_id": "1",
        "status": "pending",
        "description": "Pesanan dibuat",
        "created_at": "2024-01-01 10:00:00"
      }
    ]
  }
}
```

---

### Create Order
**Endpoint:** `POST /orders.php`

**Request Body:**
```json
{
  "customer_id": 2,
  "total_amount": 500000,
  "shipping_cost": 15000,
  "shipping_address": "Jl. Contoh No. 123, Jakarta",
  "shipping_city": "Jakarta",
  "notes": "Tolong kirim pagi",
  "items": [
    {
      "product_id": 1,
      "quantity": 2,
      "price": 250000,
      "subtotal": 500000
    }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "message": "Order created successfully",
  "order_id": 1,
  "order_number": "SB202401011234"
}
```

---

### Update Order Status (Admin Only)
**Endpoint:** `PUT /orders.php`

**Request Body:**
```json
{
  "id": 1,
  "status": "confirmed",
  "description": "Pesanan dikonfirmasi dan sedang diproses"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Order status updated successfully"
}
```

**Status Options:**
- `pending` - Menunggu Konfirmasi
- `confirmed` - Dikonfirmasi
- `processing` - Diproses
- `shipped` - Dikirim
- `delivered` - Selesai
- `cancelled` - Dibatalkan

---

## 📂 Categories

### Get All Categories
**Endpoint:** `GET /categories.php`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "name": "Kue Ulang Tahun",
      "description": "Kue untuk perayaan ulang tahun",
      "created_at": "2024-01-01 10:00:00"
    },
    {
      "id": "2",
      "name": "Kue Tradisional",
      "description": "Kue-kue tradisional Indonesia",
      "created_at": "2024-01-01 10:00:00"
    }
  ]
}
```

---

## 🚚 Shipping

### Get All Shipping Costs
**Endpoint:** `GET /shipping.php`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "city": "Jakarta",
      "cost": "15000.00",
      "estimated_days": "1",
      "created_at": "2024-01-01 10:00:00"
    },
    {
      "id": "2",
      "city": "Bandung",
      "cost": "20000.00",
      "estimated_days": "2",
      "created_at": "2024-01-01 10:00:00"
    }
  ]
}
```

---

### Get Shipping Cost by City
**Endpoint:** `GET /shipping.php?city={city}`

**Example:** `GET /shipping.php?city=Jakarta`

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "1",
    "city": "Jakarta",
    "cost": "15000.00",
    "estimated_days": "1"
  }
}
```

---

## 🔧 Error Responses

### Standard Error Format
```json
{
  "success": false,
  "message": "Error message here"
}
```

### Common Error Messages
- `"Connection error: ..."` - Database connection failed
- `"User not found"` - Email tidak terdaftar
- `"Invalid password"` - Password salah
- `"Email already registered"` - Email sudah digunakan
- `"Product not found"` - Produk tidak ditemukan
- `"Order not found"` - Pesanan tidak ditemukan

---

## 📝 Notes

1. **CORS Headers** sudah di-enable untuk semua endpoint
2. **Content-Type** harus `application/json` untuk POST/PUT requests
3. **Authentication** belum menggunakan token (bisa ditambahkan JWT)
4. **File Upload** belum tersedia (bisa ditambahkan untuk gambar produk)
5. **Pagination** belum tersedia (bisa ditambahkan untuk list yang besar)

---

## 🧪 Testing dengan Postman

### Import Collection
Buat collection baru di Postman dengan endpoint-endpoint di atas.

### Environment Variables
```
base_url = http://localhost/sweetbake/backend/api
```

### Example Request
```
POST {{base_url}}/auth.php
Content-Type: application/json

{
  "action": "login",
  "email": "admin@sweetbake.com",
  "password": "password"
}
```

---

**Happy Testing! 🚀**
