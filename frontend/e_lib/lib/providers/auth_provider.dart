import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';
import '../service/apiclassusers.dart';

class AuthProvider with ChangeNotifier {
  final Logger _logger = Logger();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();

  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> loadUserData() async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      try {
        final response = await apiService.getCurrentUser();
        _user = User.fromJson(response);
        _isAuthenticated = true;
      } catch (e) {
        _logger.e('Failed to load user data: $e');
        _isAuthenticated = false;
      }
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await apiService.loginUser(email, password);
      if (response['statusCode'] == 200) {
        await storage.write(key: 'accessToken', value: response['accessToken']);
        await loadUserData();
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      _logger.e('Login error: $e');
      throw e;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'accessToken');
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
}
