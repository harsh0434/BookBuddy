import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/book_model.dart';

class FavoriteProvider with ChangeNotifier {
  List<BookModel> _favbook = [];
  List<BookModel> get favbook => _favbook;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;
  DatabaseReference get _dbRef =>
      FirebaseDatabase.instance.ref('favorites/$_userId');

  bool isExist(BookModel book) {
    return _favbook.any((element) => element.title == book.title);
  }

  void addList(BookModel book) {
    if (!isExist(book)) {
      _favbook.add(book);
      _saveFavorites();
      _saveFavoritesToCloud();
      notifyListeners();
    }
  }

  void removeList(BookModel book) {
    _favbook.removeWhere((element) => element.title == book.title);
    _saveFavorites();
    _saveFavoritesToCloud();
    notifyListeners();
  }

  void clearFavorite() {
    _favbook = [];
    _saveFavorites();
    _saveFavoritesToCloud();
    notifyListeners();
  }

  FavoriteProvider() {
    _loadFavorites();
    _loadFavoritesFromCloud();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedTitles =
        prefs.getStringList('favorite_books') ?? [];
    _favbook = savedTitles
        .map((title) => BookModel.fromMap({
              'volumeInfo': {
                'title': title,
                'authors': ['Unknown'],
                'imageLinks': null,
                'description': '',
                'categories': ['No Data...'],
                'publishedDate': '',
                'publisher': '',
                'industryIdentifiers': [
                  {"identifier": '', "type": ''}
                ],
                'pageCount': 0,
                'language': '',
              }
            }))
        .toList();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final titles = _favbook.map((book) => book.title.toString()).toList();
    await prefs.setStringList('favorite_books', titles);
  }

  Future<void> _saveFavoritesToCloud() async {
    if (_userId == null) return;
    final favList = _favbook
        .map((book) => {
              'title': book.title,
              'author': book.author,
              'thumbnailUrl': book.thumbnailUrl,
              'description': book.description,
              'categories': book.categories,
              'publishdate': book.publishdate,
              'publisher': book.publisher,
              'isbn': book.isbn,
              'isbntype': book.isbntype,
              'page': book.page,
              'language': book.language,
            })
        .toList();
    await _dbRef.set(favList);
  }

  Future<void> _loadFavoritesFromCloud() async {
    if (_userId == null) return;
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final List favList = snapshot.value as List;
      _favbook = favList
          .map((data) => BookModel.fromRTDB(Map<String, dynamic>.from(data)))
          .toList();
      notifyListeners();
      _saveFavorites(); // keep local in sync
    }
  }

  // Call this when user logs in
  Future<void> syncFavoritesFromCloud() async {
    await _loadFavoritesFromCloud();
  }
}
