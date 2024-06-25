import 'package:flutter/material.dart';

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
    );
  }
}
