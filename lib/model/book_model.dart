class BookModel {
  final String? title;
  final String? author;
  final String? thumbnailUrl;
  final String? description;
  final String? categories;
  final String? publishdate;
  final String? publisher;
  final String? isbn;
  final String? isbntype;
  final int? page;
  final String? language;
  String? taskid;

  BookModel(
      {this.title,
      this.author,
      this.thumbnailUrl,
      this.description,
      this.categories,
      this.publishdate,
      this.publisher,
      this.isbn,
      this.page,
      this.language,
      this.isbntype,
      this.taskid});

  static String _ensureHttps(String? url) {
    if (url == null)
      return 'https://upload.wikimedia.org/wikipedia/commons/0/0a/No-image-available.png';
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  factory BookModel.fromMap(Map<String, dynamic> json) {
    String? thumbnailUrl = json['volumeInfo']['imageLinks'] != null
        ? json['volumeInfo']['imageLinks']['thumbnail']
        : null;

    return BookModel(
      title: json['volumeInfo']['title'] ?? 'Loading...',
      author: json['volumeInfo']['authors']?[0] ?? 'anonymous',
      description:
          json['volumeInfo']['description'] ?? 'There is no description',
      thumbnailUrl: _ensureHttps(thumbnailUrl),
      categories: json['volumeInfo']['categories']?[0] ?? 'No Data...',
      publishdate: json['volumeInfo']['publishedDate'] ?? 'No Data...',
      publisher: json['volumeInfo']['publisher'] ?? 'No Data...',
      isbn: json['volumeInfo']['industryIdentifiers']?[0]?["identifier"] ??
          'No Data...',
      isbntype: json['volumeInfo']['industryIdentifiers']?[0]?["type"] ??
          'No Data...',
      page: json['volumeInfo']['pageCount'],
      language: json['volumeInfo']['language'] ?? 'No Data...',
    );
  }

  factory BookModel.fromRTDB(Map<String, dynamic> data) {
    return BookModel(
      title: data["title"] ?? "No Data...",
      author: data["author"] ?? "No Data...",
      thumbnailUrl: _ensureHttps(data["url"]),
      description: data["description"] ?? "No Data...",
      categories: data["categories"] ?? "No Data...",
      publishdate: data["publishdate"] ?? "No Data...",
      publisher: data["publisher"] ?? "No Data...",
      isbn: data["isbn"] ?? "No Data...",
      isbntype: data["isbntype"] ?? "No Data...",
      page: data["page"] ?? 0,
      language: data["language"] ?? "No Data...",
    );
  }
}
