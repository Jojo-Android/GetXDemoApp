import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_durations.dart';
import 'package:hive/hive.dart';

import '../../constants/app_string.dart';
import '../../constants/hive_boxes.dart';
import '../../db/product_model_hive.dart';
import '../../db/user_controller.dart';

class FavoriteController extends GetxController {
  final favorites = <ProductModelHive>[].obs;
  final isLoading = true.obs;
  final removingProductId = RxnInt();

  final _userController = Get.find<UserController>();
  late final Box<ProductModelHive> _favoriteBox;

  late final Stream<BoxEvent> _favoritesBoxStream;

  @override
  void onInit() {
    super.onInit();

    _favoriteBox = Hive.box<ProductModelHive>(HiveBoxes.favoriteProducts);
    _favoritesBoxStream = _favoriteBox.watch();

    _favoritesBoxStream.listen((event) {
      loadFavorites();
    });

    loadFavorites();
  }

  Future<void> loadFavorites() async {
    isLoading.value = true;

    final user = _userController.currentUser.value;
    if (user == null) {
      favorites.clear();
      isLoading.value = false;
      return;
    }

    final userFavorites = _favoriteBox.values
        .where((item) => item.userEmail == user.email)
        .toList();

    favorites.assignAll(userFavorites);
    isLoading.value = false;
  }

  Future<void> removeFavorite(int productId) async {
    if (removingProductId.value != null) return;

    removingProductId.value = productId;

    final user = _userController.currentUser.value;
    final targetKey = _favoriteBox.keys.firstWhereOrNull((key) {
      final item = _favoriteBox.get(key);
      return item?.userEmail == user?.email && item?.id == productId;
    });

    if (targetKey != null) {
      await _favoriteBox.delete(targetKey);
    }

    removingProductId.value = null;

    Get.snackbar(
      AppStrings.removeFromFavoritesTooltip.tr,
      AppStrings.removeFromFavoritesTooltip.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: AppDurations.snackbarShort,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }
}
