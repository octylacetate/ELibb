import 'dart:ffi';

class Book {
  Int id;
  String title;
  String author;
  String coverUrl;
  String description;
  List<Chapter> chapters;

  Book(
      {required this.id,
      required this.title,
      required this.author,
      required this.coverUrl,
      required this.description,
      required this.chapters});
}

class Chapter {
  int id;
  String title;
  String content;

  Chapter({required this.id, required this.title, required this.content});
}
