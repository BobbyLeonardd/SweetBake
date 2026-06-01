import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  // Fetch orders
  Future<void> fetchOrders({int? customerId}) async {
    _isLoading = true;
    notifyListeners();

    _orders = await ApiService.getOrders(customerId: customerId);

    _isLoading = false;
    notifyListeners();
  }

  Future<Order?> getOrder(int id) async {
    return await ApiService.getOrder(id);
  }

  // Create order
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.createOrder(orderData);

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> updateOrderStatus(
    int orderId,
    String status,
    String description,
  ) async {
    final result = await ApiService.updateOrderStatus(orderId, status, description);
    
    if (result['success']) {
      await fetchOrders();
    }
    
    return result;
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((o) => o.status == status).toList();
  }
}
