import 'package:e_lib/service/apiservicefavorites.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_lib/providers/favorites_provider.dart';

class FavoriteBooks extends StatefulWidget {
  const FavoriteBooks({Key? key}) : super(key: key);

  @override
  State<FavoriteBooks> createState() => _FavoriteBooksState();
}

class _FavoriteBooksState extends State<FavoriteBooks> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
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
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, _) {
          if (favoritesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (favoritesProvider.isError) {
            return const Center(child: Text('Failed to load favourites'));
          }
          
          return GridView.builder(
            itemCount: favoritesProvider.favorites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 4,
              mainAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              final book = favoritesProvider.favorites[index]['book'];
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
                                image: NetworkImage(
                                    'http://localhost:3000/' + book['bookCover']),
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
                            favoritesProvider.toggleFavorite(book['_id']);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
