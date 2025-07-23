import 'package:getx_demo_app/constants/hive_boxes.dart';
import 'package:hive/hive.dart';

class AuthSession {
  static const _keyUserEmail = HiveBoxes.currentUserEmail;

  final Box<String> _sessionBox;

  AuthSession(this._sessionBox);

  Future<void> saveUserEmail(String email) async {
    await _sessionBox.put(_keyUserEmail, email);
  }

  String? get currentUserEmail => _sessionBox.get(_keyUserEmail);

  bool get isLoggedIn => _sessionBox.containsKey(_keyUserEmail);

  Future<void> logout() async {
    await _sessionBox.delete(_keyUserEmail);
  }
}
