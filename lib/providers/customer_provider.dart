import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class CustomerProvider with ChangeNotifier {
  List<User> _customers = [];
  bool _isLoading = false;

  List<User> get customers => _customers;
  bool get isLoading => _isLoading;

  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();

    _customers = await ApiService.getCustomers();

    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> updateCustomer(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.updateCustomer(userData);
    
    if (result['success']) {
      await fetchCustomers();
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> deleteCustomer(int id) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.deleteCustomer(id);
    
    if (result['success']) {
      await fetchCustomers();
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }
}
