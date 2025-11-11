import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundService {
  static const String _backgroundKey = 'selected_background';
  
  // Доступні градієнтні фони (з темними версіями)
  static final List<BackgroundOption> backgrounds = [
    BackgroundOption(
      id: 'default',
      name: 'Кремовий класичний',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFAF5EF), Color(0xFFF5EDE0)],
      ),
      darkGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
      ),
    ),
    BackgroundOption(
      id: 'golden_sunset',
      name: 'Золотий захід',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFF4E6), Color(0xFFFFE4B5), Color(0xFFFFD89B)],
      ),
      darkGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1E1B18), Color(0xFF2C2418), Color(0xFF3A2F1E)],
      ),
    ),
    BackgroundOption(
      id: 'warm_library',
      name: 'Тепла бібліотека',
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF8E1), Color(0xFFFFE082), Color(0xFFFFD54F)],
      ),
      darkGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A1612), Color(0xFF2A2015), Color(0xFF3A2A18)],
      ),
    ),
    BackgroundOption(
      id: 'soft_peach',
      name: 'М\'який персик',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFE5D9), Color(0xFFFFCCBC), Color(0xFFFFAB91)],
      ),
      darkGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1F1816), Color(0xFF2A1F1C), Color(0xFF352621)],
      ),
    ),
    BackgroundOption(
      id: 'vintage_paper',
      name: 'Вінтажний папір',
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFF5F5DC), Color(0xFFE8DCC4), Color(0xFFD4C5A9)],
      ),
      darkGradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF18181A), Color(0xFF252422), Color(0xFF322F28)],
      ),
    ),
    BackgroundOption(
      id: 'calm_morning',
      name: 'Спокійний ранок',
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFDE7), Color(0xFFFFF9C4), Color(0xFFFFF59D)],
      ),
      darkGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A1A14), Color(0xFF252419), Color(0xFF2F2D1D)],
      ),
    ),
    BackgroundOption(
      id: 'gentle_rose',
      name: 'Ніжна троянда',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0), Color(0xFFF48FB1)],
      ),
      darkGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1F161A), Color(0xFF2A1D23), Color(0xFF35242C)],
      ),
    ),
    BackgroundOption(
      id: 'misty_lavender',
      name: 'Туманна лаванда',
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7), Color(0xFFCE93D8)],
      ),
      darkGradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFF1A1620), Color(0xFF241D2A), Color(0xFF2E2435)],
      ),
    ),
  ];

  static Future<String> getSavedBackground() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_backgroundKey) ?? 'default';
  }

  static Future<void> saveBackground(String backgroundId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundKey, backgroundId);
  }

  static BackgroundOption getBackgroundById(String id) {
    return backgrounds.firstWhere(
      (bg) => bg.id == id,
      orElse: () => backgrounds[0],
    );
  }
}

class BackgroundOption {
  final String id;
  final String name;
  final LinearGradient gradient;
  final LinearGradient darkGradient;

  const BackgroundOption({
    required this.id,
    required this.name,
    required this.gradient,
    required this.darkGradient,
  });
}
