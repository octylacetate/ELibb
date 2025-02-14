import 'package:e_lib/service/apiservicebooks.dart';
import 'package:flutter/material.dart';
import 'book_upload_screen.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;
import '../book_detail_screen.dart';

// Import color constants from main.dart
const primaryColor = Color.fromARGB(255, 219, 254, 250);
const secondaryColor = Color.fromARGB(255, 17, 106, 136);
const accentColor = Color.fromARGB(255, 100, 204, 199);
const textDarkColor = Color.fromARGB(255, 0, 21, 44);
const warmAccentColor = Color.fromARGB(255, 255, 183, 77);
const coralAccentColor = Color.fromARGB(255, 255, 127, 80);
const darkPrimaryColor = Color.fromARGB(255, 176, 223, 219);
const subtleBackgroundColor = Color.fromARGB(20, 17, 106, 136);

const primaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [primaryColor, darkPrimaryColor],
);

const accentGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [warmAccentColor, coralAccentColor],
);

class BookHoverPreview extends StatefulWidget {
  final Map<String, dynamic> book;
  final String baseUrl;

  const BookHoverPreview({
    Key? key,
    required this.book,
    required this.baseUrl,
  }) : super(key: key);

  @override
  _BookHoverPreviewState createState() => _BookHoverPreviewState();
}

class _BookHoverPreviewState extends State<BookHoverPreview> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: isHovered ? (Matrix4.identity()..translate(0, -10)) : Matrix4.identity(),
        child: Card(
          elevation: isHovered ? 16 : 8,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.baseUrl + widget.book['bookCover'],
                  height: 120,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                if (isHovered) ...[
                  SizedBox(height: 8),
                  Text(
                    widget.book['description'] ?? 'No description available',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService bookService = BookService();
  final Logger _logger = Logger();
  List<dynamic> books = [];
  int currentPage = 1;
  bool isLoading = true;
  bool isError = false;
  bool isListView = true;
  Map<String, bool> hoveredStates = {};
  final String baseUrl = 'http://localhost:8000/';

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
        isError = false;
        // Initialize hover states
        for (var book in books) {
          hoveredStates[book['_id']] = false;
        }
      });
    } catch (e) {
      _logger.e('Error fetching books: $e');
      setState(() {
        isLoading = false;
        isError = true;
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

  Widget buildBookSpineView(Map<String, dynamic> book) {
    final bool isHovered = hoveredStates[book['_id']] ?? false;
    final spineColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    final double progress = 0.3; // Replace with actual reading progress

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredStates[book['_id']] = true),
      onExit: (_) => setState(() => hoveredStates[book['_id']] = false),
      child: Container(
        height: 160,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // Book Spine
            Container(
              width: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [spineColor.withOpacity(0.7), spineColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: isHovered ? spineColor.withOpacity(0.4) : Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: isHovered ? 8 : 4,
                  ),
                ],
              ),
              child: RotatedBox(
                quarterTurns: 3,
                child: Center(
                  child: Text(
                    book['bookTitle'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Book Content
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: isHovered ? Colors.black26 : Colors.black12,
                      offset: Offset(2, 2),
                      blurRadius: isHovered ? 8 : 4,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(bookId: book['_id']),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book['bookTitle'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textDarkColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  book['author'] ?? 'Unknown Author',
                                  style: TextStyle(
                                    color: textDarkColor.withOpacity(0.7),
                                  ),
                                ),
                                SizedBox(height: 16),
                                // Reading Progress Section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reading Progress',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textDarkColor.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 4,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                        Container(
                                          height: 4,
                                          width: MediaQuery.of(context).size.width * 0.3 * progress,
                                          decoration: BoxDecoration(
                                            gradient: accentGradient,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${(progress * 100).toInt()}% completed',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: textDarkColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Book Cover Preview
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: isHovered ? 120 : 80,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                              image: DecorationImage(
                                image: NetworkImage(baseUrl + book['bookCover']),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: isHovered ? [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(-2, 0),
                                  blurRadius: 6,
                                ),
                              ] : [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Book List',
          style: TextStyle(
            color: textDarkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isListView ? Icons.grid_view : Icons.view_list),
            onPressed: () => setState(() => isListView = !isListView),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text('Failed to load books'))
              : isListView
                  ? ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) => buildBookSpineView(books[index]),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: books.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final bookCoverUrl = baseUrl + book['bookCover'];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: primaryGradient,
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
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: secondaryColor.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
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
                                              color: subtleBackgroundColor,
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: secondaryColor,
                                              ),
                                            );
                                          },
                                        ),
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
                                              color: textDarkColor,
                                              fontFamily: 'Sedan',
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Author: ${book['author']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: secondaryColor,
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
                                              color: textDarkColor.withOpacity(0.7),
                                              fontFamily: 'Dosis',
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                color: warmAccentColor,
                                                onPressed: () {
                                                  // Edit book functionality
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                color: coralAccentColor,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text('Delete Book'),
                                                      content: Text(
                                                          'Are you sure you want to delete this book?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(context),
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            deleteBook(book['_id']);
                                                          },
                                                          child: Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color:
                                                                    coralAccentColor),
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
                          ),
                        );
                      },
                    ),
    );
  }
}
