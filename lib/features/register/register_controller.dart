import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_string.dart';
import 'package:getx_demo_app/constants/hive_boxes.dart';
import 'package:getx_demo_app/db/user_model_hive.dart';
import 'package:hive/hive.dart';

class RegisterController extends GetxController {
  late Box<UserModelHive> userBox;

  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    userBox = Hive.box<UserModelHive>(HiveBoxes.user);
  }

  String _hashPassword(String raw) =>
      sha256.convert(utf8.encode(raw)).toString();

  Future<bool> register({
    required String name,
    required String email,
    required String rawPassword,
    String? imagePath,
  }) async {
    if (isLoading.value) return false;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final emailLower = email.trim().toLowerCase();
      final exists = userBox.values.any((u) => u.email == emailLower);
      if (exists) {
        errorMessage.value = AppStrings.registerEmailInUse;
        return false;
      }

      final hashedPassword = _hashPassword(rawPassword);
      final user = UserModelHive(
        name: name,
        email: emailLower,
        password: hashedPassword,
        imagePath: imagePath,
      );

      await userBox.put(emailLower, user);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
