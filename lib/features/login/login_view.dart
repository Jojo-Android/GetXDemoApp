import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../constants/app_string.dart';
import '../../constants/dimensions.dart';
import '../../constants/form_field_names.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding),
          child: FormBuilder(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: Dimensions.iconSizeLarge,
                  color: color.primary,
                ),
                const SizedBox(height: Dimensions.spacingMediumLarge),
                Text(
                  AppStrings.loginPageTitle.tr,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.primary,
                  ),
                ),
                const SizedBox(height: Dimensions.spacingLarge),

                // Email
                FormBuilderTextField(
                  name: FormFieldNames.email,
                  decoration: InputDecoration(
                    labelText: AppStrings.registerEmailLabel.tr,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: color.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.borderRadius),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.borderRadius),
                      borderSide: BorderSide(color: color.primary),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: AppStrings.registerFieldRequiredEmail.tr,
                    ),
                    FormBuilderValidators.email(
                      errorText: AppStrings.loginInvalidEmail.tr,
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.spacingMedium),

                // Password
                Obx(
                      () => FormBuilderTextField(
                    name: FormFieldNames.password,
                    obscureText: controller.obscurePass.value,
                    decoration: InputDecoration(
                      labelText: AppStrings.registerPasswordLabel.tr,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: color.primary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePass.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: color.primary,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.borderRadius),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.borderRadius),
                        borderSide: BorderSide(color: color.primary),
                      ),
                    ),
                    validator: FormBuilderValidators.required(
                      errorText: AppStrings.registerFieldRequiredPassword.tr,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.spacingLarge),

                // Login Button
                Obx(
                      () => SizedBox(
                    width: double.infinity,
                    height: Dimensions.buttonHeight,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.borderRadius),
                        ),
                        textStyle: TextStyle(
                          fontSize: Dimensions.fontSizeButton,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: color.onPrimary)
                          : Text(AppStrings.loginButton.tr),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.spacingSmall),

                TextButton(
                  onPressed: controller.goToRegister,
                  child: Text(
                    AppStrings.loginRegisterLink.tr,
                    style: TextStyle(
                      color: color.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
