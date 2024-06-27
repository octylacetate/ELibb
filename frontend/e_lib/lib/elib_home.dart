import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/books_all_screen.dart';
import 'package:e_lib/genre.dart';
import 'package:e_lib/help_icons.dart';
import 'package:e_lib/my_book.dart';
import 'package:e_lib/my_flutter_app_icons.dart';
import 'package:e_lib/login.dart';
import 'package:e_lib/profile.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:scroll_to_hide/scroll_to_hide.dart';

class ELib extends StatefulWidget {
  const ELib({super.key});

  @override
  State<ELib> createState() => _ELibState();
}

class _ELibState extends State<ELib> {
  CarouselController controller = CarouselController();
  // final ScrollController _scrollController = ScrollController();
  bool isPressed = false;
  int currentIndex = 0;
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
  int selectedIndex = 0;
  List<IconData> icons = [
    MyFlutterApp.home,
    MyFlutterApp.search,
    MyFlutterApp.library_icon,
    MyFlutterApp.supervisor_account,
  ];
  List screens = [ELib(), ELib(), Booksall(), Profile()];

  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
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
                      side: BorderSide(color: Color.fromARGB(255, 0, 21, 44)),
                      borderRadius: BorderRadius.circular(40))),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color.fromARGB(255, 17, 106, 136); //<-- SEE HERE
                      return Color.fromARGB(
                          255, 219, 254, 250); // Defer to the widget's default.
                    },
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 21, 44),
                  ),
                )),
          )
        ],
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GenreScreen()));
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
      body: Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                CarouselSlider(
                  carouselController: controller,
                  items: [
                    //1st Image of Slider
                    Container(
                      width: 400,
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage('cover_imgs/mistborn_slide.png'),
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
                              "Mistborn",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sedan'),
                            ),
                            Text(
                              " Brandon Sanderson",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Dosis'),
                            ),
                            Positioned(
                              bottom: 6.0,
                              left: 100.0,
                              child: DotsIndicator(
                                dotsCount: 4,
                                position: currentIndex,
                                onTap: (position) {
                                  controller.animateToPage(position);
                                },
                                decorator: DotsDecorator(
                                    color: Color.fromARGB(255, 218, 200, 202),
                                    activeColor:
                                        Color.fromARGB(255, 179, 144, 149),
                                    size: Size.square(8.0),
                                    activeSize: Size(14, 8),
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Lord of the Rings",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sedan'),
                            ),
                            Text(
                              " J.R.R. Tolkien",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Dosis'),
                            ),
                            Positioned(
                              bottom: 6.0,
                              left: 100.0,
                              child: DotsIndicator(
                                dotsCount: 4,
                                position: currentIndex,
                                onTap: (position) {
                                  controller.animateToPage(position);
                                },
                                decorator: DotsDecorator(
                                    color: Color.fromARGB(255, 216, 176, 83),
                                    activeColor:
                                        Color.fromARGB(255, 248, 190, 55),
                                    size: Size.square(8.0),
                                    activeSize: Size(14, 8),
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage('cover_imgs/lordofrings_slide.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Name of the Wind",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sedan'),
                            ),
                            Text(
                              " Patrick Rothfuss",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Dosis'),
                            ),
                            Positioned(
                              bottom: 6.0,
                              left: 100.0,
                              child: DotsIndicator(
                                dotsCount: 4,
                                position: currentIndex,
                                onTap: (position) {
                                  controller.animateToPage(position);
                                },
                                decorator: DotsDecorator(
                                    color: Color.fromARGB(255, 17, 106, 136),
                                    activeColor:
                                        Color.fromARGB(255, 100, 204, 199),
                                    size: Size.square(8.0),
                                    activeSize: Size(14, 8),
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage('cover_imgs/nameofwind_slide.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    //2nd Image of Slider

                    //3rd Image of Slider

                    //4th Image of Slider

                    //5th Image of Slider
                  ],

                  //Slider Container properties
                  options: CarouselOptions(
                    height: 180.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ],
            ),

            //Genres
            SizedBox(
              height: 52,
              child: ListView.builder(
                itemCount: genres.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ELib()));
                                    },
                                    child: Flexible(
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith(
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
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 0, 21, 44)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40))),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed))
                                                    return Color.fromARGB(
                                                        255,
                                                        17,
                                                        106,
                                                        136); //<-- SEE HERE
                                                  return Color.fromARGB(
                                                      255,
                                                      219,
                                                      254,
                                                      250); // Defer to the widget's default.
                                                },
                                              ),
                                            ),
                                            child: Text(
                                              genres[index],
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 21, 44),
                                              ),
                                            ))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ]);
                },
              ),
            ),
            Flexible(
              child: SizedBox(
                child: GridView.builder(
                  itemCount: books_imgs.length,

                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 4,
                      mainAxisExtent: 300),

                  // Your MasonryGridView builder here
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookDetail()));
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
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  books_imgs[index]))),
                                    ),
                                  ),
                                  Text(
                                    "Name of the Wind",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 21, 44),
                                        fontSize: 16,
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
                                  )
                                ],
                              ),
                            ),
                          )),
                    );
                  },
                ),
              ),
            ),
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
