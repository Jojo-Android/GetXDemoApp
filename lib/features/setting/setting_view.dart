import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_locals.dart';
import 'package:getx_demo_app/features/setting/setting_controller.dart';

import '../../constants/app_string.dart';
import '../../constants/dimensions.dart';
import '../../widgets/avatar_picker.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Obx(() {
      final user = controller.user.value;

      if (controller.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          ),
        );
      }

      if (user == null) {
        return Scaffold(
          body: Center(
            child: Text(
              AppStrings.userNotFound.tr,
              style: theme.textTheme.titleMedium,
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: theme.colorScheme.primary,
              expandedHeight: Dimensions.sliverAppBarExpandedHeight,
              pinned: true,
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(Dimensions.sliverAppBarBorderRadius),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  user.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(
                          Dimensions.textShadowOpacity,
                        ),
                        blurRadius: Dimensions.textShadowBlur,
                        offset: Dimensions.textShadowOffset,
                      ),
                    ],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: theme.colorScheme.primary),
                    Align(
                      alignment: Alignment.center,
                      child: AvatarPicker(
                        imagePath: user.imagePath,
                        onTap: controller.isPickingImage.value
                            ? null
                            : () => controller.pickImage(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.sliverPaddingHorizontal,
                vertical: Dimensions.sliverPaddingVertical,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildListTile(
                    icon: Icons.language,
                    iconColor: theme.colorScheme.primary,
                    title: AppStrings.changeLanguage.tr,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showChangeLanguageDialog(),
                    tileColor: theme.colorScheme.primaryContainer.withOpacity(
                      Dimensions.tileColorOpacity,
                    ),
                  ),
                  const SizedBox(height: Dimensions.listTileSpacing),
                  _buildListTile(
                    icon: Icons.logout,
                    iconColor: theme.colorScheme.error,
                    title: AppStrings.logout.tr,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: controller.logout,
                    tileColor: theme.colorScheme.errorContainer.withOpacity(
                      Dimensions.tileColorOpacity,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }

  void showChangeLanguageDialog() {
    final controller = Get.find<SettingController>();
    final currentLocale = Get.locale ?? AppLocals.localeEn;

    final selectedLocale = currentLocale.obs;

    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.changeLanguageTitle.tr),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Locale>(
                title: Text(AppStrings.languageEnglish.tr),
                value: AppLocals.localeEn,
                groupValue: selectedLocale.value,
                onChanged: (value) {
                  if (value != null) selectedLocale.value = value;
                },
              ),
              RadioListTile<Locale>(
                title: Text(AppStrings.languageThai.tr),
                value: AppLocals.localTH,
                groupValue: selectedLocale.value,
                onChanged: (value) {
                  if (value != null) selectedLocale.value = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.changeLanguageDialogClose.tr),
          ),
          TextButton(
            onPressed: () {
              if (selectedLocale.value != currentLocale) {
                controller.changeLanguage(selectedLocale.value);
              }
              Get.back();
            },
            child: Text(AppStrings.confirm.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
    Color? tileColor,
  }) {
    final theme = Get.theme;

    return Material(
      color: tileColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(Dimensions.listTileBorderRadius),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.listTileBorderRadius),
        ),
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: theme.textTheme.titleMedium),
        trailing: trailing,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimensions.listTileContentPaddingHorizontal,
          vertical: Dimensions.listTileContentPaddingVertical,
        ),
      ),
    );
  }
}
