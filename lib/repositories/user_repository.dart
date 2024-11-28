abstract class UserRepository {
  Future<void> saveUser(Map<String, String> user);
  Future<Map<String, String>?> getUser();
  Future<void> deleteUser();
}