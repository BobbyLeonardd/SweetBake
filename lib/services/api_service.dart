import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show debugPrint;
import '../config/api_config.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/category_model.dart';
import '../models/shipping_model.dart';
import '../models/user_model.dart';

class ApiService {
  // Auth
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
      return {'success': false, 'message': 'Connection error: $e'};
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
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Products
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
      debugPrint('Error fetching products: $e');
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
      debugPrint('Error fetching product: $e');
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
      return {'success': false, 'message': 'Connection error: $e'};
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
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.productsEndpoint}?id=$id'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Orders
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
      debugPrint('Error fetching orders: $e');
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
      debugPrint('Error fetching order: $e');
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
      return {'success': false, 'message': 'Connection error: $e'};
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
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Categories
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
      debugPrint('Error fetching categories: $e');
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
      return {'success': false, 'message': 'Connection error: $e'};
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
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.categoriesEndpoint}?id=$id'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Shipping
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
      debugPrint('Error fetching shipping costs: $e');
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
      debugPrint('Error fetching shipping cost: $e');
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
      return {'success': false, 'message': 'Connection error: $e'};
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
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteShippingCost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.shippingEndpoint}?id=$id'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Users / Customers
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
      debugPrint('Error fetching customers: $e');
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
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteCustomer(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.usersEndpoint}?id=$id'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Wishlist
  static Future<List<Product>> getWishlist(int userId) async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.wishlistsEndpoint}?action=get_wishlist&user_id=$userId'));
      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching wishlist: $e');
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
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Analytics
  static Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.analyticsEndpoint));
      final data = jsonDecode(response.body);

      if (data['success']) {
        return data['data'];
      }
      return {};
    } catch (e) {
      debugPrint('Error fetching analytics: $e');
      return {};
    }
  }
}
