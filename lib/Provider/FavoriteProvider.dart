import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/book_model.dart';

class FavoriteProvider with ChangeNotifier {
  List<BookModel> _favbook = [];
  List<BookModel> get favbook => _favbook;

  bool isExist(BookModel book) {
    return _favbook.any((element) => element.title == book.title);
  }

  void addList(BookModel book) {
    if (!isExist(book)) {
      _favbook.add(book);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeList(BookModel book) {
    _favbook.removeWhere((element) => element.title == book.title);
    _saveFavorites();
    notifyListeners();
  }

  void clearFavorite() {
    _favbook = [];
    _saveFavorites();
    notifyListeners();
  }

  FavoriteProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedTitles =
        prefs.getStringList('favorite_books') ?? [];
    _favbook = savedTitles
        .map((title) => BookModel.fromMap({
              'title': title,
              'author': 'Unknown',
              'thumbnailUrl': '',
            }))
        .toList();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final titles = _favbook.map((book) => book.title.toString()).toList();
    await prefs.setStringList('favorite_books', titles);
  }
}
