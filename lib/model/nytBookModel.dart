class NytBookModel {
  final String title;
  final String? imageUrl;

  NytBookModel({
    required this.title,
    this.imageUrl,
  });

  factory NytBookModel.fromMap(Map<dynamic, dynamic> json) {
    return NytBookModel(
      title: json['title'],
      imageUrl: json['imageLinks']?['thumbnail'] ??
          json['volumeInfo']?['imageLinks']?['thumbnail'],
    );
  }
}
