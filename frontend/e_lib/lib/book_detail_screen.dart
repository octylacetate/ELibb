import 'package:e_lib/book_read_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookDetail extends StatefulWidget {
  const BookDetail({super.key});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  final List<String> booksImgs = [
    'cover_imgs/mistborn-bookimg.jpeg',
    'cover_imgs/lord-of-the-rings-bookimg.jpg',
    'cover_imgs/A_Song_of_Ice_and_Fire-bookimg.jpg',
    'cover_imgs/the-mistborn-bookimg.jpeg',
    'cover_imgs/the-nature-of-wind-bookimg.jpg'
  ];
  final ScrollController _controller = ScrollController();
  final String bookLink = 'https://example.com/book';
  final Set<String> favoriteBooks = {};
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    // Load favorites from storage
    String? favorites = await storage.read(key: 'favorites');
    if (favorites != null) {
      setState(() {
        favoriteBooks.addAll(favorites.split(','));
      });
    }
  }

  Future<void> toggleFavorite(String book) async {
    setState(() {
      if (favoriteBooks.contains(book)) {
        favoriteBooks.remove(book);
      } else {
        favoriteBooks.add(book);
      }
    });
    await storage.write(key: 'favorites', value: favoriteBooks.join(','));
  }

  @override
  Widget build(BuildContext context) {
    String currentBook = booksImgs[1];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 219, 254, 250),
        centerTitle: true,
        title: Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sedan',
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              height: 650,
              color: Color.fromARGB(255, 219, 254, 250),
              child: Column(
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(currentBook),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Text(
                    "Name of the Wind",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 21, 44),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  Text(
                    "Patrick Rothfuss",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 21, 44),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Dosis',
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => toggleFavorite(currentBook),
                        icon: Icon(
                          favoriteBooks.contains(currentBook)
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(4)),
                      IconButton(
                        onPressed: () {
                          Share.share('Check out this book: $bookLink');
                          Clipboard.setData(ClipboardData(text: bookLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Link copied to clipboard'),
                            ),
                          );
                        },
                        icon: Icon(Icons.share_outlined),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  Text(
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
                    child: Scrollbar(
                      controller: _controller,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _controller,
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 21, 44),
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Dosis',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookRead()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return null;
                          }
                          return Color.fromARGB(255, 219, 254, 250);
                        },
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side:
                              BorderSide(color: Color.fromARGB(255, 0, 21, 44)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color.fromARGB(255, 17, 106, 136);
                          }
                          return Color.fromARGB(255, 219, 254, 250);
                        },
                      ),
                    ),
                    child: Text(
                      "  Read More  ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 21, 44),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
