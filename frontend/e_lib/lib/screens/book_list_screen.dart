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
  final String baseUrl = 'http://localhost:3000/';
  bool isLoading = true;

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
        isLoading = false;
      });
    } catch (e) {
      _logger.e('Error fetching books: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await bookService.deleteBook(bookId);
      _logger.i('Book deleted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book deleted successfully'),
          backgroundColor: Color.fromARGB(255, 17, 106, 136),
        ),
      );
      fetchBooks(); // Refresh the book list
    } catch (e) {
      _logger.e('Error deleting book: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting book: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 219, 254, 250),
        title: Text(
          'Book Management',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 21, 44),
            fontWeight: FontWeight.bold,
            fontFamily: 'Sedan',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookUploadScreen()),
                ).then((_) => fetchBooks());
              },
              icon: Icon(Icons.add),
              label: Text('Add Book'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 17, 106, 136),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 219, 254, 250),
              Colors.white,
            ],
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : books.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.library_books,
                          size: 64,
                          color: Color.fromARGB(255, 17, 106, 136),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No books available',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 0, 21, 44),
                            fontFamily: 'Sedan',
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final bookCoverUrl = baseUrl + book['bookCover'];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // View book details
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    bookCoverUrl,
                                    width: 100,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 150,
                                        color: Color.fromARGB(255, 219, 254, 250),
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Color.fromARGB(255, 17, 106, 136),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book['bookTitle'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 21, 44),
                                          fontFamily: 'Sedan',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Author: ${book['author']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(255, 17, 106, 136),
                                          fontFamily: 'Dosis',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        book['description'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          fontFamily: 'Dosis',
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            color: Color.fromARGB(255, 100, 204, 199),
                                            onPressed: () {
                                              // Edit book functionality
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text('Delete Book'),
                                                  content: Text('Are you sure you want to delete this book?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        deleteBook(book['_id']);
                                                      },
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
