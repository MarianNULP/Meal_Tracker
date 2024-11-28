import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Підключення пакету
import 'package:meal_tracker/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

void _signup() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text;
  const name = 'New User'; // Якщо потрібне ім'я, додайте TextEditingController для нього

  // Перевірка введених даних
  if (isValidEmail(email) && isValidPassword(password) && isValidName(name)) {
    final repository = SecureStorageUserRepository();

    try {
      // Збереження користувача в репозиторії
      await repository.saveUser({
        'name': name,
        'email': email,
        'password': password,
      });

      // Перевірка, чи виджет все ще існує
      if (mounted) {
        // Показ повідомлення про успішну реєстрацію
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Обліковий запис створено для $email'),
            backgroundColor: Colors.green,
          ),
        );

        // Перехід на екран логіну
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<Widget>(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      // Перевірка, чи виджет все ще існує
      if (mounted) {
        // Показ повідомлення про помилку збереження
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Помилка: не вдалося зберегти дані'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } else {
    // Показ повідомлення про помилку валідації
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Перевірте правильність введених даних'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  // Валідація даних
  bool isValidEmail(String email) => email.contains('@') && email.contains('.');
  bool isValidPassword(String password) => password.length >= 6;
  bool isValidName(String name) => name.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Реєстрація'),
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
                    'Створіть новий обліковий запис',
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
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      'Зареєструватися',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<Widget>(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Вже є обліковий запис? Увійдіть',
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

// Клас для збереження даних користувача
class SecureStorageUserRepository {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUser(Map<String, String> user) async {
    await _storage.write(key: 'name', value: user['name']);
    await _storage.write(key: 'email', value: user['email']);
    await _storage.write(key: 'password', value: user['password']);
  }

  Future<Map<String, String>> getUser() async {
    final name = await _storage.read(key: 'name') ?? '';
    final email = await _storage.read(key: 'email') ?? '';
    final password = await _storage.read(key: 'password') ?? '';

    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
