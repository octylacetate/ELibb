import 'package:flutter/material.dart';
import 'package:e_lib/service/apiservicefavorites.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_lib/my_flutter_app_icons.dart';

class FavoriteBooksScreen extends StatefulWidget {
  const FavoriteBooksScreen({Key? key}) : super(key: key);

  @override
  _FavoriteBooksScreenState createState() => _FavoriteBooksScreenState();
}

class _FavoriteBooksScreenState extends State<FavoriteBooksScreen> {
  final FavouriteService _favouriteService = FavouriteService();
  List<dynamic> _favoriteBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteBooks();
  }

  Future<void> _fetchFavoriteBooks() async {
    try {
      final response = await _favouriteService.getAllFavourites();
      if (mounted) {
        setState(() {
          _favoriteBooks = response['data']['allFavourites'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error fetching favorite books: $e');
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
        title: Text(
          'Favorite Books',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 21, 44),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favoriteBooks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorite books yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _favoriteBooks.length,
                  itemBuilder: (context, index) {
                    final favorite = _favoriteBooks[index];
                    final book = favorite['book'] ?? {};
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: MouseRegion(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          child: InkWell(
                            onTap: () => context.go('/book/${book['_id']}'),
                            child: Container(
                              height: 160,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 219, 254, 250),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 17, 106, 136).withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 100, 204, 199),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              'http://localhost:8000/${book['bookCover'] ?? ''}',
                                              width: 100,
                                              height: 130,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: 100,
                                                  height: 130,
                                                  color: Colors.grey[300],
                                                  child: Icon(Icons.book, color: Colors.grey[400]),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  book['bookTitle'] ?? 'Untitled',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(255, 0, 21, 44),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  book['author'] ?? 'Unknown Author',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Text(
                                                  'Reading Progress',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                LinearProgressIndicator(
                                                  value: (book['progress'] ?? 0.0).toDouble(),
                                                  backgroundColor: Colors.grey[300],
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    Color.fromARGB(255, 17, 106, 136),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '${((book['progress'] ?? 0.0) * 100).toInt()}% completed',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.favorite,
                                            color: Color.fromARGB(255, 17, 106, 136),
                                          ),
                                          onPressed: () async {
                                            try {
                                              await _favouriteService.removeFavourite(book['_id']);
                                              _fetchFavoriteBooks();
                                            } catch (e) {
                                              print('Error removing favorite: $e');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
          return Icon(
            icons[index],
            size: 24,
            color: isActive
                ? Colors.amberAccent
                : const Color.fromARGB(255, 100, 204, 199),
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