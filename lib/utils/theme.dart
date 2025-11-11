import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  // Світла тема (основна)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Кольорова схема
      colorScheme: ColorScheme.light(
        primary: AppColors.goldenOlive,
        secondary: AppColors.lightGold,
        surface: AppColors.creamyBackground,
        error: Colors.red.shade400,
        onPrimary: Colors.white,
        onSecondary: AppColors.darkBrown,
        onSurface: AppColors.darkBrown,
      ),
      
      // Фонові кольори
      scaffoldBackgroundColor: AppColors.creamyBackground,
      
      // Типографія
      textTheme: TextTheme(
        displayLarge: GoogleFonts.merriweather(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBrown,
        ),
        displayMedium: GoogleFonts.merriweather(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBrown,
        ),
        displaySmall: GoogleFonts.merriweather(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBrown,
        ),
        headlineMedium: GoogleFonts.merriweather(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkBrown,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkBrown,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkBrown,
        ),
        bodyLarge: GoogleFonts.merriweather(
          fontSize: 16,
          color: AppColors.darkBrown,
        ),
        bodyMedium: GoogleFonts.merriweather(
          fontSize: 14,
          color: AppColors.darkBrown,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // AppBar тема
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.creamyBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.darkBrown),
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBrown,
        ),
      ),
      
      // Картки
      cardTheme: CardThemeData(
        color: AppColors.warmWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
      ),
      
      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldenOlive,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.goldenOlive,
          side: const BorderSide(color: AppColors.goldenOlive, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Поля введення
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.warmWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: AppColors.lightGold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: AppColors.lightGold),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: AppColors.goldenOlive, width: 2),
        ),
        labelStyle: GoogleFonts.nunito(color: AppColors.softBrown),
        hintStyle: GoogleFonts.nunito(color: AppColors.softBrown.withValues(alpha: 0.6)),
      ),
      
      // Іконки
      iconTheme: const IconThemeData(
        color: AppColors.goldenOlive,
        size: AppSizes.iconSize,
      ),
      
      // Нижня навігація
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.warmWhite,
        selectedItemColor: AppColors.goldenOlive,
        unselectedItemColor: AppColors.softBrown,
        selectedLabelStyle: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 12),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
  
  // Темна тема
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Кольорова схема
      colorScheme: ColorScheme.dark(
        primary: AppColors.goldenOlive,
        secondary: AppColors.lightGold,
        surface: AppColors.darkBackground,
        error: Colors.red.shade300,
        onPrimary: AppColors.darkBrown,
        onSecondary: AppColors.darkBackground,
        onSurface: AppColors.darkText,
      ),
      
      // Фонові кольори
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // Типографія
      textTheme: TextTheme(
        displayLarge: GoogleFonts.merriweather(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        displayMedium: GoogleFonts.merriweather(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        displaySmall: GoogleFonts.merriweather(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        headlineMedium: GoogleFonts.merriweather(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkText,
        ),
        bodyLarge: GoogleFonts.merriweather(
          fontSize: 16,
          color: AppColors.darkText,
        ),
        bodyMedium: GoogleFonts.merriweather(
          fontSize: 14,
          color: AppColors.darkText,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.darkBrown,
        ),
      ),
      
      // AppBar тема
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCard,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.darkText),
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
      ),
      
      // Картки
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
      ),
      
      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldenOlive,
          foregroundColor: AppColors.darkBrown,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Нижня навігація
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        selectedItemColor: AppColors.goldenOlive,
        unselectedItemColor: AppColors.darkText.withValues(alpha: 0.6),
        selectedLabelStyle: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 12),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
