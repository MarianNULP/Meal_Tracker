import 'package:flutter/material.dart';

// Якщо у вас є LocalUserRepository
import 'package:meal_tracker/data/repositories/local_user_repository.dart';
// Якщо у вас є RemoteUserRepository у такому-то файлі
// import 'package:meal_tracker/data/repositories/remote_user_repository.dart';

// Решта імпортів:
import 'package:meal_tracker/data/repositories/user_repository.dart';
import 'package:meal_tracker/features/splash/splash_screen.dart';
import 'package:meal_tracker/features/auth/login_screen.dart';
import 'package:meal_tracker/features/auth/register_screen.dart';
import 'package:meal_tracker/features/home/home_screen.dart';
import 'package:meal_tracker/features/profile/profile_screen.dart';
import 'package:meal_tracker/features/about/about_screen.dart';
import 'package:meal_tracker/features/menu/user_menu.dart';
import 'package:meal_tracker/features/meal_api/meal_api_screen.dart';

void main() {
  // Оберіть, який репозиторій використовувати:
  // final userRepository = RemoteUserRepository(baseUrl: 'https://example.com');
  final UserRepository userRepository = LocalUserRepository();

  runApp(MyApp(userRepository: userRepository));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker Lab',
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
      // Початковий екран (SplashScreen або LoginScreen)
      home: SplashScreen(userRepository: userRepository),

      // Маршрути
      routes: {
        '/splash': (context) => SplashScreen(userRepository: userRepository),
        '/login': (context) => LoginScreen(userRepository: userRepository),
        '/register': (context) => RegisterScreen(userRepository: userRepository),
        '/home': (context) => HomeScreen(userRepository: userRepository),
        '/profile': (context) => ProfileScreen(userRepository: userRepository),
        '/about': (context) => const AboutScreen(),
        '/userMenu': (context) => UserMenu(userRepository: userRepository),

        // Якщо у вас є MealApiScreen
        '/mealApi': (context) => const MealApiScreen(),
      },
    );
  }
}
