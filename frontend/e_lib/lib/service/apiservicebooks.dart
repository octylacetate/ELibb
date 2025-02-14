import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class BookService {
  static final Logger _logger = Logger();
  static const baseUrl = 'http://localhost:8000/api/v1/books/';
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
    String bookCoverFileName,
    String author,
    String description,
    String genre,
  ) async {
    final url = Uri.parse('${baseUrl}upload-book');
    var request = http.MultipartRequest('POST', url);

    try {
      request.fields['bookTitle'] = bookTitle;
      request.fields['author'] = author;
      request.fields['description'] = description;
      request.fields['genre'] = genre;
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

  Future<Map<String, dynamic>> getAllBooks(int page, [String? genre]) async {
    final queryParams = {
      'page': page.toString(),
      if (genre != null && genre != 'All genres') 'genre': genre,
    };
    
    final url = Uri.parse('${baseUrl}get-books').replace(queryParameters: queryParams);
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
      } else if (response.statusCode == 401) {
        // Handle unauthorized error
        throw Exception('Unauthorized. Please log in again.');
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
    _logger.d('deleeeeteee id of book: $bookId');
    try {
      final response = await http.delete(url, headers: headers);
      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.i('Book deleted successfully');
      } else {
        try {
          final errorData = jsonDecode(response.body);
          _logger.e('Failed to delete book: ${errorData['message']}');
          throw Exception('Failed to delete book: ${errorData['message']}');
        } catch (e) {
          _logger.e('Failed to delete book: ${response.body}');
          throw Exception('Failed to delete book: ${response.body}');
        }
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> updateReadingProgress(String bookId, double progress) async {
    final url = Uri.parse('http://localhost:8000/api/v1/recently-viewed/update-progress/$bookId');
    final headers = await _getHeaders();

    try {
      _logger.d('Updating reading progress at: $url');
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({'progress': progress}),
      );
      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        _logger.d('Successfully updated reading progress: $decodedResponse');
        return decodedResponse;
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to update reading progress: ${errorData['message']}');
        throw Exception('Failed to update reading progress: ${errorData['message']}');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getRecentlyViewedBooks() async {
    final url = Uri.parse('http://localhost:8000/api/v1/recently-viewed/get-recently-viewed');
    final headers = await _getHeaders();

    try {
      _logger.d('Fetching recently viewed books from: $url');
      final response = await http.get(url, headers: headers);
      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        _logger.d('Successfully decoded response: $decodedResponse');
        return decodedResponse;
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to fetch recently viewed books: ${errorData['message']}');
        throw Exception('Failed to fetch recently viewed books: ${errorData['message']}');
      }
    } catch (e) {
      _logger.e('An error occurred while fetching recently viewed books: $e');
      throw Exception('An error occurred while fetching recently viewed books: $e');
    }
  }

  Future<Map<String, dynamic>> getGenreCounts() async {
    final url = Uri.parse('${baseUrl}genre-counts');
    final headers = await _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      _logger.d('Received response with status code: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to fetch genre counts: ${errorData['message']}');
        throw Exception('Failed to fetch genre counts: ${errorData['message']}');
      }
    } catch (e) {
      _logger.e('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }
}
