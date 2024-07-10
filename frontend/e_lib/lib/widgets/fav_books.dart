import 'package:e_lib/service/apiservicefavorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoriteBooks extends StatefulWidget {
  const FavoriteBooks({Key? key}) : super(key: key);

  @override
  State<FavoriteBooks> createState() => _FavoriteBooksState();
}

class _FavoriteBooksState extends State<FavoriteBooks> {
  final FavouriteService favouriteService = FavouriteService();
  List<dynamic> favoriteBooks = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final response = await favouriteService.getAllFavourites();
      setState(() {
        favoriteBooks = response['data']['allFavourites'];
        isLoading = false;
        isError = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load favourites: $error')),
      );
    }
  }

  Future<void> removeFavourite(String bookId) async {
    try {
      await favouriteService.removeFavourite(bookId);
      setState(() {
        favoriteBooks.removeWhere((book) => book['book']['_id'] == bookId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favourites')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove favourite: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 219, 254, 250),
        title: const Text(
          'Favorite Books',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sedan',
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? const Center(child: Text('Failed to load favourites'))
              : GridView.builder(
                  itemCount: favoriteBooks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 4,
                    mainAxisExtent: 300,
                  ),
                  itemBuilder: (context, index) {
                    final book = favoriteBooks[index]['book'];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
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
                                      image: NetworkImage(
                                          'http://localhost:3000/' +
                                              book['bookCover']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(4)),
                              Text(
                                book['bookTitle'],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 21, 44),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sedan',
                                ),
                              ),
                              Text(
                                book['author'] ?? "Unknown Author",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 21, 44),
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Dosis',
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  removeFavourite(book['_id']);
                                },
                                icon: const Icon(Icons.delete),
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
