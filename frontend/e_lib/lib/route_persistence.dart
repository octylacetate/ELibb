// lib/route_persistence.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RoutePersistence {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> saveLastRoute(String route) async {
    await storage.write(key: 'lastRoute', value: route);
  }

  Future<String?> getLastRoute() async {
    return await storage.read(key: 'lastRoute');
  }
}
