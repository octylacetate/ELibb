import 'package:e_lib/book_detail_screen.dart';
import 'package:e_lib/elib_home.dart';
import 'package:flutter/material.dart';

class Booksall extends StatefulWidget {
  const Booksall({super.key});

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
  @override
  Widget build(BuildContext context) {
    return //Genres
        Scaffold(
      appBar: AppBar(),
      body: Flexible(
        child: Column(
          children: [
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
    );
  }
}
