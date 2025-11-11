import 'package:flutter/material.dart';
import '../models/book.dart';
import '../constants/app_colors.dart';

class GenreSection extends StatelessWidget {
  final String genre;
  final List<Book> books;
  final Function(Book) onBookTap;

  const GenreSection({
    super.key,
    required this.genre,
    required this.books,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  genre,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(
                  _getGenreIcon(genre),
                  color: AppColors.goldenAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return GestureDetector(
                  onTap: () => onBookTap(book),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Обкладинка
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: book.coverUrl != null
                                  ? Image.asset(
                                      book.coverUrl!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.book,
                                            size: 48,
                                            color: AppColors.goldenAccent,
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.book,
                                        size: 48,
                                        color: AppColors.goldenAccent,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Назва
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Автор
                        Text(
                          book.author,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getGenreIcon(String genre) {
    switch (genre) {
      case 'Романтика':
        return Icons.favorite;
      case 'Фантастика':
        return Icons.rocket_launch;
      case 'Детективи':
        return Icons.search;
      case 'Психологія':
        return Icons.psychology;
      case 'Пригоди':
        return Icons.explore;
      case 'Класика':
        return Icons.menu_book;
      default:
        return Icons.book;
    }
  }
}
