import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isCustomer => _user?.isCustomer ?? false;

  Future<void> initialize() async {
    _user = await AuthService.getUser();
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.login(email, password);

    if (result['success']) {
      _user = User.fromJson(result['data']);
      await AuthService.saveUser(_user!);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.register(data);

    if (result['success']) {
      _user = User.fromJson(result['data']);
      await AuthService.saveUser(_user!);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.updateCustomer({
      'id': _user!.id,
      ...data,
    });

    if (result['success'] && result['data'] != null) {
      _user = User.fromJson(result['data']);
      await AuthService.saveUser(_user!);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    notifyListeners();
  }
}
