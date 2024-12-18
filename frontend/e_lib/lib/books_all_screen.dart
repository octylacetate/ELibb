import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/elib_home.dart';
import 'package:e_lib/login.dart';
import 'package:e_lib/my_flutter_app_icons.dart';
import 'package:e_lib/profile.dart';
import 'package:e_lib/widgets/fav_books.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Booksall extends StatefulWidget {
  final bool isLoggedIn;
  final Future<void> Function() logout;
  const Booksall({required this.isLoggedIn, required this.logout, Key? key})
      : super(key: key);

  @override
  State<Booksall> createState() => _BooksallState();
}

class _BooksallState extends State<Booksall> {
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
  int selectedIndex = 2;
  bool showMyBooks = true;
  List<IconData> icons = [
    MyFlutterApp.home,
    MyFlutterApp.search,
    MyFlutterApp.library_icon,
    MyFlutterApp.supervisor_account,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 219, 254, 250),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/logo/logo-transparent2.png',
              fit: BoxFit.contain,
              height: 25,
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              width: 100,
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
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
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: const Alignment(0.0, 0.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  showMyBooks = !showMyBooks;
                });
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
                    side: BorderSide(color: Color.fromARGB(255, 219, 254, 250)),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Color.fromARGB(255, 17, 106, 136);
                    return Color.fromARGB(255, 219, 254, 250);
                  },
                ),
              ),
              child: Text(
                showMyBooks ? 'Show Favorites' : 'Show Books',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 21, 44),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView.builder(
              itemCount: genres.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ELib(
                            isLoggedIn: true,
                            logout: () async {},
                          ),
                        ),
                      );
                    },
                    child: ElevatedButton(
                      onPressed: () {},
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
                            side: BorderSide(
                                color: Color.fromARGB(255, 0, 21, 44)),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Color.fromARGB(255, 17, 106, 136);
                            return Color.fromARGB(255, 219, 254, 250);
                          },
                        ),
                      ),
                      child: Text(
                        genres[index],
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 21, 44),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Flexible(
            child: showMyBooks
                ? GridView.builder(
                    itemCount: books_imgs.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 4,
                      mainAxisExtent: 300,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                        child: InkWell(
                          onTap: () {
                            context.go('/book/${index}');
                          },
                          child: Card(
                            shadowColor: Color.fromARGB(255, 17, 106, 136),
                            surfaceTintColor:
                                Color.fromARGB(255, 219, 254, 250),
                            color: Color.fromARGB(255, 219, 254, 250),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                              child: Column(
                                children: [
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                        image: AssetImage(books_imgs[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
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
                                    " Patrick Rothfuss",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 21, 44),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Dosis',
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : FavoriteBooks(),
          ),
        ],
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
          return GestureDetector(
            onTap: () {
              _onItemTapped(index, context);
            },
            child: Icon(
              icons[index],
              size: 24,
              color: isActive
                  ? Colors.amberAccent
                  : const Color.fromARGB(255, 100, 204, 199),
            ),
          );
        },
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
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
