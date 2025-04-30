import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/book_model.dart';
import '../pages/BookDetailPage.dart';
<<<<<<< HEAD
import 'package:http/http.dart' as http;
import 'dart:convert';
=======
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)

class CategoryBookList extends StatelessWidget {
  final String category;
  final List<BookModel> books;

  const CategoryBookList({
    Key? key,
    required this.category,
    required this.books,
  }) : super(key: key);

<<<<<<< HEAD
  // Genre-specific cover images for fallback
  static const Map<String, String> genreCovers = {
    'Fiction': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
    'Mystery': 'https://images.unsplash.com/photo-1532012197267-da84d127e765',
    'Science Fiction':
        'https://images.unsplash.com/photo-1534447677768-be436bb09401',
    'Romance': 'https://images.unsplash.com/photo-1516979187457-637abb4f9353',
    'Horror': 'https://images.unsplash.com/photo-1507842217343-583bb7270b66',
    'Fantasy': 'https://images.unsplash.com/photo-1512820790803-83ca734da794',
    'Biography': 'https://images.unsplash.com/photo-1457369804613-52c61a468e7d',
    'History': 'https://images.unsplash.com/photo-1507842217343-583bb7270b66',
  };

  // Fallback covers if no specific image is found
  static const List<String> fallbackCovers = [
    'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
    'https://images.unsplash.com/photo-1532012197267-da84d127e765',
    'https://images.unsplash.com/photo-1512820790803-83ca734da794',
    'https://images.unsplash.com/photo-1516979187457-637abb4f9353'
  ];

  Future<String> getBookCoverUrl(String title, String author) async {
    try {
      // Clean the search query
      final searchQuery = Uri.encodeComponent('$title $author');
      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/books/v1/volumes?q=$searchQuery&maxResults=1'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          final volumeInfo = data['items'][0]['volumeInfo'];
          if (volumeInfo['imageLinks'] != null &&
              volumeInfo['imageLinks']['thumbnail'] != null) {
            return volumeInfo['imageLinks']['thumbnail']
                .toString()
                .replaceAll('http://', 'https://');
          }
        }
      }

      // If no specific image found, return genre-specific image
      return genreCovers[category] ?? getFallbackCover();
    } catch (e) {
      return getFallbackCover();
    }
  }

  String getFallbackCover() {
=======
  // Genre-specific cover images
  static const Map<String, String> genreCovers = {
    'Fiction':
        'https://images.unsplash.com/photo-1544947950-fa07a98d237f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    'Mystery':
        'https://images.unsplash.com/photo-1532012197267-da84d127e765?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    'Science Fiction':
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    'Romance':
        'https://images.unsplash.com/photo-1516979187457-637abb4f9353?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    'Horror':
        'https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    'Fantasy':
        'https://images.unsplash.com/photo-1512820790803-83ca734da794?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    'Biography':
        'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    'History':
        'https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
  };

  // Fallback covers for when genre-specific images aren't available
  static const List<String> fallbackCovers = [
    'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
    'https://marketplace.canva.com/EAFHfL_zI-k/1/0/1003w/canva-brown-vintage-old-book-novel-wattpad-book-cover-LYmowP9D4LM.jpg',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/contemporary-fiction-night-time-book-cover-design-template-1be47835c3058eb42211574e0c4ed8bf_screen.jpg',
    'https://pub-static.fotor.com/assets/projects/pages/d5bdd0513a0740a8a38752dbc32586d0/blue-minimal-novels-cover-7e7c739f7e3545c6b54124d6847e74f2.jpg'
  ];

  String getCoverImage(String? category) {
    if (category != null && genreCovers.containsKey(category)) {
      return genreCovers[category]!;
    }
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
    final random = DateTime.now().millisecondsSinceEpoch;
    return fallbackCovers[random % fallbackCovers.length];
  }

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
<<<<<<< HEAD
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
=======
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: GoogleFonts.poppins(
<<<<<<< HEAD
                  fontSize: 18,
=======
                  fontSize: 20,
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E88E5),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement view all functionality
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
<<<<<<< HEAD
                    fontSize: 12,
=======
                    fontSize: 14,
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
<<<<<<< HEAD
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
=======
          height: 180, // Further reduced height
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
<<<<<<< HEAD
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 130,
                  maxWidth: 130,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
=======
              return Container(
                width: 120, // Further reduced width
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(book: book),
                        ),
                      );
                    },
<<<<<<< HEAD
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 7,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: AspectRatio(
                              aspectRatio: 0.8,
                              child: FutureBuilder<String>(
                                future: getBookCoverUrl(
                                    book.title ?? '', book.author ?? ''),
                                builder: (context, snapshot) {
                                  final imageUrl = snapshot.data ??
                                      (book.thumbnailUrl ?? getFallbackCover());
                                  return Hero(
                                    tag: 'book-${book.isbn}',
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.grey[200],
                                        child: Icon(Icons.book,
                                            size: 24, color: Colors.grey[400]),
                                      ),
                                    ),
                                  );
                                },
=======
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: AspectRatio(
                              aspectRatio: 0.65, // Adjusted for better fit
                              child: Hero(
                                tag: 'book-${book.isbn}',
                                child: CachedNetworkImage(
                                  imageUrl: book.thumbnailUrl ??
                                      getCoverImage(book.categories),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.network(
                                    getCoverImage(book.categories),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.grey[200],
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.book,
                                              size: 30,
                                              color: Colors.grey[400]),
                                          const SizedBox(height: 2),
                                          Text(
                                            'No Cover',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
                              ),
                            ),
                          ),
                        ),
<<<<<<< HEAD
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  book.title ?? 'Untitled',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  book.author ?? 'Unknown Author',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
=======
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                book.title ?? 'Untitled',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 10, // Further reduced font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                book.author ?? 'Unknown Author',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 8, // Further reduced font size
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
<<<<<<< HEAD
        const SizedBox(height: 4),
=======
        const SizedBox(height: 8),
>>>>>>> 6d98a3f (Sync favorites with Firebase, fix dark mode, and improve sign up/login flow)
      ],
    );
  }
}
