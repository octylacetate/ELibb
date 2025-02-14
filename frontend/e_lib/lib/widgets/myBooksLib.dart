import 'package:flutter/material.dart';
import 'package:e_lib/service/apiservicebooks.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class MyBooksLib extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const MyBooksLib({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  State<MyBooksLib> createState() => _MyBooksLibState();
}

class _MyBooksLibState extends State<MyBooksLib> {
  final BookService _bookService = BookService();
  final Logger _logger = Logger();
  List<dynamic> _recentBooks = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchRecentlyViewedBooks();
  }

  Future<void> _fetchRecentlyViewedBooks() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = '';
      });
    }

    try {
      final response = await _bookService.getRecentlyViewedBooks();
      if (mounted) {
        setState(() {
          _recentBooks = response['data']['recentBooks'] ?? [];
          _isLoading = false;
        });
      }
      _logger.d('Fetched ${_recentBooks.length} recently viewed books');
    } catch (error) {
      _logger.e('Error fetching recently viewed books: $error');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(40.0),
          bottomLeft: Radius.circular(0.0),
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Recently Viewed Books",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 21, 44),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sedan',
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Failed to load recently viewed books',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 21, 44),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _fetchRecentlyViewedBooks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 219, 254, 250),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (_recentBooks.isEmpty)
            const Center(
              child: Text('No recently viewed books'),
            )
          else
            SizedBox(
              height: widget.screenHeight * 0.47,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _recentBooks.length,
                itemBuilder: (context, index) {
                  final book = _recentBooks[index]['book'];
                  final progress = _recentBooks[index]['progress'] ?? 0.0;
                  
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Card(
                        color: const Color.fromARGB(255, 219, 254, 250),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'http://localhost:8000/${book['bookCover']}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book['bookTitle'] ?? 'Unknown Title',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Sedan',
                                      ),
                                    ),
                                    Text(
                                      book['author'] ?? 'Unknown Author',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 21, 44),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Dosis',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        Color.fromARGB(255, 17, 106, 136),
                                      ),
                                    ),
                                    Text(
                                      'Progress: ${(progress * 100).toInt()}%',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 21, 44),
                                        fontSize: 12,
                                        fontFamily: 'Dosis',
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        alignment: Alignment.center,
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            side: const BorderSide(
                                              color: Color.fromARGB(255, 0, 21, 44),
                                            ),
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty.resolveWith(
                                          (states) {
                                            if (states.contains(MaterialState.pressed)) {
                                              return null;
                                            }
                                            return const Color.fromARGB(255, 219, 254, 250);
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        final encodedUrl = Uri.encodeComponent(
                                          'http://localhost:8000/${book['bookPath']}',
                                        );
                                        context.go('/read-book?url=$encodedUrl&bookId=${book['_id']}');
                                      },
                                      child: SizedBox(
                                        height: 20,
                                        width: widget.screenWidth * 0.4,
                                        child: const Text(
                                          "Continue Reading",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sedan',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
