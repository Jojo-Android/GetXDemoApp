import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants/app_string.dart';
import '../constants/dimensions.dart';
import '../db/user_controller.dart';

class UserProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onAvatarTap;

  const UserProfileAppBar({super.key, this.onAvatarTap});

  @override
  Size get preferredSize => const Size.fromHeight(Dimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final userController = Get.find<UserController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(Dimensions.borderRadiusLarge),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Dimensions.shadowOpacity),
              blurRadius: Dimensions.shadowBlur,
              offset: Dimensions.shadowOffset,
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.horizontalPadding,
              vertical: Dimensions.verticalPadding,
            ),
            child: Obx(() {
              final user = userController.currentUser.value;
              final imagePath = user?.imagePath;
              final hasImage =
                  imagePath != null &&
                  imagePath.isNotEmpty &&
                  File(imagePath).existsSync();

              return Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onAvatarTap,
                      child: Container(
                        width: Dimensions.avatarSize,
                        height: Dimensions.avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.secondaryContainer,
                        ),
                        child: ClipOval(
                          child: hasImage
                              ? Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.account_circle,
                                    size: Dimensions.iconSize,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: Dimensions.iconSize,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.welcome.tr,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: Dimensions.spacing4),
                        Text(
                          user?.name ?? AppStrings.user,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
