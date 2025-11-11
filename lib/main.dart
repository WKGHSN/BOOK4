import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_themes.dart';
import 'services/hive_service.dart';
import 'services/data_initializer.dart';
import 'services/background_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ініціалізація Hive
  await HiveService.init();
  
  // Ініціалізація демо-книг
  await DataInitializer.initializeSampleBooks();
  
  runApp(const BookWaveApp());
}

class BookWaveApp extends StatelessWidget {
  const BookWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BackgroundProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'BookWave',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AuthCheck(),
          );
        },
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // ОБОВ'ЯЗКОВИЙ ВХІД: Завжди показуємо екран входу, якщо користувач не авторизований
    final currentUser = HiveService.getCurrentUser();
    
    if (currentUser != null) {
      return const HomeScreen();
    } else {
      // Обов'язковий вхід при запуску
      return const LoginScreen();
    }
  }
}

// Provider для управління темою
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    _isDarkMode = HiveService.getTheme();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await HiveService.setTheme(_isDarkMode);
    notifyListeners();
  }
  
  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    await HiveService.setTheme(_isDarkMode);
    notifyListeners();
  }
}

// Provider для управління фоном
class BackgroundProvider extends ChangeNotifier {
  String _currentBackgroundId = 'default';
  
  String get currentBackgroundId => _currentBackgroundId;
  
  BackgroundOption get currentBackground {
    return BackgroundService.getBackgroundById(_currentBackgroundId);
  }

  BackgroundProvider() {
    _loadBackground();
  }

  Future<void> _loadBackground() async {
    _currentBackgroundId = await BackgroundService.getSavedBackground();
    notifyListeners();
  }

  Future<void> setBackground(String backgroundId) async {
    _currentBackgroundId = backgroundId;
    await BackgroundService.saveBackground(backgroundId);
    notifyListeners();
  }
}
