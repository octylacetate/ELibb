import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'login.dart';
import 'book_detail_screen.dart';
import 'books_all_screen.dart';
import 'genre.dart';
import 'help_icons.dart';
import 'my_book.dart';
import 'my_flutter_app_icons.dart';
import 'profile.dart';

class ELib extends StatefulWidget {
  final bool isLoggedIn;
  final Future<void> Function() logout;

  const ELib({required this.isLoggedIn, required this.logout, Key? key})
      : super(key: key);

  @override
  State<ELib> createState() => _ELibState();
}

class _ELibState extends State<ELib> {
  CarouselController controller = CarouselController();
  bool isPressed = false;
  int currentIndex = 0;
  int selectedIndex = 0;

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

  List<String> booksImgs = [
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

  List screens = [
    ELib(isLoggedIn: true, logout: () async {}),
    ELib(isLoggedIn: true, logout: () async {}),
    Booksall(),
    Profile(isLoggedIn: true, logout: () async {})
  ];

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
                children: const [
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
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GenreScreen()));
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              CarouselSlider(
                carouselController: controller,
                items: [
                  buildCarouselItem('cover_imgs/mistborn_slide.png', 'Mistborn',
                      'Brandon Sanderson'),
                  buildCarouselItem('cover_imgs/lordofrings_slide.png',
                      'Lord of the Rings', 'J.R.R. Tolkien'),
                  buildCarouselItem('cover_imgs/nameofwind_slide.png',
                      'Name of the Wind', 'Patrick Rothfuss'),
                ],
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
              Positioned(
                bottom: 6.0,
                left: 100.0,
                child: DotsIndicator(
                  dotsCount: 3,
                  position: currentIndex,
                  onTap: (position) {
                    controller.animateToPage(position);
                  },
                  decorator: DotsDecorator(
                    color: const Color.fromARGB(255, 218, 200, 202),
                    activeColor: const Color.fromARGB(255, 179, 144, 149),
                    size: const Size.square(8.0),
                    activeSize: const Size(14, 8),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ELib(
                                  isLoggedIn: widget.isLoggedIn,
                                  logout: widget.logout)));
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
                          side: const BorderSide(
                              color: Color.fromARGB(255, 0, 21, 44)),
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
                      genres[index],
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 21, 44),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Flexible(
            child: GridView.builder(
              itemCount: booksImgs.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 4,
                  mainAxisExtent: 300),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookDetail()));
                    },
                    child: Card(
                      shadowColor: const Color.fromARGB(255, 17, 106, 136),
                      surfaceTintColor:
                          const Color.fromARGB(255, 219, 254, 250),
                      color: const Color.fromARGB(255, 219, 254, 250),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                        child: Column(
                          children: [
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                        image: AssetImage(booksImgs[index]))),
                              ),
                            ),
                            const Text(
                              "Name of the Wind",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 21, 44),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sedan'),
                            ),
                            const Text(
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => selectedIndex = 0);
        },
        child: const Icon(Icons.home, color: Color.fromARGB(255, 17, 106, 136)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        backgroundColor: const Color.fromARGB(255, 100, 204, 199),
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
