import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class WishlistProvider with ChangeNotifier {
  List<Product> _wishlist = [];
  bool _isLoading = false;

  List<Product> get wishlist => _wishlist;
  bool get isLoading => _isLoading;

  bool isFavorite(int productId) {
    return _wishlist.any((p) => p.id == productId);
  }

  Future<void> fetchWishlist(int userId) async {
    _isLoading = true;
    notifyListeners();

    _wishlist = await ApiService.getWishlist(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> toggleWishlist(int userId, int productId) async {
    final result = await ApiService.toggleWishlist(userId, productId);
    
    if (result['success']) {
      // Refresh wishlist after toggle
      await fetchWishlist(userId);
    }
    
    return result;
  }
}
