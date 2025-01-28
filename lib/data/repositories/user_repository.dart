// lib/data/repositories/user_repository.dart

abstract class UserRepository {
  /// Реєструє нового користувача (зберігає у локальне сховище).
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  });

  /// Повертає інформацію про користувача, якщо він зареєстрований.
  Future<Map<String, String>?> getUser();

  /// Оновити дані користувача.
  Future<void> updateUser({
    required String name,
    required String email,
    required String password,
  });

  /// Видалити дані користувача (наприклад, для "delete account" або логауту).
  Future<void> deleteUser();
}
