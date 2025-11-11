import 'package:hive/hive.dart';

part 'rating.g.dart';

@HiveType(typeId: 2)
class Rating extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String bookId;

  @HiveField(3)
  double rating;

  @HiveField(4)
  String? review;

  @HiveField(5)
  DateTime createdAt;

  Rating({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.rating,
    this.review,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'rating': rating,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      bookId: map['bookId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      review: map['review'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
