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
  List screens = [
    ELib(isLoggedIn: true, logout: () async {}),
    ELib(isLoggedIn: true, logout: () async {}),
    Booksall(isLoggedIn: true, logout: () async {}),
    Profile(isLoggedIn: true, logout: () async {})
  ];
  int selectedIndex = 3;
  bool showMyBooks = true;
  List<IconData> icons = [
    MyFlutterApp.home,
    MyFlutterApp.search,
    MyFlutterApp.library_icon,
    MyFlutterApp.supervisor_account,
  ];
  static final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await apiService.getCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
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
                            userData!['avatar'] != null
                        ? NetworkImage(userData!['avatar'])
                        : AssetImage('assets/logo/cat.jpeg') as ImageProvider,
                    minRadius: 20,
                    maxRadius: 40,
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Text(
                    userData != null
                        ? "@${userData!['username']}"
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ELib(
                          isLoggedIn: widget.isLoggedIn, logout: widget.logout),
                    ));
              },
              child: ListTile(
                leading: Icon(MyFlutterApp.home),
                title: Text("Home"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyBook()));
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
                                ? "${userData!['fullName']}"
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
                                ? "${userData!['email']}"
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
                                ? "${userData!['phoneNumber']}"
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
                                ? "${userData!['bio']}"
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
              top: 30,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: CircleAvatar(
                backgroundImage: userData != null && userData!['avatar'] != null
                    ? NetworkImage(userData!['avatar'])
                    : AssetImage('assets/logo/cat.jpeg') as ImageProvider,
                radius: 40,
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.52),
              child: Text(
                userData != null ? "@${userData!['username']}" : "@username",
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()));
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
                            return Color.fromARGB(
                                255, 17, 106, 136); //<-- SEE HERE
                          return Color.fromARGB(255, 219, 254,
                              250); // Defer to the widget's default.
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
          setState(() => selectedIndex = 0);
        },
        child: const Icon(Icons.home, color: Color.fromARGB(255, 17, 106, 136)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        backgroundColor: Color.fromARGB(255, 100, 204, 199),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        activeIndex: selectedIndex,
        itemCount: icons.length,
        tabBuilder: (int index, bool isActive) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => screens[index]));
              setState(() => selectedIndex = index);
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
        onTap: (index) => setState(() => selectedIndex = index),
      ),
    );
  }
}
