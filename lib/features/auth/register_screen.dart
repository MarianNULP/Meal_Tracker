// lib/features/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:meal_tracker/data/repositories/user_repository.dart';

class RegisterScreen extends StatefulWidget {
  final UserRepository userRepository;

  const RegisterScreen({
    required this.userRepository,
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  // Метод валідації (додаткові перевірки можна розширювати)
  bool _validateName(String value) {
    // Ім'я не має бути порожнє і не має містити цифри
    if (value.isEmpty) return false;
    if (RegExp(r'\d').hasMatch(value)) return false;
    return true;
  }

  bool _validateEmail(String value) {
    // Примітивна перевірка
    return value.contains('@') && value.contains('.');
  }

  bool _validatePassword(String value) {
    return value.length >= 6;
  }

  Future<void> _onRegister() async {
    if (_formKey.currentState?.validate() == true) {
      // Якщо валідація пройшла
      final name = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text;

      // Збереження користувача в локальне сховище
      await widget.userRepository.registerUser(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Реєстрація успішна!')),
      );

      // Перехід на екран логіну або одразу на Home
      Navigator.pushReplacementNamed(context, '/login');
    }
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Ім’я'),
                validator: (value) {
                  if (value == null || !_validateName(value)) {
                    return 'Некоректне ім’я (не повинно містити цифри)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || !_validateEmail(value)) {
                    return 'Некоректна email адреса';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Пароль'),
                validator: (value) {
                  if (value == null || !_validatePassword(value)) {
                    return 'Пароль має бути не менше 6 символів';
                  }
                  return null;
                },
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
