import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUserRepository implements UserRepository {
  @override
  Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.toString()); // Можна використати jsonEncode
  }

  @override
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      // Використовуйте jsonDecode для перетворення назад у Map
    }
    return null;
  }

  @override
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}


abstract class UserRepository {
  Future<void> saveUser(Map<String, dynamic> user);
  Future<Map<String, dynamic>?> getUser();
  Future<void> deleteUser();
}

