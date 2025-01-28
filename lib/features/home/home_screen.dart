// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:meal_tracker/data/repositories/user_repository.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;

  const HomeScreen({
    required this.userRepository,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = '';
  String _email = '';
  String _password = '';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userData = await widget.userRepository.getUser();
    if (userData != null) {
      setState(() {
        _name = userData['name'] ?? '';
        _email = userData['email'] ?? '';
        _password = userData['password'] ?? '';
      });
    }
  }

  Future<void> _onSaveChanges() async {
    if (_formKey.currentState?.validate() == true) {
      await widget.userRepository.updateUser(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      await _loadUser();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Дані збережено!')),
      );
    }
  }

  Future<void> _onDeleteAccount() async {
    await widget.userRepository.deleteUser();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Обліковий запис видалено')),
    );
    // Перекидаємо користувача на екран реєстрації чи логіну
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    _nameCtrl.text = _name;
    _emailCtrl.text = _email;
    _passCtrl.text = _password;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Привіт, $_name!',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Форма редагування
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Ім’я'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введіть ім’я';
                      }
                      if (RegExp(r'\d').hasMatch(value)) {
                        return 'Ім’я не має містити цифри';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null ||
                          !value.contains('@') ||
                          !value.contains('.')) {
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
                      if (value == null || value.length < 6) {
                        return 'Пароль має бути >= 6 символів';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _onSaveChanges,
              child: const Text('Зберегти зміни'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _onDeleteAccount,
              child: const Text('Видалити обліковий запис'),
            ),
          ],
        ),
      ),
      // Продемонструємо "плюсик" (CRUD-логіка): для прикладу – створення додаткових даних
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Далі ти можеш розширити логіку: відкрити модалку
          // для додавання якихось даних, зберігати в локалку і т.д.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Натиснуто + (CRUD логіка тут)')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
