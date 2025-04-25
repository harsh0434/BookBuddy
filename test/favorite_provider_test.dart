import 'package:flutter_test/flutter_test.dart';
import 'package:term_project/Provider/FavoriteProvider.dart';

void main() {
  group('FavoriteProvider Tests', () {
    late FavoriteProvider favoriteProvider;

    setUp(() {
      favoriteProvider = FavoriteProvider();
    });

    test('Initial state should be empty', () {
      expect(favoriteProvider.favorites.length, 0);
    });

    test('Adding a favorite should increase the list length', () {
      favoriteProvider.addFavorite('book1');
      expect(favoriteProvider.favorites.length, 1);
      expect(favoriteProvider.favorites.contains('book1'), true);
    });

    test('Removing a favorite should decrease the list length', () {
      favoriteProvider.addFavorite('book1');
      favoriteProvider.removeFavorite('book1');
      expect(favoriteProvider.favorites.length, 0);
      expect(favoriteProvider.favorites.contains('book1'), false);
    });
  });
}
