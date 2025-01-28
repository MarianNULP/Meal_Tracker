// main.dart
import 'package:flutter/material.dart';
import 'package:meal_tracker/data/repositories/local_user_repository.dart';
import 'package:meal_tracker/data/repositories/user_repository.dart';
import 'package:meal_tracker/features/splash/splash_screen.dart';
import 'package:meal_tracker/features/auth/login_screen.dart';
import 'package:meal_tracker/features/auth/register_screen.dart';
import 'package:meal_tracker/features/home/home_screen.dart';
import 'package:meal_tracker/features/profile/profile_screen.dart';
import 'package:meal_tracker/features/about/about_screen.dart';
import 'package:meal_tracker/features/menu/user_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final UserRepository userRepository = LocalUserRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker Lab-3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.deepPurple,
          secondary: Colors.orangeAccent,
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      // Початковий екран - SplashScreen
      home: SplashScreen(userRepository: userRepository),
      routes: {
        '/splash': (context) => SplashScreen(userRepository: userRepository),
        '/login': (context) => LoginScreen(userRepository: userRepository),
        '/register': (context) => RegisterScreen(userRepository: userRepository),
        '/home': (context) => HomeScreen(userRepository: userRepository),
        '/profile': (context) => ProfileScreen(userRepository: userRepository),
        '/about': (context) => const AboutScreen(),
        '/userMenu': (context) => UserMenu(userRepository: userRepository),
      },
    );
  }
}
