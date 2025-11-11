import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/hive_service.dart';
import '../book/book_detail_screen.dart';
import '../../widgets/book_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Book> _favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final currentUser = HiveService.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        _favoriteBooks = HiveService.getFavoriteBooks(currentUser.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Улюблені книги',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        _favoriteBooks.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ще немає улюблених книг',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Додайте книги, які вам подобаються',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return BookCard(
                        book: _favoriteBooks[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailScreen(
                                book: _favoriteBooks[index],
                              ),
                            ),
                          ).then((_) => _loadFavorites());
                        },
                      );
                    },
                    childCount: _favoriteBooks.length,
                  ),
                ),
              ),
      ],
    );
  }
}
