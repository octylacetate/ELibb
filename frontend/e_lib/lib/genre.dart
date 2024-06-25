import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// simport 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:http/http.dart' as http;

// class Genre extends StatelessWidget {
//   const Genre({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Flexible(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Select genres",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Sedan'),
//               ),
//               Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => GenreScreen()));
//                     },
//                     child: Text(
//                       "Next",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 8,
//                           fontWeight: FontWeight.normal,
//                           fontFamily: 'Dosis'),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => GenreScreen()));
//                     },
//                     child: Text(
//                       "Next",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 8,
//                           fontWeight: FontWeight.normal,
//                           fontFamily: 'Dosis'),
//                     ),
//                   )
//                 ],
//               )
//             ]),
//       ),
//     );
//   }
// }

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // static var lightblue = Color.fromARGB(255, 219, 254, 250);
  static var blue = Color.fromARGB(255, 17, 106, 136);
  List<bool> _selectedCards = List<bool>.generate(20, (index) => false);
  // List to keep track of the number of clicks on each card
  int clicks = 0;
  // List of card texts
  List<String> _cardTexts =
      List<String>.generate(20, (index) => 'genre $index');
  // Method to send the selected card text to the backend
  Future<void> _sendCardTextToBackend(String text) async {
    final url =
        'https://your-backend-endpoint.com/api/card'; // Replace with your backend endpoint
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'text': text},
      );

      if (response.statusCode == 200) {
        // Successfully sent the text
        print('Successfully sent the text: $text');
      } else {
        // Handle the error
        print('Failed to send the text. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle the exception
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Expanded(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  "Select genres",
                  style: TextStyle(
                      color: blue,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sedan'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 21, 44),
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Dosis'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 4),
                child: Text(
                  " This will make recommendations more accurate and entertaining.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 21, 44),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Dosis'),
                ),
              ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: SizedBox(
                  //height: 600,
                  child: GridView.builder(
                itemCount: 20,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisExtent: 120),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle the selected state of the card
                        _selectedCards[index] = !_selectedCards[index];

                        // Send the card text to the backend
                        _sendCardTextToBackend(_cardTexts[index]);

                        // Increase the click count of the card

                        clicks++;

                        if (clicks > 5) {
                          final snackBar = SnackBar(
                            content: const Text('Hold up, thats the limit'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Some code to undo the change.
                                setState(() {
                                  _selectedCards =
                                      List<bool>.generate(20, (index) => false);
                                  clicks = 0;
                                });
                              },
                            ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    child: Card(
                      color: _selectedCards[index]
                          ? blue // Selected color
                          : Color.fromARGB(255, 219, 254, 250),
                      shadowColor: Color.fromARGB(255, 17, 106, 136),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.abc_outlined,
                              color: _selectedCards[index]
                                  ? Color.fromARGB(
                                      255, 219, 254, 250) // Selected color
                                  : blue,
                              size: 30,
                            ),
                            Text(
                              _cardTexts[index],
                              style: TextStyle(
                                  color: _selectedCards[index]
                                      ? Color.fromARGB(
                                          255, 219, 254, 250) // Selected color
                                      : blue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Dosis'),
                            ),
                          ]),
                    ),
                  );
                },
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                alignment: Alignment.center,
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromARGB(255, 17, 106, 136)),
                    borderRadius: BorderRadius.circular(40))),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    // If the button is pressed, return green, otherwise blue
                    if (states.contains(MaterialState.pressed)) {
                      return null;
                    }
                    return Color.fromARGB(255, 219, 254, 250);
                  },
                ),
              ),
              onPressed: () {},
              child: SizedBox(
                height: 20,
                width: screenWidth * 0.8,
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
        ]),
      ),
    );
  }
}
