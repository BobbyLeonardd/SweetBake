import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    _categories = await ApiService.getCategories();

    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> categoryData) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.createCategory(categoryData);
    
    if (result['success']) {
      await fetchCategories();
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> updateCategory(Map<String, dynamic> categoryData) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.updateCategory(categoryData);
    
    if (result['success']) {
      await fetchCategories();
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> deleteCategory(int id) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.deleteCategory(id);
    
    if (result['success']) {
      await fetchCategories();
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }
}
