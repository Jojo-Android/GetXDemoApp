import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_durations.dart';
import 'package:getx_demo_app/core/session/auth_session.dart';
import 'package:getx_demo_app/routes/app_routes.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController fadeController;
  late final Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();

    fadeController = AnimationController(
      vsync: this,
      duration: AppDurations.animationSlow,
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(fadeController);
    fadeController.forward();

    _initApp();
  }

  Future<void> _initApp() async {
    final minSplashTime = Future.delayed(AppDurations.animationSlow);

    final authSession = Get.find<AuthSession>();

    await minSplashTime;

    if (authSession.isLoggedIn) {
      Get.offNamed(AppRoutes.mainPath);
    } else {
      Get.offNamed(AppRoutes.loginPath);
    }
  }

  @override
  void onClose() {
    fadeController.dispose();
    super.onClose();
  }
}
