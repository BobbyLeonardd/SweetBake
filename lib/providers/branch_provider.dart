import 'package:flutter/foundation.dart';
import '../models/branch_model.dart';
import '../services/api_service.dart';

class BranchProvider extends ChangeNotifier {
  List<Branch> _branches = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Branch> get branches => _branches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBranches({bool activeOnly = true}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _branches = activeOnly
          ? await ApiService.getBranches(activeOnly: true)
          : await ApiService.getAllBranches();
    } catch (e) {
      _errorMessage = 'Gagal memuat data cabang';
      debugPrint('fetchBranches error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllBranches() => fetchBranches(activeOnly: false);

  Future<Map<String, dynamic>> createBranch(Map<String, dynamic> data) async {
    final result = await ApiService.createBranch(data);
    if (result['success'] == true) await fetchAllBranches();
    return result;
  }

  Future<Map<String, dynamic>> updateBranch(Map<String, dynamic> data) async {
    final result = await ApiService.updateBranch(data);
    if (result['success'] == true) await fetchAllBranches();
    return result;
  }

  Future<Map<String, dynamic>> deleteBranch(int id) async {
    final result = await ApiService.deleteBranch(id);
    if (result['success'] == true) await fetchAllBranches();
    return result;
  }
}
