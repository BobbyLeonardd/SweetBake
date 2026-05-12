# 📂 SweetBake Project Structure

## 🗂️ Folder Structure

```
sweetbake/
│
├── android/                    # Android native files
├── ios/                        # iOS native files
├── web/                        # Web support files
│
├── backend/                    # Backend PHP + MySQL
│   ├── api/                    # API Endpoints
│   │   ├── auth.php           # Login & Register
│   │   ├── products.php       # Product CRUD
│   │   ├── orders.php         # Order Management
│   │   ├── categories.php     # Categories
│   │   └── shipping.php       # Shipping Costs
│   │
│   ├── config/                 # Configuration
│   │   └── database.php       # Database Connection
│   │
│   ├── database/               # Database Schema
│   │   └── sweetbake.sql      # SQL Schema & Sample Data
│   │
│   └── .htaccess              # Apache Config (CORS)
│
├── lib/                        # Flutter Source Code
│   │
│   ├── config/                 # App Configuration
│   │   ├── api_config.dart    # API Base URL
│   │   └── theme_config.dart  # Theme & Colors
│   │
│   ├── models/                 # Data Models
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   ├── order_model.dart
│   │   ├── cart_item_model.dart
│   │   ├── category_model.dart
│   │   └── shipping_model.dart
│   │
│   ├── providers/              # State Management (Provider)
│   │   ├── auth_provider.dart
│   │   ├── cart_provider.dart
│   │   ├── product_provider.dart
│   │   └── order_provider.dart
│   │
│   ├── services/               # API Services
│   │   ├── api_service.dart   # HTTP Requests
│   │   └── auth_service.dart  # Local Storage
│   │
│   ├── utils/                  # Helper Functions
│   │   ├── currency_formatter.dart
│   │   └── date_formatter.dart
│   │
│   ├── views/                  # UI Pages
│   │   │
│   │   ├── admin/              # Admin Pages
│   │   │   ├── admin_dashboard_page.dart
│   │   │   ├── admin_products_page.dart
│   │   │   ├── product_form_page.dart
│   │   │   ├── admin_orders_page.dart
│   │   │   └── admin_order_detail_page.dart
│   │   │
│   │   ├── customer/           # Customer Pages
│   │   │   ├── customer_home_page.dart
│   │   │   ├── product_detail_page.dart
│   │   │   ├── cart_page.dart
│   │   │   ├── checkout_page.dart
│   │   │   ├── orders_page.dart
│   │   │   ├── order_detail_page.dart
│   │   │   └── profile_page.dart
│   │   │
│   │   └── auth/               # Authentication Pages
│   │       ├── login_page.dart
│   │       └── register_page.dart
│   │
│   ├── widgets/                # Reusable Widgets
│   │   ├── product_card.dart
│   │   ├── order_card.dart
│   │   └── loading_widget.dart
│   │
│   └── main.dart               # App Entry Point
│
├── test/                       # Unit Tests
│
├── pubspec.yaml               # Flutter Dependencies
├── README.md                  # Main Documentation
├── SETUP_GUIDE.md            # Setup Instructions
├── API_DOCUMENTATION.md      # API Reference
└── PROJECT_STRUCTURE.md      # This File
```

---

## 📱 Flutter Architecture

### Layer Architecture

```
┌─────────────────────────────────────┐
│           UI Layer (Views)          │
│  - Pages                            │
│  - Widgets                          │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│      State Management (Provider)    │
│  - AuthProvider                     │
│  - CartProvider                     │
│  - ProductProvider                  │
│  - OrderProvider                    │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│         Services Layer              │
│  - API Service (HTTP)               │
│  - Auth Service (Local Storage)    │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│         Models Layer                │
│  - Data Classes                     │
│  - JSON Serialization               │
└─────────────────────────────────────┘
```

---

## 🔄 Data Flow

### Customer Flow Example: Add to Cart

```
1. User taps "Add to Cart" button
   ↓
2. ProductDetailPage calls CartProvider.addToCart()
   ↓
3. CartProvider updates cart items list
   ↓
4. CartProvider.notifyListeners() triggers UI update
   ↓
5. UI rebuilds showing updated cart count
```

### Admin Flow Example: Update Order Status

