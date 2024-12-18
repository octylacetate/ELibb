import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_lib/my_flutter_app_icons.dart';

class MyBook extends StatefulWidget {
  const MyBook({super.key});

  @override
  State<MyBook> createState() => _MyBookState();
}

class _MyBookState extends State<MyBook> {
  List<String> books_imgs = [
    'cover_imgs/mistborn-bookimg.jpeg',
    'cover_imgs/lord-of-the-rings-bookimg.jpg',
    'cover_imgs/A_Song_of_Ice_and_Fire-bookimg.jpg',
    'cover_imgs/the-mistborn-bookimg.jpeg',
    'cover_imgs/the-nature-of-wind-bookimg.jpg'
  ];
  
  List<IconData> icons = [
    MyFlutterApp.home,
    MyFlutterApp.search,
    MyFlutterApp.library_icon,
    MyFlutterApp.supervisor_account,
  ];

  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 1.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          color: Color.fromARGB(255, 219, 254, 250),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'cover_imgs/mistborn-bookimg.jpeg'))),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Name of the Wind",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Sedan'),
                                  ),
                                  Text(
                                    " Patrick Rothfuss",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 21, 44),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Dosis'),
                                  ),
                                  Text(
                                    " Page No. 555",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 21, 44),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Dosis'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        alignment: Alignment.center,
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 17, 106, 136)),
                                                borderRadius:
                                                    BorderRadius.circular(40))),
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                          (states) {
                                            // If the button is pressed, return green, otherwise blue
                                            if (states.contains(
                                                MaterialState.pressed)) {
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
                                          "Next",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
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
