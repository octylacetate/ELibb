import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/books_all_screen.dart';
import 'package:e_lib/elib_home.dart';
import 'package:e_lib/genre.dart';
import 'package:e_lib/help_icons.dart';
import 'package:e_lib/my_book.dart';
import 'package:e_lib/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
  List screens = [ELib(), ELib(), Booksall(), Profile()];
  int selectedIndex = 0;
  List<IconData> icons = [
    MyFlutterApp.home,
    MyFlutterApp.search,
    MyFlutterApp.library_icon,
    MyFlutterApp.supervisor_account,
  ];
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 219, 254, 250),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/logo-transparent2.png',
              fit: BoxFit.contain,
              height: 25,
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              width: 60,
            )
          ],
        ),
      ),
      drawer: Drawer(
        width: 250,
        backgroundColor: Color.fromARGB(255, 219, 254, 250),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 5),
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
                    backgroundImage: AssetImage(
                      'assets/logo/cat.jpeg',
                    ),
                    minRadius: 20,
                    maxRadius: 40,
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Text(
                    "@username",
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
                    context, MaterialPageRoute(builder: (context) => ELib()));
              },
              child: ListTile(
                leading: Icon(MyFlutterApp.home),
                title: Text("Home"),
                // trailing: Text("+47"),
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
                // trailing: Text("+47"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(MyFlutterApp.library_icon),
                title: Text("Library"),
                // trailing: Text("+47"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(MyFlutterApp.supervisor_account),
                title: Text("Account"),
                // trailing: Text("+47"),
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
              decoration: BoxDecoration(
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
              child: Container(
                width: 400,
                decoration: BoxDecoration(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "MyBooks.lib",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 21, 44),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan'),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.47,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: 10,

                        // itemExtent: 200,
                        itemBuilder: (context, index) {
                          return Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  color: Color.fromARGB(255, 219, 254, 250),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'cover_imgs/mistborn-bookimg.jpeg'))),
                                      ),
                                      Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Name of the Wind",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Sedan'),
                                          ),
                                          Text(
                                            " Patrick Rothfuss",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 21, 44),
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Dosis'),
                                          ),
                                          Text(
                                            " Page No. 555",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 21, 44),
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Dosis'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                alignment: Alignment.center,
                                                shape: MaterialStateProperty
                                                    .all(RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    21,
                                                                    44)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40))),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith(
                                                  (states) {
                                                    // If the button is pressed, return green, otherwise blue
                                                    if (states.contains(
                                                        MaterialState
                                                            .pressed)) {
                                                      return null;
                                                    }
                                                    return Color.fromARGB(
                                                        255, 219, 254, 250);
                                                  },
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: SizedBox(
                                                height: 20,
                                                width: screenWidth * 0.4,
                                                child: Text(
                                                  "Read",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Sedan'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/logo/cat.jpeg',
                ),
                radius: 40,
              ),
            ),
            Align(
              alignment:
                  Alignment(0, -0.6), // Adjust alignment to position vertically
              child: Text(
                "@useRname",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 21, 44),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sedan'),
              ),
            ),
            Align(
                alignment: Alignment(
                    0, -0.48), // Adjust alignment to position vertically
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          // If the button is pressed, return green, otherwise blue
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
        //params
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
              selectedIndex = index;
            },
            child: Icon(
              icons[index],
              size: 24,
              color: isActive
                  ? Colors.amberAccent
                  : Color.fromARGB(255, 100, 204, 199),
            ),
          );
        },
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 8,
        rightCornerRadius: 8,
        backgroundColor: Color.fromARGB(255, 17, 106, 136),
        onTap: (index) => setState(() => selectedIndex = index),
        //other params
      ),
    );
  }
}
