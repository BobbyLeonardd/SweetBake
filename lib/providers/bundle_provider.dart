import 'package:flutter/material.dart';
import '../models/bundle_model.dart';
import '../services/api_service.dart';

class BundleProvider with ChangeNotifier {
  List<Bundle> _bundles = [];
  bool _isLoading = false;
  String? _error;

  List<Bundle> get bundles => _bundles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Bundle> get availableBundles {
    return _bundles.where((bundle) => bundle.isAvailable).toList();
  }

  // Fetch all bundles
  Future<void> fetchBundles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bundles = await ApiService.getBundles();
      _error = null;
    } catch (e) {
      _error = 'Gagal memuat paket bundling: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Bundle?> getBundleById(int id) async {
    try {
      return await ApiService.getBundle(id);
    } catch (e) {
      _error = 'Gagal memuat detail paket: $e';
      notifyListeners();
      return null;
    }
  }

  // Create bundle (admin)
  Future<Map<String, dynamic>> createBundle(Map<String, dynamic> bundleData) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.createBundle(bundleData);

    if (result['success']) {
      await fetchBundles();
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> updateBundle(int id, Map<String, dynamic> bundleData) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.updateBundle(id, bundleData);

    if (result['success']) {
      await fetchBundles();
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Delete bundle (admin)
  Future<Map<String, dynamic>> deleteBundle(int id) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.deleteBundle(id);

    if (result['success']) {
      _bundles.removeWhere((bundle) => bundle.id == id);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> addBundleItem(int bundleId, int productId, int quantity) async {
    final result = await ApiService.addBundleItem(bundleId, productId, quantity);

    if (result['success']) {
      await fetchBundles();
    }

    return result;
  }

  Future<Map<String, dynamic>> removeBundleItem(int bundleItemId) async {
    final result = await ApiService.removeBundleItem(bundleItemId);

    if (result['success']) {
      await fetchBundles();
    }

    return result;
  }

  // Search bundles
  List<Bundle> searchBundles(String query) {
    if (query.isEmpty) return _bundles;

    final lowerQuery = query.toLowerCase();
    return _bundles.where((bundle) {
      return bundle.name.toLowerCase().contains(lowerQuery) ||
          (bundle.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}
