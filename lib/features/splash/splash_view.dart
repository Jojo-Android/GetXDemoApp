import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_string.dart';

import '../../constants/dimensions.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Get.theme.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: Center(
        child: FadeTransition(
          opacity: controller.fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: AppStrings.appName.tr,
                child: Icon(
                  Icons.shopping_bag,
                  size: Dimensions.splashIconSize,
                  color: color.primary,
                ),
              ),
              SizedBox(height: Dimensions.splashSpacingSmall),
              Text(
                AppStrings.appName.tr,
                style: Get.theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.primary,
                ),
              ),
              SizedBox(height: Dimensions.splashSpacingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
