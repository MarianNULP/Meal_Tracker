import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Модель для рецепта
class Recipe {
  final String title;
  final String imageUrl;
  final String instructions;

  Recipe(
      {required this.title,
      required this.imageUrl,
      required this.instructions});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] as String, // Явне приведення до String
      imageUrl: json['image'] as String, // Явне приведення до String
      instructions: (json['instructions'] ?? 'Немає інструкцій')
          as String, // Явне приведення до String
    );
  }
}

// Функція для отримання рецептів з Spoonacular API
Future<List<Recipe>> fetchRecipes(String query) async {
  final apiKey = '3fc94d9307a54a5684f7436161176f55'; // Замініть на ваш API ключ
  final url =
      'https://api.spoonacular.com/recipes/complexSearch?query=$query&apiKey=$apiKey';

  final response = await http.get(Uri.parse(url));

if (response.statusCode == 200) {
  final data = json.decode(response.body);

  // Перевірка, чи 'results' є списком
  if (data['results'] != null && data['results'] is List) {
    final List<dynamic> results = data['results'] as List<dynamic>;  // Приведення до List<dynamic>
    
    // Перевіряємо, чи кожен елемент в списку є Map<String, dynamic>
    return results
        .map((recipeJson) =>
            Recipe.fromJson(recipeJson as Map<String, dynamic>))  // Перетворюємо елементи на Map<String, dynamic>
        .toList();
  } else {
    throw Exception('Невірний формат даних для results');
  }
} else {
  throw Exception('Не вдалося отримати рецепти');
}

}

// Головне меню
class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  UserMenuState createState() => UserMenuState();
}

class UserMenuState extends State<UserMenu> {
  int _selectedIndex = 0;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showNoConnectionDialog();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _showNoConnectionDialog() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Відсутнє з\'єднання з інтернетом'),
          content: const Text(
              'Інтернет-з\'єднання не виявлено. Деякі функції можуть бути обмежені.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Закрити'),
            ),
          ],
        ),
      );
    }
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoConnectionDialog();
    }
  }

  final List<Widget> _pages = <Widget>[
    const RecipesPage(),
    const CalendarPage(),
    const DailyExpensesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Головне меню',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Рецепти',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Календар',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Витрати',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Налаштування',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Сторінка для відображення рецептів
class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late Future<List<Recipe>> recipes;

  @override
  void initState() {
    super.initState();
    recipes = fetchRecipes('pasta'); // Ви можете змінити запит на іншу страву
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепти'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Recipe>>(
        future: recipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Помилка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Немає рецептів для відображення.'));
          } else {
            final recipeList = snapshot.data!;
            return ListView.builder(
              itemCount: recipeList.length,
              itemBuilder: (context, index) {
                final recipe = recipeList[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(recipe.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(recipe.instructions),
                    trailing: Image.network(recipe.imageUrl),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Інші сторінки залишаються такими ж

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      title: 'Календар',
      content: 'Тут ви можете планувати ваші прийоми їжі.',
      icon: Icons.calendar_today,
    );
  }
}

class DailyExpensesPage extends StatelessWidget {
  const DailyExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      title: 'Витрати на кожен день',
      content: 'Тут ви можете відстежувати витрати.',
      icon: Icons.money,
    );
  }
}

class SettingsPage extends StatelessWidget {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  const SettingsPage({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Підтвердження'),
          content: const Text('Ви дійсно хочете вийти з акаунту?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрити діалогове вікно
              },
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () async {
                // Очищення даних із Secure Storage
                await _storage.deleteAll();
                Navigator.of(context).pop(); // Закрити діалогове вікно
                Navigator.of(context)
                    .pushReplacementNamed('/login'); // Перехід на екран входу
              },
              child: const Text('Вийти'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: FutureBuilder<String?>(
            future: _storage.read(key: 'email'),
            builder: (context, snapshot) {
              final String currentEmail = snapshot.data ?? 'Немає даних';

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Налаштування профілю',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          'Електронна пошта: ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          currentEmail,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _confirmLogout(context),
                      child: const Text('Вийти'),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

Widget _buildPageContent(
    {required String title, required String content, required IconData icon}) {
  return Center(
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 300,
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(content, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ),
  );
}
