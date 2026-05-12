import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  // Fetch products
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await ApiService.getProducts();

    _isLoading = false;
    notifyListeners();
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    _categories = await ApiService.getCategories();
    notifyListeners();
  }

  // Get products by category
  List<Product> getProductsByCategory(int categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  // Search products
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    return _products.where((p) => 
      p.name.toLowerCase().contains(query.toLowerCase()) ||
      (p.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  // Create product (Admin)
  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    final result = await ApiService.createProduct(productData);
    
    if (result['success']) {
      await fetchProducts();
    }
    
    return result;
  }

  // Update product (Admin)
  Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> productData) async {
    final result = await ApiService.updateProduct(productData);
    
    if (result['success']) {
      await fetchProducts();
    }
    
    return result;
  }

  // Delete product (Admin)
  Future<Map<String, dynamic>> deleteProduct(int id) async {
    final result = await ApiService.deleteProduct(id);
    
    if (result['success']) {
      await fetchProducts();
    }
    
    return result;
  }
}
