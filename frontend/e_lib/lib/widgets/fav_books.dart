import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoriteBooks extends StatefulWidget {
  const FavoriteBooks({Key? key}) : super(key: key);

  @override
  State<FavoriteBooks> createState() => _FavoriteBooksState();
}

class _FavoriteBooksState extends State<FavoriteBooks> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  List<String> favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    String? favorites = await storage.read(key: 'favorites');
    if (favorites != null) {
      setState(() {
        favoriteBooks = favorites.split(',');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 219, 254, 250),
      //   title: const Text(
      //     'Favorite Books',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //       fontFamily: 'Sedan',
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: GridView.builder(
        itemCount: favoriteBooks.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 4,
          mainAxisExtent: 300,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            child: Card(
              shadowColor: const Color.fromARGB(255, 17, 106, 136),
              surfaceTintColor: const Color.fromARGB(255, 219, 254, 250),
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
                            image: AssetImage(favoriteBooks[index]),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Book Title",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 21, 44),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan',
                      ),
                    ),
                    const Text(
                      "Author Name",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 21, 44),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Dosis',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
