import 'package:get/get.dart';

import '../home/home_controller.dart';
import '../favorite/favorite_controller.dart';
import '../setting/setting_controller.dart';
import 'main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(FavoriteController(), permanent: true);
    Get.put(SettingController(), permanent: true);
  }
}

