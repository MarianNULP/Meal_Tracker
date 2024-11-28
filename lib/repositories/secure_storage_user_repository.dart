import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meal_tracker/repositories/user_repository.dart';

class SecureStorageUserRepository implements UserRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> saveUser(Map<String, String> user) async {
    await _storage.write(key: 'name', value: user['name']);
    await _storage.write(key: 'email', value: user['email']);
    await _storage.write(key: 'password', value: user['password']);
  }

  @override
  Future<Map<String, String>?> getUser() async {
    final name = await _storage.read(key: 'name');
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');

    if (name != null && email != null && password != null) {
      return {'name': name, 'email': email, 'password': password};
    }
    return null;
  }

  @override
  Future<void> deleteUser() async {
    await _storage.delete(key: 'name');
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');
  }
}
