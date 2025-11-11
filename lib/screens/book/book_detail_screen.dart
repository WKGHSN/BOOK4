import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/book.dart';
import '../../models/rating.dart';
import '../../services/hive_service.dart';
import '../reader/reader_screen.dart';
import '../../constants/app_colors.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isFavorite = false;
  double? _userRating;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final currentUser = HiveService.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        _isFavorite = HiveService.isFavorite(currentUser.id, widget.book.id);
        final rating = HiveService.getUserBookRating(currentUser.id, widget.book.id);
        _userRating = rating?.rating;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final currentUser = HiveService.getCurrentUser();
    if (currentUser != null) {
      await HiveService.toggleFavorite(currentUser.id, widget.book.id);
      setState(() {
        _isFavorite = !_isFavorite;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite
                  ? 'Додано до улюблених'
                  : 'Видалено з улюблених',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _rateBook(double rating) async {
    final currentUser = HiveService.getCurrentUser();
    if (currentUser != null) {
      final newRating = Rating(
        id: '${currentUser.id}_${widget.book.id}',
        userId: currentUser.id,
        bookId: widget.book.id,
        rating: rating,
        createdAt: DateTime.now(),
      );
      await HiveService.addRating(newRating);
      setState(() {
        _userRating = rating;
        // Оновлюємо книгу з новим рейтингом
        // Оновлюємо книгу з бази даних
        final updatedBook = HiveService.getBook(widget.book.id);
        if (updatedBook != null) {
          // Книга вже оновлена в базі даних
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Дякуємо за вашу оцінку!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double tempRating = _userRating ?? 0;
        return AlertDialog(
          title: const Text('Оцінити книгу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Як вам сподобалася ця книга?'),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: tempRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppColors.goldenAccent,
                ),
                onRatingUpdate: (rating) {
                  tempRating = rating;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                _rateBook(tempRating);
                Navigator.pop(context);
              },
              child: const Text('Оцінити'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar з обкладинкою
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.book.coverUrl != null
                  ? Image.asset(
                      widget.book.coverUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.lightGold,
                          child: const Icon(
                            Icons.book,
                            size: 100,
                            color: AppColors.goldenAccent,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.lightGold,
                      child: const Icon(
                        Icons.book,
                        size: 100,
                        color: AppColors.goldenAccent,
                      ),
                    ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),

          // Контент
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Назва книги
                  Text(
                    widget.book.title,
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),

                  // Автор
                  Text(
                    widget.book.author,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.softBrown,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Жанр
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGold.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.book.genre,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkBrownText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Рейтинг
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: widget.book.averageRating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: AppColors.goldenAccent,
                        ),
                        itemCount: 5,
                        itemSize: 24.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.book.averageRating.toStringAsFixed(1)} (${widget.book.ratingCount})',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Опис
                  Text(
                    'Опис',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),

                  // Кнопки дій
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReaderScreen(book: widget.book),
                          ),
                        );
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Читати'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showRatingDialog,
                      icon: const Icon(Icons.star_outline),
                      label: Text(
                        _userRating != null
                            ? 'Змінити оцінку'
                            : 'Оцінити книгу',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
