// lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:meal_tracker/data/repositories/user_repository.dart';

class SplashScreen extends StatefulWidget {
  final UserRepository userRepository;
  const SplashScreen({required this.userRepository, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Починаємо процес перевірок
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    // Почекаємо 2с, щоб показати Splash
    await Future.delayed(const Duration(seconds: 2));

    // Зчитуємо дані користувача
    final userData = await widget.userRepository.getUser();
    if (userData != null) {
      // Є збережені дані => перевіряємо інтернет
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // Немає інтернету, але дані є => дозволяємо офлайн-доступ
        // Показуємо попередження
        if (!mounted) return;
        _showNoInternetDialog(offlineLoginAllowed: true);
      } else {
        // Є інтернет => автологін (фактично, просто переходимо на Home)
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/userMenu');
      }
    } else {
      // Даних немає => переходимо на Login
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _showNoInternetDialog({required bool offlineLoginAllowed}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // користувач не закриє, не натиснувши кнопку
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Немає Інтернету'),
          content: offlineLoginAllowed
              ? const Text(
              'Автологін виконано офлайн. Деякі функції можуть бути недоступні.')
              : const Text(
              'Для логіну потрібне з\'єднання з інтернетом.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // закриваємо діалог
                if (offlineLoginAllowed) {
                  // Переходимо в Home (офлайн-режим)
                  Navigator.pushReplacementNamed(context, '/userMenu');
                } else {
                  // Повертаємося на Login
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // Простий Splash: spinner
        child: CircularProgressIndicator(),
      ),
    );
  }
}
