import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  String? photoUrl;

  @HiveField(4)
  List<String> favoriteBookIds;

  @HiveField(5)
  List<String> readBookIds;

  @HiveField(6)
  Map<String, double> bookRatings; // bookId -> rating

  @HiveField(7)
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    List<String>? favoriteBookIds,
    List<String>? readBookIds,
    Map<String, double>? bookRatings,
    DateTime? createdAt,
  })  : favoriteBookIds = favoriteBookIds ?? [],
        readBookIds = readBookIds ?? [],
        bookRatings = bookRatings ?? {},
        createdAt = createdAt ?? DateTime.now();

  // Конвертація з JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      favoriteBookIds: (json['favoriteBookIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      readBookIds: (json['readBookIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      bookRatings: (json['bookRatings'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          ) ??
          {},
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  // Конвертація в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'favoriteBookIds': favoriteBookIds,
      'readBookIds': readBookIds,
      'bookRatings': bookRatings,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Додати книгу до улюблених
  void addToFavorites(String bookId) {
    if (!favoriteBookIds.contains(bookId)) {
      favoriteBookIds.add(bookId);
    }
  }

  // Видалити книгу з улюблених
  void removeFromFavorites(String bookId) {
    favoriteBookIds.remove(bookId);
  }

  // Додати книгу до прочитаних
  void markAsRead(String bookId) {
    if (!readBookIds.contains(bookId)) {
      readBookIds.add(bookId);
    }
  }

  // Оцінити книгу
  void rateBook(String bookId, double rating) {
    bookRatings[bookId] = rating;
  }

  // Отримати рейтинг книги
  double? getBookRating(String bookId) {
    return bookRatings[bookId];
  }

  // Кількість прочитаних книг
  int get readBooksCount => readBookIds.length;

  // Перевірка чи книга в улюблених
  bool isFavorite(String bookId) => favoriteBookIds.contains(bookId);
}
