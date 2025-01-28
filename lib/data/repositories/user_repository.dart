// data/repositories/user_repository.dart
abstract class UserRepository {
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  });
  Future<Map<String, String>?> getUser();
  Future<void> updateUser({
    required String name,
    required String email,
    required String password,
  });
  Future<void> deleteUser();
}
