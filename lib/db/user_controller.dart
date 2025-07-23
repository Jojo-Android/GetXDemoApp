import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../constants/hive_boxes.dart';
import '../core/session/auth_session.dart';
import 'user_model_hive.dart';

class UserController extends GetxController {
  final currentUser = Rxn<UserModelHive>();
  final isLoading = false.obs;

  late final AuthSession _authSession;
  late final Box<UserModelHive> _userBox;

  @override
  void onInit() {
    super.onInit();
    _authSession = Get.find<AuthSession>();
    _userBox = Hive.box<UserModelHive>(HiveBoxes.user);
    _loadUser();
    _userBox.watch().listen(_onUserBoxChanged);
  }

  void _onUserBoxChanged(BoxEvent event) {
    if (event.value is! UserModelHive) return;

    final changedUser = event.value as UserModelHive;
    final currentEmail = _authSession.currentUserEmail;

    if (changedUser.email == currentEmail) {
      currentUser.value = changedUser;
    }
  }

  Future<void> _loadUser() async {
    isLoading.value = true;
    try {
      final email = _authSession.currentUserEmail;
      if (email != null) {
        final user = _userBox.values.firstWhereOrNull((u) => u.email == email);
        currentUser.value = user;
      } else {
        currentUser.value = null;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(UserModelHive updatedUser) async {
    final key = _userBox.keys.firstWhereOrNull(
          (k) => _userBox.get(k)?.email == updatedUser.email,
    );

    if (key != null) {
      await _userBox.put(key, updatedUser);
      currentUser.value = updatedUser;
    }
  }

  /// Hash password with SHA-256
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// Used for login: find user with matching email and password
  UserModelHive? findUserByCredential(String email, String password) {
    final hashed = _hashPassword(password);
    return _userBox.values.firstWhereOrNull(
          (user) => user.email == email && user.password == hashed,
    );
  }

  Future<void> logout() async {
    await _authSession.logout();
    currentUser.value = null;
  }
}
