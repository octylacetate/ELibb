import 'package:flutter/foundation.dart';
import 'package:e_lib/service/apiservicebooks.dart';

class BooksProvider with ChangeNotifier {
  final BookService _bookService = BookService();
  List<dynamic> _books = [];
  bool _isLoading = true;
  bool _isError = false;
  
  List<dynamic> get books => _books;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  Future<void> fetchBooks() async {
    try {
      final response = await _bookService.getAllBooks(1);
      _books = response['data']['allBooks'];
      _isLoading = false;
      _isError = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _bookService.deleteBook(bookId);
      await fetchBooks();
    } catch (e) {
      _isError = true;
      notifyListeners();
    }
  }
} 