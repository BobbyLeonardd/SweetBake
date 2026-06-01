class ApiConfig {
    // KONFIGURASI BASE URL - SESUAIKAN DENGAN DEVICE YANG DIGUNAKAN
    // Emulator Android (default)  : http://10.0.2.2/sweetbake/backend/api
  // Device Fisik (WiFi sama)    : http://192.168.x.x/sweetbake/backend/api
  //   → Cari IP komputer: jalankan `ipconfig` di CMD, lihat IPv4 Address
  // Windows Desktop / Web       : http://localhost/sweetbake/backend/api
  // iOS Simulator               : http://localhost/sweetbake/backend/api
    static const String baseUrl = 'http://10.0.2.2/sweetbake/backend/api';

  // Endpoints
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
