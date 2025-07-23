import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_constants.dart';
import 'package:getx_demo_app/features/main/main_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../db/user_controller.dart';
import '../../../db/user_model_hive.dart';
import '../../../routes/app_routes.dart';
import '../../constants/app_string.dart';

class SettingController extends GetxController {
  final user = Rxn<UserModelHive>();
  final isLoading = false.obs;
  final isPickingImage = false.obs;

  late final UserController _userController;

  @override
  void onInit() {
    super.onInit();
    _userController = Get.find<UserController>();
    _loadUser();

    ever<UserModelHive?>(_userController.currentUser, (updatedUser) {
      user.value = updatedUser;
    });
  }

  void _loadUser() {
    isLoading.value = true;
    user.value = _userController.currentUser.value;
    isLoading.value = false;
  }

  Future<void> pickImage() async {
    if (isPickingImage.value || user.value == null) return;

    isPickingImage.value = true;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: AppConstants.defaultImageQuality,
      );

      if (picked == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final newPath = path.join(
        appDir.path,
        '${DateTime.now().millisecondsSinceEpoch}${path.extension(picked.path)}',
      );

      final saved = await File(picked.path).copy(newPath);

      final current = user.value!;
      final updated = current.copyWith(imagePath: saved.path);

      await _userController.updateUser(updated);
    } catch (e) {
      Get.snackbar(AppStrings.error.tr, AppStrings.registerPickImageFailed.tr);
    } finally {
      isPickingImage.value = false;
    }
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(AppStrings.logoutConfirmTitle.tr),
        content: Text(AppStrings.logoutConfirmContent.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(AppStrings.cancel.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              AppStrings.logout.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed != true) return;

    await _userController.logout();
    final bottomNavController = Get.find<MainController>();
    bottomNavController.changeIndex(0);
    Get.offAllNamed(AppRoutes.loginPath);
  }

  void changeLanguage(Locale locale) {
    Get.updateLocale(locale);
  }
}
