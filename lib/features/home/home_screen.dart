// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:meal_tracker/data/repositories/user_repository.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;
  const HomeScreen({required this.userRepository, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name = '';
  String _email = '';
  String _password = '';

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  late StreamSubscription<ConnectivityResult> _connectivitySub;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Відстежуємо зміни інтернету:
    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        setState(() => _isOffline = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Інтернет зник! Офлайн-режим.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() => _isOffline = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Інтернет відновлено!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _connectivitySub.cancel();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
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
      // Якщо хочемо обмежити редагування при відсутності інтернету,
      // можемо перевірити _isOffline і показати повідомлення.
      // Наприклад:
      if (_isOffline) {
        _showDialog(
          title: 'Помилка',
          message: 'Немає інтернету. Зміни не можна зберегти.',
        );
        return;
      }

      await widget.userRepository.updateUser(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      await _loadUserData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Дані збережено!')),
      );
    }
  }

  Future<void> _onDeleteAccount() async {
    // Теж можемо обмежити при офлайні, але це на ваш розсуд
    _showLogoutDialog(
      title: 'Підтвердження',
      message: 'Ви точно хочете видалити акаунт?',
      onConfirm: () async {
        await widget.userRepository.deleteUser();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Акаунт видалено')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
    );
  }

  // Логаут (можна окремо кнопкою Log out)
  Future<void> _onLogout() async {
    _showLogoutDialog(
      title: 'Вихід',
      message: 'Ви дійсно хочете вийти?',
      onConfirm: () async {
        await widget.userRepository.deleteUser();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
    );
  }

  void _onPlusPressed() {
    // CRUD-логіка "додавання" чогось
    // Якщо офлайн => можемо заблокувати. Інакше - дозволити
    if (_isOffline) {
      _showDialog(
        title: 'Офлайн режим',
        message: 'Немає інтернету, не можна додати новий запис.',
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Натиснуто +! (додавання)')),
    );
  }

  void _showDialog({
    required String title,
    required String message,
    VoidCallback? onOk,
  }) {
    showDialog<void>(
      context: context,
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

  void _showLogoutDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // закриваємо діалог
                onConfirm();
              },
              child: const Text('Так, вийти', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _nameCtrl.text = _name;
    _emailCtrl.text = _email;
    _passCtrl.text = _password;

    return Scaffold(
      appBar: AppBar(
        title: Text('Вітаємо, $_name ($_email)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: _onLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Ваш профіль',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Ім\'я'),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Введіть ім\'я';
                      }
                      if (RegExp(r'\d').hasMatch(val)) {
                        return 'Ім\'я не може містити цифри';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (val) {
                      if (val == null ||
                          !val.contains('@') ||
                          !val.contains('.')) {
                        return 'Некоректний Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passCtrl,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.length < 6) {
                        return 'Мін. 6 символів';
                      }
                      return null;
                    },
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
                    child: const Text('Видалити акаунт'),
                  ),
                  if (_isOffline) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'УВАГА: Ви в офлайн-режимі. Деякі функції можуть бути обмежені.',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPlusPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
