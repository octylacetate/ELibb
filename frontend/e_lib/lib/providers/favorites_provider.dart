import 'package:flutter/foundation.dart';
import 'package:e_lib/service/apiservicefavorites.dart';

class FavoritesProvider with ChangeNotifier {
  final FavouriteService _favouriteService = FavouriteService();
  List<dynamic> _favorites = [];
  bool _isLoading = true;
  bool _isError = false;

  List<dynamic> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  Future<void> loadFavorites() async {
    try {
      final response = await _favouriteService.getAllFavourites();
      _favorites = response['data']['allFavourites'];
      _isLoading = false;
      _isError = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String bookId) async {
    try {
      if (_favorites.any((fav) => fav['book']['_id'] == bookId)) {
        await _favouriteService.removeFavourite(bookId);
        _favorites.removeWhere((fav) => fav['book']['_id'] == bookId);
      } else {
        await _favouriteService.addFavourite(bookId);
        await loadFavorites(); // Reload to get updated list
      }
      notifyListeners();
    } catch (error) {
      _isError = true;
      notifyListeners();
    }
  }
} 