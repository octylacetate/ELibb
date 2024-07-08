import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class ApiService {
  static final Logger _logger = Logger();
  static const baseUrl = 'http://localhost:3000/api/v1/users/';
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

  Future<Map<String, dynamic>> registerUser(
      String username,
      String email,
      String password,
      String fullName,
      String phoneNumber,
      String bio,
      Uint8List avatar,
      String fileName) async {
    final url = Uri.parse('${baseUrl}register');
    var request = http.MultipartRequest('POST', url);

    try {
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['fullName'] = fullName;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['bio'] = bio;

      request.files.add(
          http.MultipartFile.fromBytes('avatar', avatar, filename: fileName));
      request.headers.addAll({'Content-Type': 'multipart/form-data'});

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${responseBody.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody.body);
        final accessToken = jsonResponse['data']['accessToken'];
        final refreshToken = jsonResponse['data']['refreshToken'];

        if (accessToken != null && refreshToken != null) {
          await storage.write(key: 'accessToken', value: accessToken);
          await storage.write(key: 'refreshToken', value: refreshToken);
          _logger.i('User registered successfully');
          _logger.d('Stored Access Token: $accessToken');
          _logger.d('Stored Refresh Token: $refreshToken');
          return {'statusCode': 200, 'message': 'User registered successfully'};
        } else {
          _logger.e('Access or refresh token is missing in the response');
          return {
            'statusCode': 500,
            'message': 'Access or refresh token is missing in the response'
          };
        }
      } else {
        final errorData = jsonDecode(responseBody.body);
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

    _logger.d('Sending login request to $url with email: $email');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['data']['accessToken'];
        final refreshToken = data['data']['refreshToken'];

        _logger.d('Extracted Access Token: $accessToken');
        _logger.d('Extracted Refresh Token: $refreshToken');

        if (accessToken != null && refreshToken != null) {
          await storage.write(key: 'accessToken', value: accessToken);
          await storage.write(key: 'refreshToken', value: refreshToken);
          _logger.i('User logged in successfully');
          _logger.d('Stored Access Token: $accessToken');
          _logger.d('Stored Refresh Token: $refreshToken');
          return {'statusCode': 200};
        } else {
          _logger.e('Access or refresh token is null');
          return {
            'statusCode': 500,
            'message': 'Access or refresh token is null'
          };
        }
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to login user: ${errorData['message']}');
        return {
          'statusCode': response.statusCode,
          'message': errorData['message'] ?? 'Failed to login user'
        };
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      return {'statusCode': 500, 'message': 'An error occurred'};
    }
  }

  Future<void> logoutUser() async {
    final url = Uri.parse('${baseUrl}logout');

    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        await storage.delete(key: 'accessToken');
        await storage.delete(key: 'refreshToken');
        _logger.i('User logged out successfully');
      } else {
        _logger.e('Failed to logout user');
        throw Exception('Failed to logout user');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('Failed to logout user');
    }
  }

  Future<void> refreshAccessToken() async {
    final url = Uri.parse('${baseUrl}refresh-token');
    final refreshToken = await storage.read(key: 'refreshToken');

    if (refreshToken == null) {
      _logger.e('Refresh token is null');
      throw Exception('Refresh token is null');
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'accessToken', value: data['accessToken']);
        await storage.write(key: 'refreshToken', value: data['refreshToken']);
        _logger.i('Access token refreshed successfully');
      } else {
        _logger.e('Failed to refresh access token');
        throw Exception('Failed to refresh access token');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('Failed to refresh access token');
    }
  }

  Future<void> changeCurrentPassword(
      String oldPassword, String newPassword) async {
    final url = Uri.parse('${baseUrl}change-password');

    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        _logger.i('Password changed successfully');
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to change password: ${errorData['message']}');
        throw Exception('Failed to change password: ${errorData['message']}');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('Failed to change password');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final url = Uri.parse('${baseUrl}current-user');
    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _logger.i('User Data: ${data['user']}');
      return data['data'];
    } else {
      throw Exception('Failed to fetch current user');
    }
  }

  Future<http.Response> updateUserAvatar(
      Uint8List imageBytes, String fileName) async {
    final url = Uri.parse('${baseUrl}update-avatar');
    final request = http.MultipartRequest('PATCH', url);

    request.headers.addAll(await _getHeaders());

    request.files.add(
      http.MultipartFile.fromBytes(
        'avatar',
        imageBytes,
        filename: fileName,
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logger.d('Server Response: ${response.statusCode}');
      _logger.d('Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update avatar');
      }

      return response;
    } catch (e) {
      _logger.e('Failed to update profile picture: $e');
      throw Exception('Failed to update avatar');
    }
  }

  Future<Map<String, dynamic>> updateAccountDetails(String username,
      String email, String fullName, String phoneNumber, String bio) async {
    final url = Uri.parse('${baseUrl}update-account');
    final headers = await _getHeaders();
    final body = jsonEncode({
      'username': username,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'bio': bio,
    });

    final response = await http.patch(url, headers: headers, body: body);
    return jsonDecode(response.body);
  }

  Future<void> updateUserCoverImage(String coverImagePath) async {
    final url = Uri.parse('$baseUrl/update-cover-image');
    var request = http.MultipartRequest('POST', url);

    try {
      request.headers.addAll(await _getHeaders());
      request.files
          .add(await http.MultipartFile.fromPath('coverImage', coverImagePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        _logger.i('Cover image updated successfully');
      } else {
        _logger.e('Failed to update cover image');
        throw Exception('Failed to update cover image');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('Failed to update cover image');
    }
  }

  Future<Map<String, dynamic>> getUserChannelProfile(String username) async {
    final url = Uri.parse('$baseUrl/user/$username');

    try {
      final response = await http.get(
        url,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        _logger
            .e('Failed to fetch user channel profile: ${errorData['message']}');
        throw Exception('Failed to fetch user channel profile');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('Failed to fetch user channel profile');
    }
  }

  Future<List<dynamic>> getReadHistory() async {
    final url = Uri.parse('$baseUrl/read-history');

    try {
      final response = await http.get(
        url,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to fetch read history: ${errorData['message']}');
        throw Exception('Failed to fetch read history');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('Failed to fetch read history');
    }
  }

  getAllBooks(int i) {}
}
