import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class ApiService {
  static final Logger _logger = Logger();
  int port = 54911;
  static const baseUrl =
      'http://localhost:8000/api/v1/user/'; // Replace with your server URL
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    String? accessToken = await storage.read(key: 'accessToken');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<Map<String, dynamic>> registerUser(
      String username, String email, String password) async {
    var baseUrl = 'http://localhost:8000/api/v1/user/';
    final url = Uri.parse('${baseUrl}register');

    _logger.d(
        'Sending request to $url with email: $email, username: $username , password: $password');

    try {
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json', // Set the content-type header
          },
          body: jsonEncode({
            'username': username,
            'email': email,
            'password': password,
          }));

      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'accessToken', value: data['accessToken']);
        await storage.write(key: 'refreshToken', value: data['refreshToken']);
        _logger.i('User registered successfully');
        return {'statusCode': 200, 'message': 'User registered successfully'};
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to register user: ${errorData['message']}');
        return {
          'statusCode': response.statusCode,
          'message': errorData['message'] ?? 'Failed to register user'
        };
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      return {'statusCode': 500, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('${baseUrl}login');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'accessToken', value: data['accessToken']);
      await storage.write(key: 'refreshToken', value: data['refreshToken']);
      return {'statusCode': 200};
    } else {
      throw Exception('Failed to login user');
    }
  }

  Future<void> logoutUser() async {
    final url = Uri.parse('$baseUrl/logout');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'refreshToken');
    } else {
      throw Exception('Failed to logout user');
    }
  }

  Future<void> refreshAccessToken() async {
    final url = Uri.parse('$baseUrl/refresh-token');
    final refreshToken = await storage.read(key: 'refreshToken');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'accessToken', value: data['accessToken']);
      await storage.write(key: 'refreshToken', value: data['refreshToken']);
    } else {
      throw Exception('Failed to refresh access token');
    }
  }

  Future<void> changeCurrentPassword(
      String oldPassword, String newPassword) async {
    final url = Uri.parse('$baseUrl/change-password');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Password changed successfully
    } else {
      throw Exception('Failed to change password');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final url = Uri.parse('$baseUrl/user');
    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch current user');
    }
  }

  Future<void> updateAccountDetails(String fullName, String email) async {
    final url = Uri.parse('$baseUrl/update-account');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      // Account details updated successfully
    } else {
      throw Exception('Failed to update account details');
    }
  }

  Future<void> updateUserAvatar(String avatarPath) async {
    final url = Uri.parse('$baseUrl/update-avatar');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(await _getHeaders());
    request.files.add(await http.MultipartFile.fromPath('avatar', avatarPath));

    final response = await request.send();

    if (response.statusCode == 200) {
      // Avatar updated successfully
    } else {
      throw Exception('Failed to update avatar');
    }
  }

  Future<void> updateUserCoverImage(String coverImagePath) async {
    final url = Uri.parse('$baseUrl/update-cover-image');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(await _getHeaders());
    request.files
        .add(await http.MultipartFile.fromPath('coverImage', coverImagePath));

    final response = await request.send();

    if (response.statusCode == 200) {
      // Cover image updated successfully
    } else {
      throw Exception('Failed to update cover image');
    }
  }

  Future<Map<String, dynamic>> getUserChannelProfile(String username) async {
    final url = Uri.parse('$baseUrl/user/$username');
    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user channel profile');
    }
  }

  Future<List<dynamic>> getReadHistory() async {
    final url = Uri.parse('$baseUrl/read-history');
    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch read history');
    }
  }
}
