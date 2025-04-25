import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:term_project/model/book_model.dart';

class BookApi {
  static const int MAX_RESULTS = 40;
  static const List<String> CATEGORIES = [
    'fiction',
    'science',
    'technology',
    'business',
    'history',
    'biography',
    'mystery',
    'romance',
    'fantasy',
    'programming',
    'self-help',
    'art',
    'poetry',
    'cooking',
    'travel'
  ];

  static Future<List<BookModel>> getBookData() async {
    List<BookModel> allBooks = [];

    // Fetch books for each category
    for (String category in CATEGORIES) {
      try {
        final url =
            'https://www.googleapis.com/books/v1/volumes?q=subject:$category&maxResults=$MAX_RESULTS';
        final uri = Uri.parse(url);
        final response = await http.get(uri);
        final body = response.body;
        final json = jsonDecode(body);

        if (json['items'] != null) {
          final results = json['items'] as List<dynamic>;
          final books = results.map((e) {
            final book = BookModel.fromMap(e);
            // Set the category explicitly
            return BookModel(
              title: book.title,
              author: book.author,
              thumbnailUrl: book.thumbnailUrl,
              description: book.description,
              categories: category.substring(0, 1).toUpperCase() +
                  category.substring(1), // Capitalize first letter
              publishdate: book.publishdate,
              publisher: book.publisher,
              isbn: book.isbn,
              isbntype: book.isbntype,
              page: book.page,
              language: book.language,
            );
          }).toList();

          allBooks.addAll(books);
        }
      } catch (e) {
        print('Error fetching $category books: $e');
      }
    }

    // Shuffle the books to mix categories
    allBooks.shuffle();

    return allBooks;
  }

  static Future<List<BookModel>> getDataByQuery({String q = "flutter"}) async {
    List<BookModel> books = [];
    var url = 'https://www.googleapis.com/books/v1/volumes?q=$q&maxResults=40';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    if (json['items'] != null) {
      final results = json['items'] as List<dynamic>;
      books = results.map((e) => BookModel.fromMap(e)).toList();
    }

    return books;
  }

  static Future<List<BookModel>> getDataBygenre({String q = "computer"}) async {
    List<BookModel> books = [];
    var url =
        'https://www.googleapis.com/books/v1/volumes?q=subject:$q&maxResults=40';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    if (json['items'] != null) {
      final results = json['items'] as List<dynamic>;
      books = results.map((e) => BookModel.fromMap(e)).toList();
    }

    return books;
  }

  static Future<List<BookModel>> recommendedBooks(
      {required List<String> list}) async {
    var random = Random();
    List<BookModel> books = [];

    for (int i = 0; i < list.length && i < 4; i++) {
      try {
        List<BookModel> categoryBooks = await getDataByQuery(q: list[i]);
        if (categoryBooks.isNotEmpty) {
          int randomIndex = random.nextInt(categoryBooks.length);
          books.add(categoryBooks[randomIndex]);
        }
      } catch (e) {
        print('Error getting recommended book for ${list[i]}: $e');
      }
    }

    return books;
  }
}
