import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _fetchedOnce = false;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get fetchedOnce => _fetchedOnce;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.getProducts();
      _products = result;
      _fetchedOnce = true;
    } catch (e) {
      _errorMessage = 'Gagal memuat produk. Periksa koneksi server.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await ApiService.getCategories();
      notifyListeners();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  List<Product> getProductsByCategory(int categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;

    return _products.where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase()) ||
      (p.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    final result = await ApiService.createProduct(productData);

    if (result['success']) {
      await fetchProducts();
    }

    return result;
  }

  Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> productData) async {
    final result = await ApiService.updateProduct(productData);

    if (result['success']) {
      await fetchProducts();
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteProduct(int id) async {
    final result = await ApiService.deleteProduct(id);

    if (result['success']) {
      await fetchProducts();
    }

    return result;
  }
}
