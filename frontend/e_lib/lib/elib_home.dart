import 'package:e_lib/screens/book_list_screen.dart';
import 'package:e_lib/service/apiclassusers.dart';
import 'package:e_lib/service/apiservicebooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'login.dart';
import 'book_detail_screen.dart';
import 'books_all_screen.dart';
import 'genre.dart';
import 'help_icons.dart';
import 'my_book.dart';
import 'my_flutter_app_icons.dart';
import 'profile.dart';
import 'package:go_router/go_router.dart';

// Import colors from main.dart
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

class ELib extends StatefulWidget {
  final bool isLoggedIn;
  final Future<void> Function() logout;
  final Widget? child;

  const ELib({
    required this.isLoggedIn,
    required this.logout,
    this.child,
    Key? key
  }) : super(key: key);

  @override
  State<ELib> createState() => _ELibState();
}

class _ELibState extends State<ELib> {
  static final Logger _logger = Logger();
  bool isPressed = false;
  int selectedIndex = 0;
  List<dynamic> books = [];
  bool isLoading = true;
  bool isError = false;
  String selectedGenre = 'All genres';
  Map<String, int> _genreCounts = {};

  final String baseUrl = "http://localhost:8000/";

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
    'Children\'s-literature'
  ];

  List<String> books_imgs = [
    'cover_imgs/mistborn-bookimg.jpeg',
    'cover_imgs/lord-of-the-rings-bookimg.jpg',
    'cover_imgs/A_Song_of_Ice_and_Fire-bookimg.jpg',
    'cover_imgs/the-mistborn-bookimg.jpeg',
    'cover_imgs/the-nature-of-wind-bookimg.jpg'
  ];

  List screens = [
    ELib(isLoggedIn: true, logout: () async {}),
    ELib(isLoggedIn: true, logout: () async {}),
    Booksall(isLoggedIn: true, logout: () async {}),
    Profile(isLoggedIn: true, logout: () async {})
  ];
  final ApiService apiService = ApiService();
  final BookService bookService = BookService();
  Map<String, dynamic>? userData;

  List<IconData> icons = [
    MyFlutterApp.home,
    MyFlutterApp.search,
    MyFlutterApp.library_icon,
    MyFlutterApp.supervisor_account,
  ];

  Future<void> fetchUserData() async {
    try {
      final response = await apiService.getCurrentUser();
      _logger.e("User Data: $response");
      setState(() {
        userData = response;
      });
      _logger.e("User Data: $userData");
    } catch (error) {
      // Handle error, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load user data: $error'),
      ));
    }
  }

  Future<void> fetchBooks() async {
    try {
      final response = await bookService.getAllBooks(1, selectedGenre == 'All genres' ? null : selectedGenre);
      setState(() {
        books = response['data']['allBooks'];
        isLoading = false;
        isError = false;
      });
      // Refresh genre counts after fetching books
      await _fetchGenreCounts();
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      _logger.e('Failed to load books: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load books: $error'),
      ));
    }
  }

  Future<void> _fetchGenreCounts() async {
    try {
      final response = await bookService.getGenreCounts();
      if (response['statusCode'] == 200) {
        setState(() {
          _genreCounts = Map<String, int>.from(response['data']);
          // Calculate total for 'All genres'
          int total = 0;
          _genreCounts.forEach((key, value) {
            if (key != 'All genres') {
              total += value;
            }
          });
          _genreCounts['All genres'] = total;
        });
        _logger.d('Genre counts: $_genreCounts');
      }
    } catch (e) {
      _logger.e('Error fetching genre counts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchBooks();
    _fetchGenreCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/logo-transparent2.png',
              fit: BoxFit.contain,
              height: 35,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                await widget.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return null;
                    }
                    return const Color.fromARGB(255, 219, 254, 250);
                  },
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side:
                        const BorderSide(color: Color.fromARGB(255, 0, 21, 44)),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromARGB(255, 17, 106, 136);
                    }
                    return const Color.fromARGB(255, 219, 254, 250);
                  },
                ),
              ),
              child: Text(
                widget.isLoggedIn ? "Logout" : "Login",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 21, 44),
                ),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        width: 250,
        backgroundColor: const Color.fromARGB(255, 219, 254, 250),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10, 10, 5),
              child: Text("eLib",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'Sedan',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: userData != null &&
                            userData!['user']['avatar'] != null
                        ? NetworkImage(
                            "${baseUrl}${userData!['user']['avatar']}")
                        : AssetImage('assets/logo/cat.jpeg') as ImageProvider,
                    minRadius: 20,
                    maxRadius: 40,
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Text(
                    userData != null
                        ? "@${userData!['user']['username']}"
                        : "@username",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 21, 44),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan'),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookListScreen()));
              },
              child: const ListTile(
                leading: Icon(MyFlutterApp.home),
                title: Text("Home"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyBook()));
              },
              child: const ListTile(
                leading: Icon(MyFlutterApp.search),
                title: Text("Search"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(MyFlutterApp.library_icon),
                title: Text("Library"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Profile(isLoggedIn: true, logout: () async {})));
              },
              child: ListTile(
                leading: Icon(MyFlutterApp.supervisor_account),
                title: Text("Account"),
              ),
            ),
            InkWell(
              onTap: () {
                context.go('/upload-book');
              },
              child: ListTile(
                leading: Icon(Icons.upload_file),
                title: Text("Upload Book"),
              ),
            ),
            InkWell(
              onTap: () {
                context.go('/favorites');
              },
              child: ListTile(
                leading: Icon(Icons.favorite),
                title: Text("Favorites"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(Help.help_circled),
                title: Text("Help"),
                trailing: Container(
                  height: 30,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(width: 2, color: Colors.greenAccent),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: widget.child ?? Container(
        child: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text('Failed to load books'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 180,
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to eLib',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 21, 44),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Discover your next favorite book',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 17, 106, 136),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: ListView.builder(
                        itemCount: genres.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final genre = genres[index];
                          final isSelected = genre == selectedGenre;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedGenre = genre;
                                  isLoading = true;
                                });
                                fetchBooks();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (states.contains(MaterialState.pressed)) return null;
                                    return selectedGenre == genre
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
                                      color: selectedGenre == genre
                                          ? Colors.white
                                          : Color.fromARGB(255, 0, 21, 44),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: selectedGenre == genre
                                          ? Colors.white.withOpacity(0.2)
                                          : const Color.fromARGB(255, 17, 106, 136).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${_genreCounts[genre] ?? 0}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: selectedGenre == genre
                                            ? Colors.white
                                            : const Color.fromARGB(255, 17, 106, 136),
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
                    Flexible(
                      child: GridView.builder(
                        itemCount: books.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 320,
                        ),
                        itemBuilder: (context, index) {
                          final book = books[index];
                          final bookCoverUrl = baseUrl + book['bookCover'];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: MouseRegion(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookDetailScreen(bookId: book['_id']),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 8,
                                    shadowColor: secondaryColor.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            primaryColor,
                                            Colors.white,
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Book Cover with Shadow
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              margin: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: secondaryColor.withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 8,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.network(
                                                  bookCoverUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: subtleBackgroundColor,
                                                      child: Icon(Icons.book, color: secondaryColor),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Book Information
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    book['bookTitle'],
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: textDarkColor,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Sedan',
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    book['author'] ?? "Unknown Author",
                                                    style: TextStyle(
                                                      color: textDarkColor.withOpacity(0.7),
                                                      fontSize: 12,
                                                      fontFamily: 'Dosis',
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  // Rating Stars
                                                  Row(
                                                    children: List.generate(5, (index) {
                                                      return Icon(
                                                        Icons.star,
                                                        size: 14,
                                                        color: index < (book['rating'] ?? 4)
                                                            ? warmAccentColor
                                                            : warmAccentColor.withOpacity(0.3),
                                                      );
                                                    }),
                                                  ),
                                                  // Category Tag
                                                  Container(
                                                    margin: EdgeInsets.only(top: 4),
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: accentColor.withOpacity(0.2),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      book['genre'] ?? 'Fiction',
                                                      style: TextStyle(
                                                        color: secondaryColor,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w500,
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
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/');
        },
        child: const Icon(Icons.home, color: Color.fromARGB(255, 17, 106, 136)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        backgroundColor: const Color.fromARGB(255, 100, 204, 199),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        activeIndex: _calculateSelectedIndex(context),
        itemCount: icons.length,
        tabBuilder: (int index, bool isActive) {
          return Icon(
            icons[index],
            size: 24,
            color: isActive
                ? warmAccentColor
                : accentColor,
          );
        },
        gapLocation: GapLocation.none,
        leftCornerRadius: 8,
        rightCornerRadius: 8,
        backgroundColor: secondaryColor,
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

  Widget buildCarouselItem(String imagePath, String title, String author) {
    return Container(
      width: 400,
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sedan'),
            ),
            Text(
              author,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Dosis'),
            ),
          ],
        ),
      ),
    );
  }
}
