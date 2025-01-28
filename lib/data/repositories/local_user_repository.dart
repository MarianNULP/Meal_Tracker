// lib/data/repositories/local_user_repository.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meal_tracker/data/repositories/user_repository.dart';

class LocalUserRepository implements UserRepository {
  static const String keyName = 'user_name';
  static const String keyEmail = 'user_email';
  static const String keyPassword = 'user_password';

  final FlutterSecureStorage _storage;

  LocalUserRepository({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    await _storage.write(key: keyName, value: name);
    await _storage.write(key: keyEmail, value: email);
    await _storage.write(key: keyPassword, value: password);
  }

  @override
  Future<Map<String, String>?> getUser() async {
    final name = await _storage.read(key: keyName);
    final email = await _storage.read(key: keyEmail);
    final password = await _storage.read(key: keyPassword);

    if (name == null || email == null || password == null) {
      return null; // Користувач не збережений
    }

    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  Future<void> updateUser({
    required String name,
    required String email,
    required String password,
  }) async {
    await _storage.write(key: keyName, value: name);
    await _storage.write(key: keyEmail, value: email);
    await _storage.write(key: keyPassword, value: password);
  }

  @override
  Future<void> deleteUser() async {
    await _storage.deleteAll();
  }
}
