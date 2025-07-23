import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_string.dart';
import 'package:getx_demo_app/constants/dimensions.dart';
import 'package:getx_demo_app/constants/form_field_names.dart';
import 'package:getx_demo_app/features/register/register_controller.dart';
import 'package:getx_demo_app/widgets/avatar_picker.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  final RxBool _isFormFilled = false.obs;
  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirm = true.obs;
  final RxnString _imagePath = RxnString();

  final RegisterController controller = Get.find<RegisterController>();

  void _checkFormFilled() {
    final form = _formKey.currentState;
    if (form == null) return;

    form.save();
    final values = form.value;
    final requiredFields = [
      FormFieldNames.name,
      FormFieldNames.email,
      FormFieldNames.password,
      FormFieldNames.confirmPassword,
    ];

    _isFormFilled.value = requiredFields.every((key) {
      final val = values[key];
      return val != null && val.toString().trim().isNotEmpty;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _imagePath.value = picked.path;
    }
  }

  Future<void> _register() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    final values = form.value;
    final name = values[FormFieldNames.name].toString().trim();
    final email = values[FormFieldNames.email].toString().trim();
    final password = values[FormFieldNames.password].toString().trim();

    final success = await controller.register(
      name: name,
      email: email,
      rawPassword: password,
      imagePath: _imagePath.value,
    );

    if (success) {
      Get.back();
      Get.snackbar(
        AppStrings.success.tr,
        AppStrings.registerSuccess.tr,
        backgroundColor: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
      );
      form.reset();
      _imagePath.value = null;
      _isFormFilled.value = false;
    } else {
      Get.snackbar(
        AppStrings.error.tr,
        controller.errorMessage.value ?? AppStrings.unknownError.tr,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
    required Color iconColor,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: iconColor, size: Dimensions.inputIconSize),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.borderRadius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.registerPageTitle.tr)),
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingAll),
          child: FormBuilder(
            key: _formKey,
            onChanged: _checkFormFilled,
            child: ListView(
              children: [
                Center(
                  child: Obx(
                    () => AvatarPicker(
                      imagePath: _imagePath.value,
                      onTap: _pickImage,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.avatarPickerSpacing),
                FormBuilderTextField(
                  name: FormFieldNames.name,
                  decoration: _inputDecoration(
                    label: AppStrings.registerNameLabel.tr,
                    icon: Icons.person,
                    iconColor: colorScheme.primary,
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: AppStrings.registerFieldRequiredName.tr,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: Dimensions.fieldSpacing),
                FormBuilderTextField(
                  name: FormFieldNames.email,
                  decoration: _inputDecoration(
                    label: AppStrings.registerEmailLabel.tr,
                    icon: Icons.email,
                    iconColor: colorScheme.primary,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: AppStrings.registerFieldRequiredEmail.tr,
                    ),
                    FormBuilderValidators.email(
                      errorText: AppStrings.registerFormInvalidEmail.tr,
                    ),
                  ]),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: Dimensions.fieldSpacing),
                Obx(() {
                  return FormBuilderTextField(
                    name: FormFieldNames.password,
                    obscureText: _obscurePassword.value,
                    decoration: _inputDecoration(
                      label: AppStrings.registerPasswordLabel.tr,
                      icon: Icons.lock,
                      iconColor: colorScheme.primary,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            _obscurePassword.value = !_obscurePassword.value,
                        iconSize: Dimensions.suffixIconButtonSize,
                        padding: EdgeInsets.zero,
                        splashRadius: Dimensions.suffixIconSplashRadius,
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: AppStrings.registerFieldRequiredPassword.tr,
                      ),
                      FormBuilderValidators.minLength(
                        6,
                        errorText: AppStrings.registerPasswordMinLength.tr,
                      ),
                    ]),
                    textInputAction: TextInputAction.next,
                  );
                }),
                const SizedBox(height: Dimensions.fieldSpacing),
                Obx(() {
                  return FormBuilderTextField(
                    name: FormFieldNames.confirmPassword,
                    obscureText: _obscureConfirm.value,
                    decoration: _inputDecoration(
                      label: AppStrings.registerConfirmPasswordLabel.tr,
                      icon: Icons.lock,
                      iconColor: colorScheme.primary,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            _obscureConfirm.value = !_obscureConfirm.value,
                        iconSize: Dimensions.suffixIconButtonSize,
                        padding: EdgeInsets.zero,
                        splashRadius: Dimensions.suffixIconSplashRadius,
                      ),
                    ),
                    validator: (value) {
                      final password =
                          _formKey
                              .currentState
                              ?.fields[FormFieldNames.password]
                              ?.value
                              ?.toString()
                              .trim() ??
                          '';
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.registerConfirmPasswordEmpty.tr;
                      }
                      if (value.trim() != password) {
                        return AppStrings.registerConfirmPasswordMismatch.tr;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  );
                }),
                const SizedBox(height: Dimensions.loaderSize),
                Obx(() {
                  final isEnabled =
                      _isFormFilled.value && !controller.isLoading.value;

                  return SizedBox(
                    height: Dimensions.buttonHeight,
                    child: ElevatedButton(
                      onPressed: isEnabled ? () => _register() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEnabled
                            ? null
                            : Colors.grey.shade400,
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: Dimensions.buttonProgressSize,
                              height: Dimensions.buttonProgressSize,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth:
                                    Dimensions.circularProgressStrokeWidth,
                              ),
                            )
                          : Text(
                              AppStrings.registerButton.tr,
                              style: TextStyle(
                                color: isEnabled ? Colors.white : null,
                              ),
                            ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
