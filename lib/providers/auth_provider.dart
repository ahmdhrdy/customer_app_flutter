import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final ApiService apiService = ApiService();

  User? get user => _user;

  Future<void> login(String username, String password, int comId) async {
    try {
      _user = await apiService.login(username, password, comId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void logout() {
    _user = null;
    apiService.clearToken();
    notifyListeners();
  }
}