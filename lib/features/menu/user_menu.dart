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

    // Набір сторінок - наприклад:
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
