class ApiConfig {
  // Ganti dengan IP address komputer Anda jika testing di device fisik
  // Untuk emulator Android gunakan: 10.0.2.2
  // Untuk iOS simulator gunakan: localhost
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
}
