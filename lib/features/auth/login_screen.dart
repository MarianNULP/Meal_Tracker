// lib/features/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:meal_tracker/data/repositories/user_repository.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;
  const LoginScreen({required this.userRepository, super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  Future<void> _onLogin() async {
    // Перевіряємо інтернет
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Показуємо діалог про відсутність інтернету
      _showDialog(
        title: 'Помилка',
        message: 'Немає з\'єднання з інтернетом. Логін недоступний.',
      );
      return;
    }

    if (_formKey.currentState?.validate() == true) {
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text;

      final userData = await widget.userRepository.getUser();
      if (userData != null) {
        if (userData['email'] == email && userData['password'] == password) {
          // Успіх
          _showDialog(
            title: 'Логін успішний',
            message: 'Ви увійшли в додаток.',
            onOk: () {
              Navigator.of(context).pop(); // закриваємо діалог
              Navigator.pushReplacementNamed(context, '/home');
            },
          );
        } else {
          // Невірні дані
          _showDialog(
            title: 'Помилка',
            message: 'Невірний логін або пароль.',
          );
        }
      } else {
        // Користувача немає
        _showDialog(
          title: 'Помилка',
          message: 'Спочатку зареєструйтесь (даних немає).',
        );
      }
    }
  }

  void _showDialog({
    required String title,
    required String message,
    VoidCallback? onOk,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: onOk ?? () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вхід'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Увійти в Meal Tracker',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? 'Введіть email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? 'Введіть пароль' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onLogin,
                child: const Text('Увійти'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: const Text('Немає акаунта? Зареєструватись'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
