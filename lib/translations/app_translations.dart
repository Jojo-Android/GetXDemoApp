import 'package:get/get.dart';
import 'package:getx_demo_app/translations/th_TH.dart';

import 'en_US.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'th_TH': thTH,
  };
}
