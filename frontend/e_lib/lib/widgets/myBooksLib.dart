import 'package:flutter/material.dart';

class MyBooksLib extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const MyBooksLib(
      {Key? key, required this.screenHeight, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: const BoxDecoration(
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
          const Padding(
            padding: EdgeInsets.all(8.0),
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
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: const Color.fromARGB(255, 219, 254, 250),
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
                                                    255, 0, 21, 44)),
                                            borderRadius:
                                                BorderRadius.circular(40))),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return null;
                                        }
                                        return const Color.fromARGB(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
