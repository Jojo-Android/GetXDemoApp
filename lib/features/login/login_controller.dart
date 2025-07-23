import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_durations.dart';
import 'package:getx_demo_app/constants/form_field_names.dart';

import '../../../constants/app_string.dart';
import '../../../routes/app_routes.dart';
import '../../core/session/auth_session.dart';
import '../../db/user_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  final obscurePass = true.obs;
  final isLoading = false.obs;

  late final AuthSession _authSession;
  late final UserController _userController;

  @override
  void onInit() {
    super.onInit();
    _authSession = Get.find<AuthSession>();
    _userController = Get.find<UserController>();
  }

  void togglePasswordVisibility() => obscurePass.toggle();

  String _normalizeEmail(dynamic email) {
    return email?.toString().trim().toLowerCase() ?? '';
  }

  void _showLoginError() {
    Get.snackbar(
      AppStrings.loginFailed.tr,
      AppStrings.invalidEmailOrPassword.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: AppDurations.snackbarShort,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }

  void _showGeneralError(String e) {
    Get.snackbar(
      AppStrings.error.tr,
      e,
      snackPosition: SnackPosition.BOTTOM,
      duration: AppDurations.snackbarShort,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }

  Future<void> login() async {
    if (formKey.currentState == null) return;

    final isValid = formKey.currentState!.saveAndValidate();
    if (!isValid) return;

    isLoading.value = true;

    try {
      final values = formKey.currentState!.value;
      final email = _normalizeEmail(values[FormFieldNames.email]);
      final password = values[FormFieldNames.password]?.toString() ?? '';

      final user = _userController.findUserByCredential(email, password);

      if (user == null) {
        _showLoginError();
        return;
      }

      await _authSession.saveUserEmail(user.email);
      _userController.currentUser.value = user;

      Get.offAllNamed(AppRoutes.mainPath);
    } catch (e) {
      _showGeneralError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() => Get.toNamed(AppRoutes.registerPath);
}
