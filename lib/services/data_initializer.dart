import '../models/book.dart';
import 'hive_service.dart';

class DataInitializer {
  static Future<void> initializeSampleBooks() async {
    // Перевірка чи вже є книги
    final existingBooks = HiveService.getAllBooks();
    if (existingBooks.isNotEmpty) {
      return; // Дані вже ініціалізовані
    }

    final sampleBooks = [
      // Романтика
      Book(
        id: 'book_001',
        title: 'Зірка для тебе',
        author: 'Дара Корній',
        genre: 'Романтика',
        description: 'Історія кохання двох молодих людей, які шукають себе та своє щастя серед життєвих випробувань.',
        coverUrl: 'assets/images/image 9.jpg',
      ),
      Book(
        id: 'book_002',
        title: 'Кафе на краю світу',
        author: 'Джон П. Стрелецький',
        genre: 'Романтика',
        description: 'Невелике кафе змінює життя молодого чоловіка завдяки трьом важливим запитанням про сенс життя і кохання.',
        coverUrl: 'assets/images/image 8.jpg',
      ),
      Book(
        id: 'book_003',
        title: 'До зустрічі з тобою',
        author: 'Джоджо Мойєс',
        genre: 'Романтика',
        description: 'Луїза стає доглядальницею паралізованого чоловіка, і між ними зароджується глибоке почуття, що змінює їхнє життя.',
        coverUrl: 'assets/images/image 7.jpg',
      ),

      // Фантастика
      Book(
        id: 'book_004',
        title: 'Дім, у який…',
        author: 'Маріам Петросян',
        genre: 'Фантастика',
        description: 'Дивний інтернат для особливих дітей, де реальність поступово змішується з фантастикою, створюючи атмосферу магії і дружби.',
        coverUrl: 'assets/images/image 1.jpg',
      ),
      Book(
        id: 'book_005',
        title: 'Дюна',
        author: 'Френк Герберт',
        genre: 'Фантастика',
        description: 'Епічна сага про боротьбу за пустельну планету Арракіс, політику, релігію та боротьбу за виживання серед гігантських піщаних червів.',
        coverUrl: 'assets/images/image 2.jpg',
      ),

      // Детективи
      Book(
        id: 'book_006',
        title: 'Шерлок Холмс. Собака Баскервілів',
        author: 'Артур Конан Дойл',
        genre: 'Детективи',
        description: 'Холмс і Ватсон розслідують загадкову смерть у маєтку Баскервілів, де ходять чутки про демонічного пса.',
        coverUrl: 'assets/images/image 3.jpg',
      ),
      Book(
        id: 'book_007',
        title: 'Вбивство у «Східному експресі»',
        author: 'Агата Крісті',
        genre: 'Детективи',
        description: 'Поїзд застряє в снігу, а одного пасажира знаходять убитим. Пуаро розкриває хитромудру таємницю, у якій підозрюваний майже кожен.',
        coverUrl: 'assets/images/image 4.jpg',
      ),

      // Психологія
      Book(
        id: 'book_008',
        title: 'Атомні звички',
        author: 'Джеймс Клір',
        genre: 'Психологія',
        description: 'Практична книга про те, як змінювати життя через маленькі щоденні звички, які з часом приводять до великих результатів.',
        coverUrl: 'assets/images/image 5.jpg',
      ),
      Book(
        id: 'book_009',
        title: 'Стійкість',
        author: 'Ерік Грейз',
        genre: 'Психологія',
        description: 'Як долати труднощі та зберігати внутрішню рівновагу. Корисна книга про психологічну стійкість у сучасному житті.',
        coverUrl: 'assets/images/image 10.jpg',
      ),

      // Пригоди
      Book(
        id: 'book_010',
        title: 'Острів скарбів',
        author: 'Роберт Льюїс Стівенсон',
        genre: 'Пригоди',
        description: 'Молодий Джим вирушає на пошуки скарбу. Морські пригоди, пірати, карти та небезпеки — класика пригодницького жанру.',
        coverUrl: 'assets/images/image 6.jpg',
      ),
    ];

    // Додавання книг до бази даних
    for (var book in sampleBooks) {
      await HiveService.addBook(book);
    }
  }
}
