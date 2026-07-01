class ApiConfig {
  // KONFIGURASI BASE URL - SESUAIKAN DENGAN DEVICE YANG DIGUNAKAN
  // PENTING: jangan lupa ganti IP nya sesuai wifi masing-masing ya wkwk
  // Emulator Android (default)  : http://10.0.2.2/sweetbake/backend/api
  // Device Fisik (WiFi sama)    : http://192.168.x.x/sweetbake/backend/api
  //   → Cari IP komputer: buka CMD terus ketik ipconfig, liat yang IPv4
  // Windows Desktop / Web       : http://localhost/sweetbake/backend/api
  // iOS Simulator               : http://localhost/sweetbake/backend/api
  
  // uncomment salah satu aja ya guys
  static const String baseUrl = 'http://10.0.2.2/sweetbake/backend/api';

  // Endpoints (tolong jangan diganti-ganti ntar error)
  static const String authEndpoint = '$baseUrl/auth.php';
  static const String productsEndpoint = '$baseUrl/products.php';
  static const String ordersEndpoint = '$baseUrl/orders.php';
  static const String categoriesEndpoint = '$baseUrl/categories.php';
  static const String shippingEndpoint = '$baseUrl/shipping.php';
  static const String usersEndpoint = '$baseUrl/users.php';
  static const String wishlistsEndpoint = '$baseUrl/wishlists.php';
  static const String analyticsEndpoint = '$baseUrl/analytics.php';
  static const String bundlesEndpoint = '$baseUrl/bundles.php';
  static const String uploadEndpoint = '$baseUrl/upload.php';
  static const String branchesEndpoint = '$baseUrl/branches.php';
}
