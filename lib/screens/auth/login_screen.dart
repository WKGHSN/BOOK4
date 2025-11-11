import 'package:flutter/material.dart';
import '../../services/hive_service.dart';
import '../../models/user.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // Вхід
        final user = HiveService.getUserByEmail(_emailController.text);
        if (user != null) {
          await HiveService.setCurrentUserId(user.id);
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Користувача не знайдено')),
            );
          }
        }
      } else {
        // Реєстрація
        final existingUser = HiveService.getUserByEmail(_emailController.text);
        if (existingUser != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Користувач з таким email вже існує')),
            );
          }
        } else {
          final newUser = User(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: _nameController.text,
            email: _emailController.text,
          );
          await HiveService.saveUser(newUser);
          await HiveService.setCurrentUserId(newUser.id);
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Логотип
                Image.asset(
                  'assets/icons/app_icon.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 16),
                
                // Назва застосунку
                Text(
                  'BookWave',
                  style: theme.textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ваша кишенькова бібліотека',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 48),
                
                // Поле імені (тільки для реєстрації)
                if (!_isLogin)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Ім'я",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (!_isLogin && (value == null || value.isEmpty)) {
                        return "Будь ласка, введіть ім'я";
                      }
                      return null;
                    },
                  ),
                if (!_isLogin) const SizedBox(height: 16),
                
                // Поле email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть email';
                    }
                    if (!value.contains('@')) {
                      return 'Будь ласка, введіть коректний email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Поле пароля
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль має містити мінімум 6 символів';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                // Кнопка входу/реєстрації
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isLogin ? 'Увійти' : 'Зареєструватися'),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Перемикач режиму
                TextButton(
                  onPressed: () {
                    setState(() => _isLogin = !_isLogin);
                  },
                  child: Text(
                    _isLogin
                        ? 'Ще не маєте акаунту? Зареєструватися'
                        : 'Вже є акаунт? Увійти',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
