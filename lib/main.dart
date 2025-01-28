import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meal_tracker/home_screen.dart';
import 'package:meal_tracker/login_screen.dart';
import 'package:meal_tracker/user_menu.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = const FlutterSecureStorage();

  // Читаємо дані з пам'яті
  final rememberMe = await storage.read(key: 'rememberMe') == 'true';
  final authToken = await storage.read(key: 'authToken');

  runApp(
    MaterialApp(
      home: (rememberMe && authToken != null)
          ? const UserMenu() // Якщо "Запам'ятати мене" ввімкнено, переходимо до UserMenu
          : const LoginScreen(), // Інакше — до екрана логіну
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartupScreen(), // Викликаємо екран запуску
    );
  }
}

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Перевіряємо, чи є токен у сховищі
    final token = await _storage.read(key: 'authToken');
    final rememberMe = await _storage.read(key: 'rememberMe');

    if (token != null && rememberMe == 'true') {
      // Якщо токен існує і функція "Запам'ятати мене" активна
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<Widget>(builder: (context) => const UserMenu()),
      );
    } else {
      // Якщо даних немає, перенаправляємо на HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<Widget>(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Повертаємо тимчасовий екран, поки йде перевірка
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
