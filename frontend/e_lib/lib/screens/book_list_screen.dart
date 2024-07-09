import 'package:e_lib/service/apiservicebooks.dart';
import 'package:flutter/material.dart';
import 'book_upload_screen.dart';
import 'package:logger/logger.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService bookService = BookService();
  final Logger _logger = Logger();
  List<dynamic> books = [];
  int currentPage = 1;
  final String baseUrl = 'http://localhost:3000/'; // Your base URL

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await bookService.getAllBooks(currentPage);
      setState(() {
        books = response['data']['allBooks'] as List<dynamic>;
      });
    } catch (e) {
      _logger.e('Error fetching books: $e');
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await bookService.deleteBook(bookId);
      _logger.i('Book deleted successfully');
      fetchBooks(); // Refresh the book list
    } catch (e) {
      _logger.e('Error deleting book: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookUploadScreen()),
              ).then((_) => fetchBooks());
            },
          ),
        ],
      ),
      body: books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final bookCoverUrl = baseUrl + book['bookCover'];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: book['bookCover'] != null
                        ? NetworkImage(bookCoverUrl)
                        : AssetImage('assets/logo/cat.jpeg') as ImageProvider,
                  ),
                  title: Text(book['bookTitle']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Author: ${book['author']}'),
                      Text('Description: ${book['description']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteBook(book['_id']),
                  ),
                );
              },
            ),
    );
  }
}
