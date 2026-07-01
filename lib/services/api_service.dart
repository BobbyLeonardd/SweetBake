import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show debugPrint;
import '../config/api_config.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/category_model.dart';
import '../models/shipping_model.dart';
import '../models/user_model.dart';
import '../models/bundle_model.dart';
import '../models/branch_model.dart';

class ApiService {
    static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.authEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'login',
          'email': email,
          'password': password,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Tidak bisa terhubung ke server: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.authEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'register',
          ...data,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal mendaftar, cek koneksi internet: $e'};
    }
  }

    static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.productsEndpoint));
      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getProducts error: $e');
      return [];
    }
  }

  static Future<Product?> getProduct(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.productsEndpoint}?id=$id'),
      );
      final data = jsonDecode(response.body);

      if (data['success']) {
        return Product.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('getProduct error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.productsEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menambah produk: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.productsEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal mengupdate produk: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.productsEndpoint}?id=$id'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menghapus produk: $e'};
    }
  }

  static Future<List<Order>> getOrders({int? customerId}) async {
    try {
      String url = ApiConfig.ordersEndpoint;
      if (customerId != null) {
        url += '?customer_id=$customerId';
      }

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => Order.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getOrders error: $e');
      return [];
    }
  }

  static Future<Order?> getOrder(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.ordersEndpoint}?id=$id'),
      );
      final data = jsonDecode(response.body);

      if (data['success']) {
        return Order.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('getOrder error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.ordersEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Pesanan gagal dibuat: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateOrderStatus(
    int orderId,
    String status,
    String description,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.ordersEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': orderId,
          'status': status,
          'description': description,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal update status pesanan: $e'};
    }
  }

    static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.categoriesEndpoint));
      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => Category.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getCategories error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.categoriesEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(categoryData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menambah kategori: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.categoriesEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(categoryData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal update kategori: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.categoriesEndpoint}?id=$id'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menghapus kategori: $e'};
    }
  }

    static Future<List<ShippingCost>> getShippingCosts() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.shippingEndpoint));
      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => ShippingCost.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getShippingCosts error: $e');
      return [];
    }
  }

  static Future<ShippingCost?> getShippingCostByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.shippingEndpoint}?city=$city'),
      );
      final data = jsonDecode(response.body);

      if (data['success']) {
        return ShippingCost.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('getShippingCostByCity error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> createShippingCost(Map<String, dynamic> shippingData) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.shippingEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(shippingData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menambah data ongkir: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateShippingCost(Map<String, dynamic> shippingData) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.shippingEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(shippingData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal update data ongkir: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteShippingCost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.shippingEndpoint}?id=$id'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menghapus data ongkir: $e'};
    }
  }

    static Future<List<User>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.usersEndpoint));
      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => User.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getCustomers error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateCustomer(Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.usersEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal update data customer: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteCustomer(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.usersEndpoint}?id=$id'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menghapus customer: $e'};
    }
  }

    static Future<List<Product>> getWishlist(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.wishlistsEndpoint}?action=get_wishlist&user_id=$userId'),
      );
      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getWishlist error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> toggleWishlist(int userId, int productId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.wishlistsEndpoint}?action=toggle'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'product_id': productId,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal update wishlist: $e'};
    }
  }

    static Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.analyticsEndpoint));
      final data = jsonDecode(response.body);

      if (data['success']) {
        return data['data'];
      }
      return {};
    } catch (e) {
      debugPrint('getAnalytics error: $e');
      return {};
    }
  }

    static Future<List<Bundle>> getBundles() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.bundlesEndpoint));
      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => Bundle.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('getBundles error: $e');
      return [];
    }
  }

  static Future<Bundle?> getBundle(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.bundlesEndpoint}?id=$id'),
      );
      final data = jsonDecode(response.body);

      if (data['success']) {
        return Bundle.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('getBundle error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> createBundle(Map<String, dynamic> bundleData) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.bundlesEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bundleData),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menambah paket bundling: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateBundle(int id, Map<String, dynamic> bundleData) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.bundlesEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, ...bundleData}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal update paket bundling: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteBundle(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.bundlesEndpoint}?id=$id'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menghapus paket bundling: $e'};
    }
  }

  static Future<Map<String, dynamic>> addBundleItem(int bundleId, int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.bundlesEndpoint}?action=add_item'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'bundle_id': bundleId,
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menambah produk ke bundling: $e'};
    }
  }

  static Future<Map<String, dynamic>> removeBundleItem(int bundleItemId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.bundlesEndpoint}?action=remove_item&item_id=$bundleItemId'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menghapus produk dari bundling: $e'};
    }
  }

    static Future<List<Branch>> getBranches({bool activeOnly = true}) async {
    try {
      final url = activeOnly
          ? '${ApiConfig.branchesEndpoint}?active=1'
          : ApiConfig.branchesEndpoint;
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List).map((b) => Branch.fromJson(b)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('getBranches error: $e');
      return [];
    }
  }

  static Future<List<Branch>> getAllBranches() => getBranches(activeOnly: false);

  static Future<Map<String, dynamic>> createBranch(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.branchesEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menambah cabang: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateBranch(Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.branchesEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal mengupdate cabang: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteBranch(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.branchesEndpoint}?id=$id'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menghapus cabang: $e'};
    }
  }

    static Future<Map<String, dynamic>> uploadImage(String filePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.uploadEndpoint),
      );

      request.files.add(await http.MultipartFile.fromPath('image', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('uploadImage error: $e');
      return {'success': false, 'message': 'Gagal mengupload gambar: $e'};
    }
  }
}
