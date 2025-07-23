import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_durations.dart';
import 'package:getx_demo_app/constants/app_string.dart';
import 'package:getx_demo_app/constants/dimensions.dart';

import '../favorite/favorite_view.dart';
import '../home/home_view.dart';
import '../setting/setting_view.dart';
import 'main_controller.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final MainController controller = Get.find<MainController>();

  final pages = [HomeView(), FavoriteView(), SettingView()];

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(
        () => AnimatedSwitcher(
          duration: AppDurations.animationFast,
          child: pages[controller.currentIndex.value],
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      bottomNavigationBar: Obx(
        () => ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.bottomNavBarTopRadius),
            topRight: Radius.circular(Dimensions.bottomNavBarTopRadius),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
            selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor:
                theme.bottomNavigationBarTheme.unselectedItemColor,
            showUnselectedLabels:
                theme.bottomNavigationBarTheme.showUnselectedLabels ?? true,
            type:
                theme.bottomNavigationBarTheme.type ??
                BottomNavigationBarType.fixed,
            selectedLabelStyle:
                theme.bottomNavigationBarTheme.selectedLabelStyle,
            unselectedLabelStyle:
                theme.bottomNavigationBarTheme.unselectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: AppStrings.homePageTitle.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: AppStrings.favoritePageTitle.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: AppStrings.settingsPageTitle.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
