import 'package:flutter/material.dart';

// Кольори теми BookWave
class AppColors {
  // Основні кольори
  static const Color creamyBackground = Color(0xFFFAF5EF);
  static const Color darkBrown = Color(0xFF3B2F2F);
  static const Color goldenOlive = Color(0xFFBFAF7B);
  
  // Додаткові кольори
  static const Color lightGold = Color(0xFFD4C5A0);
  static const Color softBrown = Color(0xFF5C4A4A);
  static const Color warmWhite = Color(0xFFFFFBF5);
  
  // Темна тема
  static const Color darkBackground = Color(0xFF2B2520);
  static const Color darkCard = Color(0xFF3B2F2F);
  static const Color darkText = Color(0xFFFAF5EF);
}

// Жанри книг
class BookGenres {
  static const String romance = 'Романтика';
  static const String fantasy = 'Фантастика';
  static const String detective = 'Детективи';
  static const String psychology = 'Психологія';
  static const String adventure = 'Пригоди';
  static const String classic = 'Класика';

  static List<String> get all => [
        romance,
        fantasy,
        detective,
        psychology,
        adventure,
        classic,
      ];

  static IconData getIcon(String genre) {
    switch (genre) {
      case romance:
        return Icons.favorite;
      case fantasy:
        return Icons.auto_awesome;
      case detective:
        return Icons.search;
      case psychology:
        return Icons.psychology;
      case adventure:
        return Icons.explore;
      case classic:
        return Icons.book;
      default:
        return Icons.menu_book;
    }
  }
}

// Налаштування рідера
class ReaderSettings {
  static const double minFontSize = 12.0;
  static const double maxFontSize = 32.0;
  static const double defaultFontSize = 16.0;
  
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';
  static const String sepiaTheme = 'sepia';
}

// Ключі для збереження даних
class StorageKeys {
  static const String currentUser = 'current_user';
  static const String isLoggedIn = 'is_logged_in';
  static const String userId = 'user_id';
  static const String readerFontSize = 'reader_font_size';
  static const String readerTheme = 'reader_theme';
  static const String appTheme = 'app_theme';
}

// Hive box names
class HiveBoxes {
  static const String books = 'books';
  static const String users = 'users';
  static const String settings = 'settings';
}

// Тривалість анімацій
class AnimationDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
}

// Відступи та розміри
class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;
  
  static const double iconSize = 24.0;
  static const double iconSizeLarge = 32.0;
  
  static const double bookCoverHeight = 180.0;
  static const double bookCoverWidth = 130.0;
}
