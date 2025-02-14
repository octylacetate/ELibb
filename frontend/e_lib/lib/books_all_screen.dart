import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/elib_home.dart';
import 'package:e_lib/login.dart';
import 'package:e_lib/my_flutter_app_icons.dart';
import 'package:e_lib/profile.dart';
import 'package:e_lib/widgets/fav_books.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_lib/service/apiservicebooks.dart';

class Booksall extends StatefulWidget {
  final bool isLoggedIn;
  final Future<void> Function() logout;
  const Booksall({required this.isLoggedIn, required this.logout, Key? key})
      : super(key: key);

  @override
  State<Booksall> createState() => _BooksallState();
}

class _BooksallState extends State<Booksall> {
  final BookService _bookService = BookService();
  List<dynamic> _books = [];
  bool _isLoading = true;
  String _selectedGenre = 'All genres';
  Map<String, int> _genreCounts = {};
  Map<String, bool> _hoveredStates = {};

  List<String> genres = [
    'All genres',
    'Fantasy',
    'Sci-fi',
    'Mystery',
    'Romance',
    'Historical-fi',
    'Thriller',
    'Non-fiction',
    'Young-adult',
    "Children's-literature"
  ];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _fetchGenreCounts();
  }

  Future<void> _fetchBooks() async {
    try {
      final response = await _bookService.getAllBooks(1, _selectedGenre == 'All genres' ? null : _selectedGenre);
      if (mounted) {
        setState(() {
          _books = response['data']['allBooks'];
          _isLoading = false;
          for (var book in _books) {
            _hoveredStates[book['_id']] = _hoveredStates[book['_id']] ?? false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error fetching books: $e');
    }
  }

  Future<void> _fetchGenreCounts() async {
    try {
      final response = await _bookService.getGenreCounts();
      if (mounted) {
        setState(() {
          _genreCounts = Map<String, int>.from(response['data']);
        });
      }
    } catch (e) {
      print('Error fetching genre counts: $e');
    }
  }

  List<IconData> icons = [
    MyFlutterApp.home,
    MyFlutterApp.search,
    MyFlutterApp.library_icon,
    MyFlutterApp.supervisor_account,
  ];

  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 219, 254, 250),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/logo/logo-transparent2.png',
              fit: BoxFit.contain,
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.isLoggedIn) {
                  widget.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => const Color.fromARGB(255, 219, 254, 250),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: const BorderSide(color: Color.fromARGB(255, 0, 21, 44)),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              child: Text(
                widget.isLoggedIn ? "Logout" : "Login",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 21, 44),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          SizedBox(
            height: 52,
            child: ListView.builder(
              itemCount: genres.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final genre = genres[index];
                final count = genre == 'All genres' 
                    ? _genreCounts.values.fold(0, (sum, count) => sum + count)
                    : _genreCounts[genre] ?? 0;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedGenre = genre;
                        _isLoading = true;
                      });
                      _fetchBooks();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.pressed)) return null;
                          return _selectedGenre == genre
                              ? const Color.fromARGB(255, 17, 106, 136)
                              : const Color.fromARGB(255, 219, 254, 250);
                        },
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(color: Color.fromARGB(255, 0, 21, 44)),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          genre,
                          style: TextStyle(
                            color: _selectedGenre == genre
                                ? Colors.white
                                : Color.fromARGB(255, 0, 21, 44),
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _selectedGenre == genre
                                ? Colors.white.withOpacity(0.2)
                                : Color.fromARGB(255, 17, 106, 136).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: _selectedGenre == genre
                                  ? Colors.white
                                  : Color.fromARGB(255, 0, 21, 44),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _books.length,
                    itemBuilder: (context, index) {
                      final book = _books[index];
                      final spineColor = Color((index * 12345) % 0xFFFFFF).withOpacity(1.0);
                      final progress = book['progress'] ?? 0.0;
                      final isHovered = _hoveredStates[book['_id']] ?? false;
                      
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 800),
                        transform: isHovered ? (Matrix4.identity()..translate(0, -10)) : Matrix4.identity(),
                        height: 160,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: MouseRegion(
                          onEnter: (_) => setState(() {
                            _hoveredStates[book['_id']] = true;
                          }),
                          onExit: (_) => setState(() {
                            _hoveredStates[book['_id']] = false;
                          }),
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
                                      color: isHovered ? spineColor.withOpacity(0.6) : spineColor.withOpacity(0.4),
                                      offset: Offset(2, 2),
                                      blurRadius: isHovered ? 12 : 8,
                                      spreadRadius: isHovered ? 2 : 0,
                                    ),
                                  ],
                                ),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Center(
                                    child: Text(
                                      book['bookTitle'] ?? '',
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isHovered ? Colors.black26 : Colors.black12,
                                        offset: Offset(2, 2),
                                        blurRadius: isHovered ? 12 : 8,
                                        spreadRadius: isHovered ? 2 : 0,
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => context.go('/book/${book['_id']}'),
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
                                                    book['bookTitle'] ?? '',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromARGB(255, 0, 21, 44),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    book['author'] ?? 'Unknown Author',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(255, 0, 21, 44).withOpacity(0.7),
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
                                                          color: Color.fromARGB(255, 0, 21, 44).withOpacity(0.7),
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
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  Color.fromARGB(255, 255, 183, 77),
                                                                  Color.fromARGB(255, 255, 127, 80),
                                                                ],
                                                                begin: Alignment.centerLeft,
                                                                end: Alignment.centerRight,
                                                              ),
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
                                                          color: Color.fromARGB(255, 0, 21, 44).withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Book Cover Preview
                                            AnimatedContainer(
                                              duration: Duration(milliseconds: 800),
                                              width: isHovered ? 120 : 80,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                                                image: DecorationImage(
                                                  image: NetworkImage('http://localhost:8000/${book['bookCover']}'),
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
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/'),
        child: const Icon(Icons.home, color: Color.fromARGB(255, 17, 106, 136)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        backgroundColor: const Color.fromARGB(255, 100, 204, 199),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        activeIndex: _calculateSelectedIndex(context),
        itemCount: icons.length,
        tabBuilder: (int index, bool isActive) {
          return GestureDetector(
            onTap: () => _onItemTapped(index, context),
            child: Icon(
              icons[index],
              size: 24,
              color: isActive
                  ? Colors.amberAccent
                  : const Color.fromARGB(255, 100, 204, 199),
            ),
          );
        },
        gapLocation: GapLocation.none,
        leftCornerRadius: 8,
        rightCornerRadius: 8,
        backgroundColor: const Color.fromARGB(255, 17, 106, 136),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String path = GoRouterState.of(context).uri.path;
    if (path.startsWith('/profile')) return 3;
    if (path.startsWith('/my-books')) return 1;
    if (path.startsWith('/all-books')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    final routes = ['/', '/my-books', '/all-books', '/profile'];
    context.go(routes[index]);
    setState(() => selectedIndex = index);
  }
}
