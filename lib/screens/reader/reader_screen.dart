import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/book.dart';
import '../../constants/app_colors.dart';

class ReaderScreen extends StatefulWidget {
  final Book book;

  const ReaderScreen({super.key, required this.book});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  ScrollController? _scrollController;
  double _progress = 0.0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(_updateProgress);
    _loadSettings();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('reader_dark_mode') ?? false;
      _fontSize = prefs.getDouble('reader_font_size') ?? 16.0;
      _progress = prefs.getDouble('book_progress_${widget.book.id}') ?? 0.0;
    });
    
    // Відновлення позиції прокрутки
    if (_progress > 0 && _scrollController!.hasClients) {
      _scrollController!.jumpTo(_progress * _scrollController!.position.maxScrollExtent);
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reader_dark_mode', _isDarkMode);
    await prefs.setDouble('reader_font_size', _fontSize);
    await prefs.setDouble('book_progress_${widget.book.id}', _progress);
  }

  void _updateProgress() {
    if (_scrollController!.hasClients) {
      final maxScroll = _scrollController!.position.maxScrollExtent;
      final currentScroll = _scrollController!.position.pixels;
      if (maxScroll > 0) {
        setState(() {
          _progress = currentScroll / maxScroll;
        });
        _saveSettings();
      }
    }
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _saveSettings();
  }

  void _changeFontSize(bool increase) {
    setState(() {
      if (increase && _fontSize < 24) {
        _fontSize += 2;
      } else if (!increase && _fontSize > 12) {
        _fontSize -= 2;
      }
    });
    _saveSettings();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  // Демо-текст для читання (оскільки файли не завантажені)
  String _getDemoText() {
    return '''
${widget.book.title}
Автор: ${widget.book.author}

${widget.book.description}

Це демонстраційна версія читалки BookWave. У повній версії застосунку тут буде відображатися зміст книги у форматі PDF або TXT.

Можливості читалки:
• Перемикання між світлою та темною темою
• Зміна розміру шрифту для комфортного читання
• Збереження прогресу читання
• Повноекранний режим без відволікань
• Відображення прогресу у відсотках

Додаткові можливості:
• Підтримка різних форматів: PDF, TXT
• Закладки на важливих сторінках
• Нотатки та виділення тексту
• Швидкий доступ до розділів
• Автоматичне збереження позиції

BookWave - це ваша персональна бібліотека, яка завжди з вами. Читайте улюблені книги в будь-який час та в будь-якому місці.

Атмосфера затишної бібліотеки, теплі кольори та зручний інтерфейс створені для того, щоб ваше читання було максимально комфортним.

Насолоджуйтесь читанням! 📚
''';
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isDarkMode ? AppColors.darkBackground : AppColors.creamBackground;
    final textColor = _isDarkMode ? AppColors.darkText : AppColors.darkBrownText;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _showControls
          ? AppBar(
              backgroundColor: backgroundColor,
              foregroundColor: textColor,
              title: Text(
                widget.book.title,
                style: TextStyle(color: textColor),
              ),
              actions: [
                Text(
                  '${(_progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(width: 16),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: _toggleControls,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24.0),
          child: SelectableText(
            _getDemoText(),
            style: TextStyle(
              fontSize: _fontSize,
              color: textColor,
              height: 1.6,
              fontFamily: 'Georgia',
            ),
          ),
        ),
      ),
      bottomNavigationBar: _showControls
          ? Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Темна тема
                  IconButton(
                    icon: Icon(
                      _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: textColor,
                    ),
                    onPressed: _toggleDarkMode,
                    tooltip: _isDarkMode ? 'Світла тема' : 'Темна тема',
                  ),
                  
                  // Зменшити шрифт
                  IconButton(
                    icon: Icon(
                      Icons.text_decrease,
                      color: textColor,
                    ),
                    onPressed: () => _changeFontSize(false),
                    tooltip: 'Зменшити шрифт',
                  ),
                  
                  // Розмір шрифту
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.goldenAccent.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_fontSize.toInt()}',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Збільшити шрифт
                  IconButton(
                    icon: Icon(
                      Icons.text_increase,
                      color: textColor,
                    ),
                    onPressed: () => _changeFontSize(true),
                    tooltip: 'Збільшити шрифт',
                  ),
                  
                  // Прогрес
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: textColor,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Прогрес читання'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LinearProgressIndicator(
                                value: _progress,
                                backgroundColor: AppColors.lightGold,
                                color: AppColors.goldenAccent,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Прочитано: ${(_progress * 100).toStringAsFixed(1)}%',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Закрити'),
                            ),
                          ],
                        ),
                      );
                    },
                    tooltip: 'Прогрес читання',
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
