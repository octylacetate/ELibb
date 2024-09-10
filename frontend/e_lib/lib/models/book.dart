class Book {
  final String id;
  final String title;
  final String author;
  final String cover;
  final String path;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.cover,
    required this.path,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['bookTitle'],
      author: json['author'] ?? 'Unknown Author',
      cover: json['bookCover'],
      path: json['bookPath'],
      description: json['description'] ?? 'No description available',
    );
  }
}
