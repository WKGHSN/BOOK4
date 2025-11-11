import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../models/user.dart';
import '../../services/hive_service.dart';
import '../book/book_detail_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/book_card.dart';
import '../../widgets/genre_section.dart';
import '../../main.dart';
import '../../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  User? _currentUser;
  String? _selectedGenre;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _genres = [
    'Всі',
    'Романтика',
    'Фантастика',
    'Детективи',
    'Психологія',
    'Пригоди',
    'Класика',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _loadData();
    _fadeController.forward();
  }

  void _loadData() {
    setState(() {
      _currentUser = HiveService.getCurrentUser();
      _allBooks = HiveService.getAllBooks();
      _filteredBooks = _allBooks;
    });
  }

  void _filterBooks(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = _selectedGenre == null || _selectedGenre == 'Всі'
            ? _allBooks
            : _allBooks.where((book) => book.genre == _selectedGenre).toList();
      } else {
        var filtered = _allBooks.where((book) {
          return book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.author.toLowerCase().contains(query.toLowerCase());
        });
        
        if (_selectedGenre != null && _selectedGenre != 'Всі') {
          filtered = filtered.where((book) => book.genre == _selectedGenre);
        }
        
        _filteredBooks = filtered.toList();
      }
    });
  }

  void _selectGenre(String genre) {
    setState(() {
      _selectedGenre = genre;
      _filterBooks(_searchController.text);
    });
  }

  List<Book> _getBooksByGenre(String genre) {
    return _allBooks.where((book) => book.genre == genre).take(3).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildLibraryScreen() {
    final backgroundProvider = Provider.of<BackgroundProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Container(
      decoration: BoxDecoration(
        gradient: isDark 
            ? backgroundProvider.currentBackground.darkGradient
            : backgroundProvider.currentBackground.gradient,
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar з перемикачем теми
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'BookWave',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              // Перемикач теми (🌙/☀️)
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    key: ValueKey(isDark),
                  ),
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                tooltip: isDark ? 'Світла тема' : 'Темна тема',
              ),
            ],
          ),

          // Фільтр категорій з анімацією
          SliverToBoxAdapter(
            child: Container(
              height: 56,
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                itemCount: _genres.length,
                itemBuilder: (context, index) {
                  final genre = _genres[index];
                  final isSelected = _selectedGenre == genre || 
                      (_selectedGenre == null && genre == 'Всі');
                  
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _selectGenre(genre),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppColors.goldenAccent
                                : (isDark 
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.8)),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: AppColors.goldenAccent.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ] : [],
                          ),
                          child: Text(
                            genre,
                            style: TextStyle(
                              color: isSelected 
                                  ? AppColors.darkBrownText 
                                  : (isDark 
                                      ? Colors.white 
                                      : AppColors.softBrown),
                              fontWeight: isSelected 
                                  ? FontWeight.bold 
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Пошук
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: _filterBooks,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Пошук книг або авторів...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.white70 : AppColors.softBrown,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDark ? Colors.white70 : AppColors.softBrown,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterBooks('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark 
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),

          // Результати або категорії
          if (_searchController.text.isNotEmpty || _selectedGenre != null && _selectedGenre != 'Всі')
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: _filteredBooks.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: isDark ? Colors.white30 : Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Книг не знайдено',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: BookCard(
                              book: _filteredBooks[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookDetailScreen(
                                      book: _filteredBooks[index],
                                    ),
                                  ),
                                ).then((_) => _loadData());
                              },
                            ),
                          );
                        },
                        childCount: _filteredBooks.length,
                      ),
                    ),
            )
          else
            // Жанрові секції
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final genre = _genres[index + 1];
                  final books = _getBooksByGenre(genre);
                  if (books.isEmpty) return const SizedBox.shrink();
                  
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: GenreSection(
                      genre: genre,
                      books: books,
                      onBookTap: (book) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailScreen(book: book),
                          ),
                        ).then((_) => _loadData());
                      },
                    ),
                  );
                },
                childCount: _genres.length - 1,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundProvider = Provider.of<BackgroundProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    final screens = [
      _buildLibraryScreen(),
      Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? backgroundProvider.currentBackground.darkGradient
              : backgroundProvider.currentBackground.gradient,
        ),
        child: const FavoritesScreen(),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? backgroundProvider.currentBackground.darkGradient
              : backgroundProvider.currentBackground.gradient,
        ),
        child: const ProfileScreen(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          if (index != 0) {
            _searchController.clear();
            _filterBooks('');
          } else {
            _loadData();
          }
        },
        backgroundColor: isDark 
            ? const Color(0xFF1E293B).withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Головна',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Улюблені',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}
