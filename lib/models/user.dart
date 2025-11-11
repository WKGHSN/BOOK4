import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  String? photoUrl;

  @HiveField(4)
  List<String> favoriteBooks;

  @HiveField(5)
  int booksRead;

  @HiveField(6)
  List<String> favoriteGenres;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.favoriteBooks = const [],
    this.booksRead = 0,
    this.favoriteGenres = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'favoriteBooks': favoriteBooks,
      'booksRead': booksRead,
      'favoriteGenres': favoriteGenres,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      favoriteBooks: List<String>.from(map['favoriteBooks'] ?? []),
      booksRead: map['booksRead'] ?? 0,
      favoriteGenres: List<String>.from(map['favoriteGenres'] ?? []),
    );
  }
}
