// features/menu/user_menu.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:meal_tracker/features/home/home_screen.dart';
import 'package:meal_tracker/features/about/about_screen.dart';
import 'package:meal_tracker/features/profile/profile_screen.dart';
import 'package:meal_tracker/data/repositories/user_repository.dart';

class UserMenu extends StatefulWidget {
  final UserRepository userRepository;
  const UserMenu({super.key, required this.userRepository});

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  int _selectedIndex = 0;
  late StreamSubscription _connectivitySubscription;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Підписуємось на зміни інтернет-з'єднання
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          if (result == ConnectivityResult.none) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Інтернет зник!'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Інтернет відновлено.'),
                backgroundColor: Colors.green,
              ),
            );
          }
        });

    // Визначаємо сторінки нижньої навігації
    _pages = [
      HomeScreen(userRepository: widget.userRepository), // Головна
      ProfileScreen(userRepository: widget.userRepository), // Профіль
      const AboutScreen(), // Про додаток
    ];
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openRecipesPage() {
    // Припускаємо, що в main.dart є: '/mealApi': (context) => const MealApiScreen()
    Navigator.pushNamed(context, '/mealApi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Показуємо одну з трьох сторінок
      body: _pages[_selectedIndex],

      // Кнопка відкриття сторінки з рецептами
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRecipesPage,
        icon: const Icon(Icons.restaurant_menu),
        label: const Text('Рецепти'),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Головна',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Профіль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Про додаток',
          ),
        ],
      ),
    );
  }
}
