import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/book_model.dart';
import '../pages/BookDetailPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryBookList extends StatelessWidget {
  final String category;
  final List<BookModel> books;

  const CategoryBookList({
    Key? key,
    required this.category,
    required this.books,
  }) : super(key: key);

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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: GoogleFonts.poppins(
                  fontSize: 18,
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
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 130,
                  maxWidth: 130,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
                              ),
                            ),
                          ),
                        ),
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
        const SizedBox(height: 4),
      ],
    );
  }
}