```
1. Admin selects new status in dialog
   ↓
2. AdminOrderDetailPage calls OrderProvider.updateOrderStatus()
   ↓
3. OrderProvider calls ApiService.updateOrderStatus()
   ↓
4. ApiService sends PUT request to backend
   ↓
5. Backend updates database & adds tracking
   ↓
6. Backend returns success response
   ↓
7. OrderProvider fetches updated order list
   ↓
8. UI rebuilds showing new status
```

---

## 🗄️ Database Schema

### Tables

**users**
- id (PK)
- name
- email (unique)
- password (hashed)
- phone
- address
- role (admin/customer)
- timestamps

**products**
- id (PK)
- category_id (FK)
- name
- description
- price
- stock
- image_url
- is_available
- timestamps

**orders**
- id (PK)
- customer_id (FK)
- order_number (unique)
- total_amount
- shipping_cost
- shipping_address
- shipping_city
- status
- payment_status
- notes
- timestamps

**order_items**
- id (PK)
- order_id (FK)
- product_id (FK)
- quantity
- price
- subtotal

**order_tracking**
- id (PK)
- order_id (FK)
- status
- description
- created_at

**categories**
- id (PK)
- name
- description
- created_at

**shipping_costs**
- id (PK)
- city
- cost
- estimated_days
- timestamps

---

## 🎨 Design Patterns

### 1. Provider Pattern (State Management)
```dart
// Provider
class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  
  void addToCart(Product product) {
    _items.add(CartItem(product: product));
    notifyListeners(); // Notify UI to rebuild
  }
}

// Consumer
Consumer<CartProvider>(
  builder: (context, cart, child) {
    return Text('${cart.itemCount}');
  },
)
```

### 2. Repository Pattern (API Service)
```dart
class ApiService {
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(endpoint));
    // Parse and return data
  }
}
```

### 3. Model Pattern (Data Classes)
```dart
class Product {
  final int id;
  final String name;
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
    );
  }
}
```

---

## 🔐 Security Considerations

### Current Implementation
- ✅ Password hashing (bcrypt) in database
- ✅ SQL injection prevention (PDO prepared statements)
- ✅ CORS headers configured
- ✅ Input validation on forms

### Recommended Improvements
- ⚠️ Add JWT authentication tokens
- ⚠️ Add API rate limiting
- ⚠️ Add HTTPS/SSL in production
- ⚠️ Add input sanitization on backend
- ⚠️ Add file upload validation
- ⚠️ Add CSRF protection

---

## 📦 Dependencies

### Flutter Packages
```yaml
provider: ^6.1.1              # State management
http: ^1.2.0                  # HTTP requests
shared_preferences: ^2.2.2    # Local storage
google_fonts: ^6.1.0          # Typography
cached_network_image: ^3.3.1  # Image caching
intl: ^0.19.0                 # Internationalization
flutter_spinkit: ^5.2.0       # Loading animations
```

### Backend
- PHP 7.4+
- MySQL 5.7+
- Apache with mod_rewrite

---

## 🚀 Build & Deploy

### Development
```bash
flutter run
```

### Production Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Backend Deployment
1. Upload `backend/` folder to web server
2. Import `sweetbake.sql` to MySQL
3. Update `database.php` with production credentials
4. Enable HTTPS/SSL
5. Configure firewall rules

---

## 📊 Performance Optimization

### Implemented
- ✅ Image caching (cached_network_image)
- ✅ Lazy loading (ListView.builder)
- ✅ State management (Provider)
- ✅ Const constructors where possible

### Recommended
- ⚠️ Add pagination for large lists
- ⚠️ Implement image compression
- ⚠️ Add database indexing
- ⚠️ Use CDN for images
- ⚠️ Implement caching strategy

---

## 🧪 Testing Strategy

### Unit Tests
```dart
test/
├── models/
├── providers/
├── services/
└── utils/
```

### Widget Tests
```dart
test/
└── widgets/
```

### Integration Tests
```dart
integration_test/
└── app_test.dart
```

---

## 📝 Code Style

### Naming Conventions
- **Files:** snake_case (e.g., `product_card.dart`)
- **Classes:** PascalCase (e.g., `ProductCard`)
- **Variables:** camelCase (e.g., `productList`)
- **Constants:** camelCase (e.g., `primaryColor`)

### File Organization
- One widget per file
- Group related files in folders
- Use barrel files (index.dart) for exports

---

**Last Updated:** 2024
**Version:** 1.0.0
