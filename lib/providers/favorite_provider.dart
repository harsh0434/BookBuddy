import 'package:flutter/foundation.dart';
<<<<<<< HEAD
import 'package:shared_preferences.dart';
=======
import 'package:shared_preferences/shared_preferences.dart'; // Fixed import statement
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
import '../model/book_model.dart';

class FavoriteProvider with ChangeNotifier {
  Set<BookModel> _favoriteBooks = {};
  static const String _favoritesKey = 'favorite_books';

  Set<BookModel> get favoriteBooks => _favoriteBooks;

  FavoriteProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedBooks = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteBooks = savedBooks
        .map((bookJson) => BookModel.fromMap(Map<String, dynamic>.from({
              'title': bookJson,
              // Add default values for required fields
              'author': 'Unknown',
              'thumbnailUrl': '',
            })))
        .toSet();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey,
        _favoriteBooks.map((book) => book.title.toString()).toList());
  }

  bool isExist(BookModel book) {
    return _favoriteBooks.any((element) => element.title == book.title);
  }

  Future<void> toggleFavorite(BookModel book) async {
    if (isExist(book)) {
      _favoriteBooks.removeWhere((element) => element.title == book.title);
    } else {
      _favoriteBooks.add(book);
    }
    await _saveFavorites();
    notifyListeners();
  }
}
