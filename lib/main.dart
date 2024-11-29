import 'dart:async'; // Для StreamSubscription
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meal_tracker/login_screen.dart';
import 'package:meal_tracker/signup_screen.dart';
import 'package:meal_tracker/user_menu.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(MealTrackerApp());
}

class MealTrackerApp extends StatefulWidget {
  @override
  _MealTrackerAppState createState() => _MealTrackerAppState();
}

class _MealTrackerAppState extends State<MealTrackerApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();

    // Слухаємо зміни стану інтернет-з'єднання
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showNoConnectionDialog();
        setState(() {
          _isConnected = false;
        });
      } else {
        setState(() {
          _isConnected = true;
        });
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
      builder: (context, child) {
        // Глобальне сповіщення про статус інтернет-з'єднання
        return Stack(
          children: [
            child!,
            if (!_isConnected)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Немає підключення до інтернету',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
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
      // Якщо користувач залогінений
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
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
