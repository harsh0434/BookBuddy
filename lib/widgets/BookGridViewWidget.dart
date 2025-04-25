import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Provider/TodoProvider.dart';
import '../model/book_model.dart';
import '../pages/BookDetailPage.dart';

class BookGridViewWidget extends StatelessWidget {
  const BookGridViewWidget(
      {Key? key,
      required this.provider,
      required this.bookListFuture,
      this.controller})
      : super(key: key);
  final ScrollController? controller;
  final TodoProvider? provider;
  final Future<List<BookModel>> bookListFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookModel>>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BookModel> books = snapshot.data!;
          return GridView.builder(
              controller: controller,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1 / 1.2,
                  mainAxisSpacing: 15),
              itemCount: books.length,
              itemBuilder: (BuildContext ctx, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider!.BookSelector(books[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookDetailPage(book: provider!.book),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 135,
                            height: 107,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5),
                                color:
                                    const Color(0xFF3F51B5).withOpacity(0.8)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: books[index].thumbnailUrl!,
                                  width: 75,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 75,
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    width: 75,
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.book),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 130,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        books[index].title!,
                        style: GoogleFonts.ubuntu(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 130,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        books[index].author!,
                        style: GoogleFonts.ubuntu(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              });
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: bookListFuture,
    );
  }
}
