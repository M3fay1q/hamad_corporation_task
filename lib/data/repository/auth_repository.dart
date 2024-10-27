import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import '../model/user_model.dart';

class AuthRepository {
  final _storage = const FlutterSecureStorage();
  final Box<UserModel> userBox;

  AuthRepository(this.userBox);

  Future<void> registerUser(UserModel user) async {
    await userBox.put(user.username, user);
  }

  Future<bool> loginUser(String username, String password) async {
    final user = userBox.get(username);
    if (user != null && user.password == password) {
      await _storage.write(key: 'username', value: username);
      await _storage.write(key: 'password', value: password);
      return true;
    }
    return false;
  }

  Future<void> logoutUser() async {
    await _storage.deleteAll();
  }
}
