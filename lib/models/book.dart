import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String genre;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String? coverUrl;

  @HiveField(6)
  final String? filePath; // PDF або TXT файл

  @HiveField(7)
  double averageRating;

  @HiveField(8)
  int ratingCount;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    this.coverUrl,
    this.filePath,
    this.averageRating = 0.0,
    this.ratingCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'description': description,
      'coverUrl': coverUrl,
      'filePath': filePath,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      genre: map['genre'] ?? '',
      description: map['description'] ?? '',
      coverUrl: map['coverUrl'],
      filePath: map['filePath'],
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
      ratingCount: map['ratingCount'] ?? 0,
    );
  }
}
