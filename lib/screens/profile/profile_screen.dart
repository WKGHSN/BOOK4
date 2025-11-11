import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/user.dart';
import '../../models/book.dart';
import '../../services/hive_service.dart';
import '../auth/login_screen.dart';
import '../book/book_detail_screen.dart';
import '../../constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  List<Book> _readBooks = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _currentUser = HiveService.getCurrentUser();
      if (_currentUser != null) {
        _readBooks = HiveService.getReadBooks(_currentUser!.id);
      }
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вихід'),
        content: const Text('Ви впевнені, що хочете вийти з акаунту?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await HiveService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  void _showAddBookDialog() {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedGenre = 'Романтика';
    final genres = [
      'Романтика',
      'Фантастика',
      'Детективи',
      'Психологія',
      'Пригоди',
      'Класика',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Додати власну книгу'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Назва книги'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Автор'),
              ),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setState) => DropdownButtonFormField<String>(
                  initialValue: selectedGenre,
                  decoration: const InputDecoration(labelText: 'Жанр'),
                  items: genres
                      .map((genre) => DropdownMenuItem(
                            value: genre,
                            child: Text(genre),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedGenre = value!);
                  },
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Опис'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'txt'],
                  );
                  if (result != null && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Файл вибрано: ${result.files.first.name}'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Вибрати файл'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  authorController.text.isNotEmpty) {
                final newBook = Book(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  author: authorController.text,
                  genre: selectedGenre,
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : 'Опис відсутній',
                );
                await HiveService.addBook(newBook);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Книгу успішно додано!')),
                  );
                }
              }
            },
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark 
        ? AppColors.darkSurface.withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.9);
    final textColor = isDark ? AppColors.darkText : AppColors.darkBrownText;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.softBrown;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: AppColors.goldenAccent.withValues(alpha: 0.9),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.goldenAccent,
                    AppColors.lightGold,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.white,
                    child: Text(
                      _currentUser!.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrownText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentUser!.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.darkBrownText,
                        ),
                  ),
                  Text(
                    _currentUser!.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.softBrown,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Статистика
                Card(
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              'Улюблених',
                              _currentUser!.favoriteBooks.length.toString(),
                              Icons.favorite,
                              isDark,
                            ),
                            _buildStatItem(
                              'Прочитано',
                              _currentUser!.booksRead.toString(),
                              Icons.book,
                              isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Дії (БЕЗ розділу "Налаштування")
                Text(
                  'Дії',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: cardColor,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.add_circle_outline,
                          color: textColor,
                        ),
                        title: Text(
                          'Додати власну книгу',
                          style: TextStyle(color: textColor),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: textColor,
                        ),
                        onTap: _showAddBookDialog,
                      ),
                      Divider(height: 1, color: isDark ? AppColors.darkBorder : null),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: AppColors.error,
                        ),
                        title: const Text(
                          'Вийти з акаунту',
                          style: TextStyle(color: AppColors.error),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: textColor,
                        ),
                        onTap: _logout,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Прочитані книги
                Text(
                  'Прочитані книги',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                
                if (_readBooks.isEmpty)
                  Card(
                    color: cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              size: 48,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.softBrown,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Ви ще не прочитали жодної книги',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: secondaryTextColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _readBooks.length,
                    itemBuilder: (context, index) {
                      final book = _readBooks[index];
                      return Card(
                        color: cardColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: book.coverUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    book.coverUrl!,
                                    width: 40,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 40,
                                        height: 56,
                                        color: AppColors.lightGold,
                                        child: const Icon(
                                          Icons.book,
                                          color: AppColors.goldenAccent,
                                          size: 20,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  width: 40,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGold,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.book,
                                    color: AppColors.goldenAccent,
                                    size: 20,
                                  ),
                                ),
                          title: Text(
                            book.title,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.author,
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: AppColors.goldenAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    book.averageRating.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: textColor,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookDetailScreen(book: book),
                              ),
                            ).then((_) => _loadUserData());
                          },
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: AppColors.goldenAccent,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.darkBrownText,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.softBrown,
          ),
        ),
      ],
    );
  }
}
