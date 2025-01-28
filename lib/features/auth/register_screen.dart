// lib/features/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:meal_tracker/data/repositories/user_repository.dart';

class RegisterScreen extends StatefulWidget {
  final UserRepository userRepository;
  const RegisterScreen({required this.userRepository, super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _validateName(String val) {
    if (val.isEmpty) return false;
    // Не має містити цифр
    if (RegExp(r'\d').hasMatch(val)) return false;
    return true;
  }

  bool _validateEmail(String val) {
    return val.contains('@') && val.contains('.');
  }

  bool _validatePassword(String val) {
    return val.length >= 6;
  }

  Future<void> _onRegister() async {
    // Перевірка інтернету
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showDialog(
        title: 'Помилка',
        message: 'Немає з\'єднання з інтернетом. Реєстрація недоступна.',
      );
      return;
    }

    if (_formKey.currentState?.validate() == true) {
      await widget.userRepository.registerUser(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      if (!mounted) return;
      // Показуємо діалог успіху
      _showDialog(
        title: 'Успішна реєстрація',
        message: 'Тепер ви можете увійти.',
        onOk: () {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/login');
        },
      );
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
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Створити акаунт',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Ім\'я',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) => val == null || !_validateName(val)
                    ? 'Некоректне ім\'я (без цифр)'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) => val == null || !_validateEmail(val)
                    ? 'Некоректний email'
                    : null,
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
                val == null || !_validatePassword(val) ? 'Мін. 6 символів' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onRegister,
                child: const Text('Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
