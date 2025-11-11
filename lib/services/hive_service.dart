import 'package:hive_flutter/hive_flutter.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../models/rating.dart';

class HiveService {
  static const String booksBox = 'books';
  static const String usersBox = 'users';
  static const String ratingsBox = 'ratings';
  static const String currentUserKey = 'current_user_id';
  static const String themeKey = 'is_dark_theme';

  // Ініціалізація Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Реєстрація адаптерів
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BookAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RatingAdapter());
    }
    
    // Відкриття боксів
    await Hive.openBox<Book>(booksBox);
    await Hive.openBox<User>(usersBox);
    await Hive.openBox<Rating>(ratingsBox);
    await Hive.openBox(currentUserKey);
    await Hive.openBox(themeKey);
  }

  // Отримання боксів
  static Box<Book> getBooksBox() => Hive.box<Book>(booksBox);
  static Box<User> getUsersBox() => Hive.box<User>(usersBox);
  static Box<Rating> getRatingsBox() => Hive.box<Rating>(ratingsBox);
  static Box getSettingsBox() => Hive.box(currentUserKey);

  // Операції з книгами
  static Future<void> addBook(Book book) async {
    final box = getBooksBox();
    await box.put(book.id, book);
  }

  static Book? getBook(String id) {
    final box = getBooksBox();
    return box.get(id);
  }

  static List<Book> getAllBooks() {
    final box = getBooksBox();
    return box.values.toList();
  }

  static List<Book> getBooksByGenre(String genre) {
    final box = getBooksBox();
    return box.values.where((book) => book.genre == genre).toList();
  }

  static Future<void> deleteBook(String id) async {
    final box = getBooksBox();
    await box.delete(id);
  }

  // Операції з користувачами
  static Future<void> saveUser(User user) async {
    final box = getUsersBox();
    await box.put(user.id, user);
  }

  static User? getUser(String id) {
    final box = getUsersBox();
    return box.get(id);
  }

  static User? getUserByEmail(String email) {
    final box = getUsersBox();
    try {
      return box.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  static Future<void> setCurrentUserId(String userId) async {
    final box = getSettingsBox();
    await box.put(currentUserKey, userId);
  }

  static String? getCurrentUserId() {
    final box = getSettingsBox();
    return box.get(currentUserKey);
  }

  static User? getCurrentUser() {
    final userId = getCurrentUserId();
    if (userId != null) {
      return getUser(userId);
    }
    return null;
  }

  static Future<void> logout() async {
    final box = getSettingsBox();
    await box.delete(currentUserKey);
  }

  // Операції з рейтингами
  static Future<void> addRating(Rating rating) async {
    final box = getRatingsBox();
    await box.put(rating.id, rating);
    
    // Оновлення середнього рейтингу книги
    await _updateBookRating(rating.bookId);
  }

  static List<Rating> getRatingsByBookId(String bookId) {
    final box = getRatingsBox();
    return box.values.where((rating) => rating.bookId == bookId).toList();
  }

  static Rating? getUserBookRating(String userId, String bookId) {
    final box = getRatingsBox();
    try {
      return box.values.firstWhere(
        (rating) => rating.userId == userId && rating.bookId == bookId,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> _updateBookRating(String bookId) async {
    final ratings = getRatingsByBookId(bookId);
    if (ratings.isEmpty) return;

    final totalRating = ratings.fold<double>(0, (sum, rating) => sum + rating.rating);
    final averageRating = totalRating / ratings.length;

    final book = getBook(bookId);
    if (book != null) {
      book.averageRating = averageRating;
      book.ratingCount = ratings.length;
      await addBook(book);
    }
  }

  // Улюблені книги
  static Future<void> toggleFavorite(String userId, String bookId) async {
    final user = getUser(userId);
    if (user != null) {
      final favorites = List<String>.from(user.favoriteBooks);
      if (favorites.contains(bookId)) {
        favorites.remove(bookId);
      } else {
        favorites.add(bookId);
      }
      user.favoriteBooks = favorites;
      await saveUser(user);
    }
  }

  static bool isFavorite(String userId, String bookId) {
    final user = getUser(userId);
    if (user != null) {
      return user.favoriteBooks.contains(bookId);
    }
    return false;
  }

  static List<Book> getFavoriteBooks(String userId) {
    final user = getUser(userId);
    if (user != null) {
      return user.favoriteBooks
          .map((bookId) => getBook(bookId))
          .where((book) => book != null)
          .cast<Book>()
          .toList();
    }
    return [];
  }

  // Тема
  static Future<void> setTheme(bool isDark) async {
    final box = getSettingsBox();
    await box.put(themeKey, isDark);
  }

  static bool getTheme() {
    final box = getSettingsBox();
    return box.get(themeKey, defaultValue: false) as bool;
  }
}
