import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/book_model.dart';
import '../widgets/CategoryBookList.dart';

class HomePage extends StatefulWidget {
  final List<BookModel> books;

  const HomePage({
    Key? key,
    required this.books,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Map<String, List<BookModel>> _getBooksByCategory() {
    final Map<String, List<BookModel>> categorizedBooks = {};

    for (var book in widget.books) {
      final String category = book.categories ?? 'Uncategorized';

      if (!categorizedBooks.containsKey(category)) {
        categorizedBooks[category] = [];
      }
      categorizedBooks[category]!.add(book);
    }

    // Filter books if there's a search query
    if (_searchQuery.isNotEmpty) {
      categorizedBooks.forEach((category, books) {
        categorizedBooks[category] = books
            .where((book) =>
                book.title
                        ?.toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ==
                    true ||
                book.author
                        ?.toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ==
                    true)
            .toList();
      });
      // Remove empty categories
      categorizedBooks.removeWhere((key, value) => value.isEmpty);
    }

    return categorizedBooks;
  }

  List<BookModel> _getFeaturedBooks() {
    return widget.books.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categorizedBooks = _getBooksByCategory();
    final featuredBooks = _getFeaturedBooks();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar and App Bar
            Container(
              color: const Color(0xFF1E88E5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    toolbarHeight: 80,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'BOOKBUDDY',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    centerTitle: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search books...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[400],
                        ),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: categorizedBooks.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Featured Books Section
                          if (featuredBooks.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Text(
                                'Featured Books',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E88E5),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 220,
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                scrollDirection: Axis.horizontal,
                                itemCount: featuredBooks.length,
                                itemBuilder: (context, index) {
                                  final book = featuredBooks[index];
                                  return Container(
                                    width: 140,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 4,
                                    ),
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                top: Radius.circular(12),
                                              ),
                                              child: Image.network(
                                                book.thumbnailUrl ??
                                                    CategoryBookList
                                                        .fallbackCovers[0],
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.book,
                                                            size: 40,
                                                            color: Colors
                                                                .grey[400]),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          'No Cover',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    book.title ?? 'Untitled',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    book.author ??
                                                        'Unknown Author',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
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
                                  );
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(height: 24),
                            ),
                          ],

                          // Categories Section
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text(
                              'Browse by Category',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E88E5),
                              ),
                            ),
                          ),
                          ...categorizedBooks.entries.map((entry) {
                            return CategoryBookList(
                              category: entry.key,
                              books: entry.value,
                            );
                          }).toList(),
                          SizedBox(
                              height: MediaQuery.of(context).padding.bottom +
                                  80), // Dynamic bottom padding
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
