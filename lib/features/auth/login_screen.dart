// lib/features/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:meal_tracker/data/repositories/user_repository.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;

  const LoginScreen({
    required this.userRepository,
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  Future<void> _onLogin() async {
    if (_formKey.currentState?.validate() == true) {
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text;

      // Дістаємо з репозиторію дані користувача (якщо є)
      final userData = await widget.userRepository.getUser();
      if (userData != null) {
        // Перевіряємо збіг email/пароль
        if (userData['email'] == email && userData['password'] == password) {
          if (!mounted) return;
          // Успіх
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Невірний логін або пароль
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Невірні облікові дані')),
          );
        }
      } else {
        // Користувач взагалі не зареєстрований
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Спочатку зареєструйтеся')),
        );
      }
    }
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введіть email' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Пароль'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введіть пароль' : null,
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
                child: const Text('Немає облікового запису? Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
