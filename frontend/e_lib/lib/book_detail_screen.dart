import 'package:e_lib/book_read_screen.dart';
import 'package:flutter/material.dart';

class BookDetail extends StatefulWidget {
  const BookDetail({super.key});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  List<String> books_imgs = [
    'cover_imgs/mistborn-bookimg.jpeg',
    'cover_imgs/lord-of-the-rings-bookimg.jpg',
    'cover_imgs/A_Song_of_Ice_and_Fire-bookimg.jpg',
    'cover_imgs/the-mistborn-bookimg.jpeg',
    'cover_imgs/the-nature-of-wind-bookimg.jpg'
  ];
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 219, 254, 250),
        centerTitle: true,
        title: Text(
          'Details',
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sedan'),
        ),
      ),
      body: Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                height: 650,
                color: Color.fromARGB(255, 219, 254, 250),
                child: Flexible(
                  child: Column(
                    children: [
                      Flexible(
                        child: Container(
                          // height: 550,
                          // width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(books_imgs[1]),
                              )),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(4)),
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
                      ),
                      Padding(padding: EdgeInsets.all(4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.outlined(
                              onPressed: () {},
                              icon: Icon(Icons.favorite_border_outlined)),
                          Padding(padding: EdgeInsets.all(4)),
                          IconButton.outlined(
                              onPressed: () {},
                              icon: Icon(Icons.share_outlined)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      Text(
                        "About",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 21, 44),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan'),
                      ),
                      Flexible(
                        flex: 1,
                        child: Scrollbar(
                          controller: _controller,
                          thumbVisibility: true,
                          child: new SingleChildScrollView(
                            controller: _controller,
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 21, 44),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Dosis'),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(4)),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookRead()));
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
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color.fromARGB(255, 0, 21, 44)),
                                    borderRadius: BorderRadius.circular(12))),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
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
                            "  Read More  ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 21, 44),
                            ),
                          )),
                      Padding(padding: EdgeInsets.all(4)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
