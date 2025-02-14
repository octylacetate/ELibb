import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_lib/books_all_screen.dart';
import 'package:e_lib/editProfile.dart';
import 'package:e_lib/elib_home.dart';
import 'package:e_lib/help_icons.dart';
import 'package:e_lib/login.dart';
import 'package:e_lib/my_book.dart';
import 'package:e_lib/my_flutter_app_icons.dart';
import 'package:e_lib/service/apiclassusers.dart';
import 'package:e_lib/widgets/myBooksLib.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:e_lib/service/apiservicebooks.dart';
import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/service/apiservicebooks.dart';

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

class Profile extends StatefulWidget {
  final bool isLoggedIn;
  final Future<void> Function() logout;

  const Profile({Key? key, required this.isLoggedIn, required this.logout})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? userData;
  bool showMyBooks = true;
  static final Logger _logger = Logger();
  int selectedIndex = 3;
  List<IconData> icons = [
    MyFlutterApp.home,
    MyFlutterApp.search,
    MyFlutterApp.library_icon,
    MyFlutterApp.supervisor_account,
  ];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await apiService.getCurrentUser();
      _logger.e("User Datadfsfsf: $response");
      setState(() {
        userData = response;
      });
      _logger.e("User Datadfsfsf: $userData");
    } catch (error) {
      // Handle error, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load user data: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    const String baseUrl =
        "http://localhost:8000/"; // Replace with your backend URL root

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
              onPressed: () async {
                if (widget.isLoggedIn) {
                  await widget.logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                } else {
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
                    side: const BorderSide(color: Color.fromARGB(255, 0, 21, 44)),
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
                context.go('/');
              },
              child: ListTile(
                leading: Icon(MyFlutterApp.home),
                title: Text("Home"),
              ),
            ),
            InkWell(
              onTap: () {
                context.go('/my-books');
              },
              child: ListTile(
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
                context.go('/upload-book');
              },
              child: ListTile(
                leading: Icon(Icons.upload_file),
                title: Text("Upload Book"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(MyFlutterApp.supervisor_account),
                title: Text("Account"),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              width: 500,
              height: 300,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 219, 254, 250),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0.0),
                  bottomRight: Radius.circular(40.0),
                  topLeft: Radius.circular(0.0),
                  bottomLeft: Radius.circular(40.0),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 50,
              bottom: 0,
              child: showMyBooks
                  ? MyBooksLib(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    )
                  : Container(
                      width: 400,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(40.0),
                          bottomLeft: Radius.circular(0.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Full Name",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 21, 44),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sedan'),
                          ),
                          Text(
                            userData != null
                                ? "${userData!['user']['fullName']}"
                                : "fullName",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 21, 44),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Email",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 21, 44),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sedan'),
                          ),
                          Text(
                            userData != null
                                ? "${userData!['user']['email']}"
                                : "email@gmail.com",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 21, 44),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Phone No.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 21, 44),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sedan'),
                          ),
                          Text(
                            userData != null
                                ? "${userData!['user']['phoneNumber']}"
                                : "add phone number",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 21, 44),
                            ),
                          ),
                          Text(
                            "Bio",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 21, 44),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sedan'),
                          ),
                          Text(
                            userData != null
                                ? "${userData!['user']['bio']}"
                                : "add bio",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 21, 44),
                            ),
                          ),
                        ],
                      )),
            ),
            Align(
                alignment: const Alignment(1.0, -0.8),
                child: Container(
                  width: 200,
                  height: 200,
                  child: Lottie.asset("assets/images/lotie1.json"),
                )),
            Align(
                alignment: const Alignment(0, -1.17),
                child: Container(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(
                    "assets/images/lotie4.json",
                    reverse: true,
                  ),
                )),
            Positioned(
              top: 20,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: CircleAvatar(
                backgroundImage: userData != null &&
                        userData!['user']['avatar'] != null
                    ? NetworkImage("${baseUrl}${userData!['user']['avatar']}")
                    : AssetImage('assets/logo/cat.jpeg') as ImageProvider,
                radius: 40,
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.52),
              child: Text(
                userData != null
                    ? "@${userData!['user']['username']}"
                    : "@username",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 21, 44),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sedan'),
              ),
            ),
            Align(
                alignment: const Alignment(0, -0.40),
                child: ElevatedButton(
                    onPressed: () {
                      context.push('/edit-profile');
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
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          side:
                              BorderSide(color: Color.fromARGB(255, 0, 21, 44)),
                          borderRadius: BorderRadius.circular(40))),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Color.fromARGB(
                                255, 17, 106, 136); //<-- SEE HERE
                          return Color.fromARGB(255, 219, 254,
                              250); // Defer to the widget's default.
                        },
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 21, 44),
                      ),
                    ))),
            Align(
                alignment: const Alignment(-0.95, -0.40),
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
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 219, 254, 250)),
                          borderRadius: BorderRadius.circular(40))),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Color.fromARGB(255, 17, 106, 136);
                          return Color.fromARGB(255, 219, 254, 250);
                        },
                      ),
                    ),
                    child: Text(
                      showMyBooks ? 'Show Other' : 'Show MyBooks.lib',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 21, 44),
                      ),
                    ))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/');
        },
        child: const Icon(Icons.home, color: Color.fromARGB(255, 17, 106, 136)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        backgroundColor: Color.fromARGB(255, 100, 204, 199),
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

  void _handleLogout(BuildContext context) async {
    final currentLocation = GoRouterState.of(context).uri.path;
    await widget.logout();
    if (context.mounted) {
      context.go('/login?from=$currentLocation');
    }
  }
}

class RecentlyViewedBooks extends StatefulWidget {
  @override
  _RecentlyViewedBooksState createState() => _RecentlyViewedBooksState();
}

class _RecentlyViewedBooksState extends State<RecentlyViewedBooks> {
  final BookService _bookService = BookService();
  bool _isLoading = true;
  bool _isError = false;
  List<dynamic> _recentBooks = [];
  Map<String, bool> _hoveredStates = {};

  @override
  void initState() {
    super.initState();
    _fetchRecentlyViewedBooks();
  }

  Future<void> _fetchRecentlyViewedBooks() async {
    try {
      final response = await _bookService.getRecentlyViewedBooks();
      setState(() {
        _recentBooks = response['data']['recentBooks'];
        _isLoading = false;
        for (var book in _recentBooks) {
          _hoveredStates[book['book']['_id']] = false;
        }
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
      print('Error fetching recently viewed books: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_isError) {
      return Center(child: Text('Failed to load recently viewed books'));
    }
    if (_recentBooks.isEmpty) {
      return Center(child: Text('No recently viewed books'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Recently Viewed Books',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 21, 44),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _recentBooks.length,
            itemBuilder: (context, index) {
              final recentBook = _recentBooks[index];
              final book = recentBook['book'];
              final spineColor = Color((index * 12345) % 0xFFFFFF).withOpacity(1.0);
              final progress = recentBook['progress'] ?? 0.0;
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
                                          image: NetworkImage('http://localhost:3000/${book['bookCover']}'),
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
    );
  }
}
