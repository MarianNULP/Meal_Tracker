import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meal_tracker/login_screen.dart';
import 'package:meal_tracker/signup_screen.dart';
import 'package:meal_tracker/user_menu.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(MealTrackerApp());
}

class MealTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/userMenu': (context) => UserMenu(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    // Затримка для показу SplashScreen
    await Future.delayed(Duration(seconds: 2));

    // Перевірка наявності збережених даних користувача
    String? email = await _storage.read(key: 'email');
    String? password = await _storage.read(key: 'password');

    if (email != null && password != null) {
      // Перевірка стану мережі
      var connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // Показати діалог про відсутність інтернету
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Відсутнє з\'єднання з інтернетом'),
              content: Text('Ви автоматично залогінені без підключення до інтернету. Деякі функції можуть бути обмежені.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/userMenu');
                  },
                  child: Text('Продовжити'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Автологін
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/userMenu');
      }
    } else {
      // Перехід до екрану входу
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Простий SplashScreen з індикатором завантаження
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
