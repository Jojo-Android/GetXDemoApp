import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_locals.dart';
import 'package:getx_demo_app/constants/app_string.dart';
import 'package:getx_demo_app/constants/hive_boxes.dart';
import 'package:getx_demo_app/routes/app_pages.dart';
import 'package:getx_demo_app/routes/app_routes.dart';
import 'package:getx_demo_app/theme/app_theme.dart';
import 'package:getx_demo_app/translations/app_translations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/session/auth_session.dart';
import 'db/product_model_hive.dart';
import 'db/user_controller.dart';
import 'db/user_model_hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelHiveAdapter());
  Hive.registerAdapter(ProductModelHiveAdapter());

  await Future.wait([
    Hive.openBox<UserModelHive>(HiveBoxes.user),
    Hive.openBox<ProductModelHive>(HiveBoxes.favoriteProducts),
  ]);

  final authBox = await Hive.openBox<String>(HiveBoxes.authBox);

  Get.put<AuthSession>(AuthSession(authBox), permanent: true);
  Get.put<UserController>(UserController(), permanent: true);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName.tr,
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: AppLocals.localeEn,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.shoppingAppTheme,
      initialRoute: AppRoutes.splashPath,
      getPages: AppPages.routes,
    );
  }
}
