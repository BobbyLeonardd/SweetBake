import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../models/bundle_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  static const _cartKey = 'sweetbake_cart';

  List<CartItem> get items => _items;
  int get itemCount => _items.length;

  List<CartItem> get productItems {
    return _items.where((item) => item.isProduct).toList();
  }

  List<CartItem> get bundleItems {
    return _items.where((item) => item.isBundle).toList();
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        final List<dynamic> decoded = jsonDecode(cartJson);
        _items.clear();
        _items.addAll(decoded.map((e) => CartItem.fromJsonFull(e)).toList());
        notifyListeners();
      }
    } catch (e) {
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_items.map((e) => e.toJsonFull()).toList());
      await prefs.setString(_cartKey, encoded);
    } catch (e) {
    }
  }

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.isProduct && item.product!.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem.fromProduct(product, quantity: quantity));
    }

    notifyListeners();
    _saveCart();
  }

  void addBundleToCart(Bundle bundle, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.isBundle && item.bundle!.id == bundle.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem.fromBundle(bundle, quantity: quantity));
    }

    notifyListeners();
    _saveCart();
  }

  void removeFromCart(int id, CartItemType type) {
    _items.removeWhere((item) => item.type == type && item.id == id);
    notifyListeners();
    _saveCart();
  }

  void removeProductFromCart(int productId) {
    removeFromCart(productId, CartItemType.product);
  }

  void removeBundleFromCart(int bundleId) {
    removeFromCart(bundleId, CartItemType.bundle);
  }

  void updateQuantity(int id, CartItemType type, int quantity) {
    final index = _items.indexWhere((item) => item.type == type && item.id == id);

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
      _saveCart();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }

  CartItem? getCartItem(int id, CartItemType type) {
    try {
      return _items.firstWhere((item) => item.type == type && item.id == id);
    } catch (e) {
      return null;
    }
  }

  CartItem? getCartItemByProductId(int productId) {
    return getCartItem(productId, CartItemType.product);
  }

  CartItem? getCartItemByBundleId(int bundleId) {
    return getCartItem(bundleId, CartItemType.bundle);
  }

  bool isInCart(int productId) {
    return _items.any((item) => item.isProduct && item.product!.id == productId);
  }

  bool isBundleInCart(int bundleId) {
    return _items.any((item) => item.isBundle && item.bundle!.id == bundleId);
  }

  int getQuantityInCart(int id, CartItemType type) {
    final item = getCartItem(id, type);
    return item?.quantity ?? 0;
  }
}
