import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class FavouriteService {
  static final Logger _logger = Logger();
  final String baseUrl = "http://localhost:3000/api/v1/favourite/";
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    String? accessToken = await storage.read(key: 'accessToken');
    _logger.d("AccessToken retrieved: $accessToken");
    if (accessToken == null || accessToken.isEmpty) {
      _logger.e("Access token is null or empty");
      throw Exception("Access token is null or empty");
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<Map<String, dynamic>> addFavourite(String bookId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${baseUrl}add-favourite/$bookId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add favourite: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getAllFavourites() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${baseUrl}get-favourites'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get favourites: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> removeFavourite(String bookId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${baseUrl}remove-favourite/$bookId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to remove favourite: ${response.body}');
    }
  }
}
