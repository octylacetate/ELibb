import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class BookService {
  static final Logger _logger = Logger();
  static const baseUrl = 'http://localhost:3000/api/v1/books/';
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

  Future<Map<String, dynamic>> uploadBook(
      String bookTitle,
      Uint8List bookBytes,
      String bookFileName,
      Uint8List bookCoverBytes,
      String bookCoverFileName) async {
    final url = Uri.parse('${baseUrl}upload-book');
    var request = http.MultipartRequest('POST', url);

    try {
      request.fields['bookTitle'] = bookTitle;
      request.files.add(http.MultipartFile.fromBytes('bookPath', bookBytes,
          filename: bookFileName));
      request.files.add(http.MultipartFile.fromBytes(
          'bookCover', bookCoverBytes,
          filename: bookCoverFileName));
      request.headers.addAll(await _getHeaders());

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${responseBody.body}');

      if (response.statusCode == 200) {
        return jsonDecode(responseBody.body);
      } else {
        final errorData = jsonDecode(responseBody.body);
        _logger.e('Failed to upload book: ${errorData['message']}');
        throw Exception('Failed to upload book: ${errorData['message']}');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getAllBooks(int page) async {
    final url = Uri.parse('${baseUrl}get-books?page=$page');
    final headers = await _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to fetch books: ${errorData['message']}');
        throw Exception('Failed to fetch books: ${errorData['message']}');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getBookById(String bookId) async {
    final url = Uri.parse('${baseUrl}get-book/$bookId');
    final headers = await _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to fetch book: ${errorData['message']}');
        throw Exception('Failed to fetch book: ${errorData['message']}');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> deleteBook(String bookId) async {
    final url = Uri.parse('${baseUrl}delete-book/$bookId');
    final headers = await _getHeaders();

    try {
      final response = await http.delete(url, headers: headers);
      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.i('Book deleted successfully');
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to delete book: ${errorData['message']}');
        throw Exception('Failed to delete book: ${errorData['message']}');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }
}
