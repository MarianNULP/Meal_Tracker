// main.dart
import 'package:flutter/material.dart';
import 'package:meal_tracker/features/auth/login_screen.dart';
import 'package:meal_tracker/features/auth/register_screen.dart';
import 'package:meal_tracker/features/home/home_screen.dart';
import 'package:meal_tracker/data/repositories/local_user_repository.dart';
import 'package:meal_tracker/data/repositories/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository = LocalUserRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.deepPurple,
          secondary: Colors.orangeAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.deepPurple,
            side: const BorderSide(color: Colors.deepPurple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple,
          ),
        ),
      ),
      home: LoginScreen(userRepository: userRepository),
      routes: {
        '/login': (context) => LoginScreen(userRepository: userRepository),
        '/register': (context) => RegisterScreen(userRepository: userRepository),
        '/home': (context) => HomeScreen(userRepository: userRepository),
      },
    );
  }
}
