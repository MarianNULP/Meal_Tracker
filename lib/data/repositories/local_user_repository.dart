// data/repositories/local_user_repository.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'user_repository.dart';

class LocalUserRepository implements UserRepository {
  static const _keyName = 'user_name';
  static const _keyEmail = 'user_email';
  static const _keyPassword = 'user_password';

  final FlutterSecureStorage _storage;

  LocalUserRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _keyName, value: name);
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyPassword, value: password);
  }

  @override
  Future<Map<String, String>?> getUser() async {
    final name = await _storage.read(key: _keyName);
    final email = await _storage.read(key: _keyEmail);
    final pass = await _storage.read(key: _keyPassword);

    if (name == null || email == null || pass == null) {
      return null;
    }
    return {
      'name': name,
      'email': email,
      'password': pass,
    };
  }

  @override
  Future<void> updateUser({
    required String name,
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _keyName, value: name);
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyPassword, value: password);
  }

  @override
  Future<void> deleteUser() async {
    await _storage.deleteAll();
  }
}
