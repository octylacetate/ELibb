import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  bool _isLoggedIn = false;
  
  bool get isLoggedIn => _isLoggedIn;

  Future<void> setLoggedIn() async {
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    _isLoggedIn = false;
    notifyListeners();
  }
}