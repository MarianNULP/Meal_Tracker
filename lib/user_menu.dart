import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  UserMenuState createState() => UserMenuState();
}

class UserMenuState extends State<UserMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(
      title: 'Рецепти',
      content: 'Тут будуть ваші улюблені рецепти.',
      icon: Icons.receipt,
    );
  }
}

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Поточний логін:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        currentEmail,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Новий логін (email)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введіть email';
                            }
                            if (!RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return 'Некоректний email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Новий пароль',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введіть пароль';
                            }
                            if (value.length < 6) {
                              return 'Пароль має бути не менше 6 символів';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await _storage.write(
                                  key: 'email', value: emailController.text,);
                              await _storage.write(
                                  key: 'password', value: passwordController.text,);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Дані успішно оновлено!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Оновлення поточного email після збереження
                              emailController.clear();
                              passwordController.clear();
                            }
                          },
                          child: const Text('Зберегти зміни'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



Widget _buildPageContent({required String title, required String content, required IconData icon}) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blueAccent),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    ),
  );
}
