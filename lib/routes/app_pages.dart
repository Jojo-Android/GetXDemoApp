import 'package:get/get.dart';
import 'package:getx_demo_app/features/main/main_bindinding.dart';
import 'package:getx_demo_app/features/main/main_view.dart';
import 'package:getx_demo_app/features/register/register_binding.dart';
import 'package:getx_demo_app/features/register/register_view.dart';

import '../features/login/login_binding.dart';
import '../features/login/login_view.dart';
import '../features/splash/splash_binding.dart';
import '../features/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splashPath,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.loginPath,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.mainPath,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.registerPath,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
  ];
}
