// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meal_tracker/forgot_password_screen.dart';
import 'package:meal_tracker/signup_screen.dart';
import 'package:meal_tracker/user_menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final FlutterSecureStorage _storage = const FlutterSecureStorage(); // Ініціалізація сховища

void _login() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text;

  if (_formKey.currentState!.validate()) {
    final storedEmail = await _storage.read(key: 'email');
    final storedPassword = await _storage.read(key: 'password');

    if (storedEmail == email && storedPassword == password) {
      if (mounted) {
        // Якщо прапорець "Запам'ятати мене" встановлено
        if (_rememberMe) {
          await _storage.write(key: 'authToken', value: 'some_generated_token');
        } else {
          // Якщо прапорець вимкнено — видаляємо токен
          await _storage.delete(key: 'authToken');
        }

        // Зберігаємо стан прапорця
        await _storage.write(key: 'rememberMe', value: _rememberMe.toString());

        // Повідомлення про успішний вхід
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Успішний вхід'),
            backgroundColor: Colors.green,
          ),
        );

        // Затримка перед переходом
        await Future.delayed(const Duration(seconds: 1));

        // Перехід до меню користувача
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<Widget>(builder: (context) => const UserMenu()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Невірний логін або пароль'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Трекер харчування'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Ласкаво просимо до Трекера харчування!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Електронна пошта',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Будь ласка, введіть електронну пошту';
                      }
                      if (!RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Введіть дійсну електронну пошту';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Будь ласка, введіть пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль повинен містити мінімум 6 символів';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      const Text(
                        'Запам\'ятати мене',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      'Увійти',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Забули пароль?',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Немає облікового запису? Зареєструйтесь',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
