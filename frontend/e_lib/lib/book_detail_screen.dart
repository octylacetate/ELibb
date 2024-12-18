import 'package:e_lib/route_persistence.dart';
import 'package:e_lib/service/apiservicefavorites.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:e_lib/book_read_screen.dart';
import 'package:e_lib/service/apiservicebooks.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;
  final bool isLoggedIn;
  final Function logout;

  const BookDetailScreen({
    Key? key,
    required this.bookId,
    required this.isLoggedIn,
    required this.logout,
  }) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final RoutePersistence routePersistence = RoutePersistence();

  final BookService bookService = BookService();
  final FavouriteService favouriteService = FavouriteService();
  final Logger _logger = Logger();
  bool isLoading = true;
  bool isError = false;
  bool isFavourite = false;
  Map<String, dynamic>? book;
  final String baseUrl = "http://localhost:3000/";

  Future<void> fetchBookDetails() async {
    try {
      final response = await bookService.getBookById(widget.bookId);
      setState(() {
        book = response['data']['book'];
        isLoading = false;
        isError = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      _logger.e('Failed to load book details: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load book details: $error'),
      ));
    }
  }

  Future<void> toggleFavourite() async {
    try {
      if (isFavourite) {
        await favouriteService.removeFavourite(widget.bookId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favourites')),
        );
      } else {
        await favouriteService.addFavourite(widget.bookId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favourites')),
        );
      }
      setState(() {
        isFavourite = !isFavourite;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favourite status: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
  }

  @override
  Widget build(BuildContext context) {
    routePersistence.saveLastRoute('/book-detail/${widget.bookId}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 219, 254, 250),
        centerTitle: true,
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sedan',
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? const Center(child: Text('Failed to load book details'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        height: 650,
                        color: const Color.fromARGB(255, 219, 254, 250),
                        child: Column(
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        baseUrl + book!['bookCover']),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(4)),
                            Text(
                              book!['bookTitle'],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 21, 44),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sedan',
                              ),
                            ),
                            Text(
                              book!['author'] ?? "Unknown Author",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 21, 44),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Dosis',
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(4)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: toggleFavourite,
                                  icon: Icon(
                                    isFavourite
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(4)),
                                IconButton(
                                  onPressed: () {
                                    Share.share(
                                        'Check out this book: ${baseUrl + book!['bookPath']}');
                                  },
                                  icon: const Icon(Icons.share_outlined),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            const Text(
                              "About",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 21, 44),
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sedan',
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  book!['description'] ??
                                      "No description available",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 21, 44),
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Dosis',
                                  ),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(4)),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookRead(
                                      bookUrl: baseUrl + book!['bookPath'],
                                      isLoggedIn: widget.isLoggedIn,
                                      logout: widget.logout,
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return null;
                                    }
                                    return const Color.fromARGB(
                                        255, 219, 254, 250);
                                  },
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Color.fromARGB(255, 0, 21, 44)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return const Color.fromARGB(
                                          255, 17, 106, 136);
                                    }
                                    return const Color.fromARGB(
                                        255, 219, 254, 250);
                                  },
                                ),
                              ),
                              child: const Text(
                                "  Read More  ",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 21, 44),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(4)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
