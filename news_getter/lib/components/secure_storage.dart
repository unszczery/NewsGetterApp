import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  final String _keyUserName = 'username';
  final String _keyPassword = 'password';

  Future setUserName(String userName) async {
    await storage.write(key: _keyUserName, value: userName);
  }

  Future setPassword(String password) async {
    await storage.write(key: _keyPassword, value: password);
  }

  Future<String?> getUserName() async {
    return await storage.read(key: _keyUserName);
  }

  Future<String?> getPassword() async {
    return await storage.read(key: _keyPassword);
  }
}
