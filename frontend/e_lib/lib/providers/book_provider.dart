import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/book.dart';
import '../service/apiservicebooks.dart';

class BookProvider with ChangeNotifier {
  final Logger _logger = Logger();
  final BookService bookService = BookService();

  List<Book> _books = [];
  bool _isLoading = true;
  bool _isError = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  Future<void> fetchBooks() async {
    try {
      final response = await bookService.getAllBooks(1); // Assuming page 1
      _books = (response['data']['allBooks'] as List)
          .map((bookJson) => Book.fromJson(bookJson))
          .toList();
      _isLoading = false;
      _isError = false;
    } catch (error) {
      _isLoading = false;
      _isError = true;
      _logger.e('Failed to load books: $error');
    }
    notifyListeners();
  }
}
