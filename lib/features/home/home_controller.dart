import 'package:collection/collection.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/api_service.dart';
import 'package:getx_demo_app/constants/app_string.dart';
import 'package:getx_demo_app/db/user_controller.dart';
import 'package:hive/hive.dart';

import '../../constants/app_durations.dart';
import '../../constants/hive_boxes.dart';
import '../../db/product_model_hive.dart';
import '../../model/product_model.dart';

class SnackBarEvent {
  final String message;
  final bool isError;

  SnackBarEvent(this.message, {this.isError = false});
}

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final products = <ProductModel>[].obs;
  final favoriteIds = <int>{}.obs;
  final loadingFavoriteIds = <int>{}.obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  // Event สำหรับแสดง Snackbar ใน UI
  final snackBarEvent = Rxn<SnackBarEvent>();

  late final AnimationController fadeInController;
  late final Box<ProductModelHive> favoritesBox;
  late final Stream<BoxEvent> _favoritesBoxStream;

  @override
  void onInit() {
    super.onInit();

    fadeInController = AnimationController(
      vsync: this,
      duration: AppDurations.animationMedium,
    );

    favoritesBox = Hive.box<ProductModelHive>(HiveBoxes.favoriteProducts);
    _favoritesBoxStream = favoritesBox.watch();
    _favoritesBoxStream.listen((event) {
      _loadFavoriteIds();
    });

    _loadAll();
  }

  @override
  void onClose() {
    fadeInController.dispose();
    super.onClose();
  }

  Future<void> _loadFavoriteIds() async {
    final user = Get.find<UserController>().currentUser.value;
    if (user == null) {
      favoriteIds.clear();
      return;
    }

    final allFavorites = favoritesBox.values.where(
      (fav) => fav.userEmail == user.email,
    );
    favoriteIds
      ..clear()
      ..addAll(allFavorites.map((p) => p.id));
  }

  Future<void> _loadAll() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetched = await fetchProducts();
      await _loadFavoriteIds();
      products.assignAll(fetched);
      fadeInController.forward();
    } catch (e) {
      errorMessage.value = e.toString();
      snackBarEvent.value = SnackBarEvent(
        AppStrings.failedToLoadProducts.tr,
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  final GetConnect _client = GetConnect();

  Future<List<ProductModel>> fetchProducts() async {
    final String url = ApiService.fakeStoreApi;
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = response.body;
      if (data is List) {
        return data
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(AppStrings.unknownError.tr);
      }
    } else {
      throw Exception(
        '${AppStrings.failedToLoadProducts.tr} ${response.statusCode}',
      );
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final user = Get.find<UserController>().currentUser.value;
    if (user == null) return;

    final id = product.id;
    if (loadingFavoriteIds.contains(id)) return;

    loadingFavoriteIds.add(id);

    try {
      final existingKey = favoritesBox.keys.firstWhereOrNull((key) {
        final fav = favoritesBox.get(key);
        return fav != null && fav.userEmail == user.email && fav.id == id;
      });

      if (existingKey != null) {
        await favoritesBox.delete(existingKey);
        snackBarEvent.value = SnackBarEvent(
          AppStrings.removeFromFavoritesTooltip.tr,
          isError: false,
        );
      } else {
        final fav = ProductModelHive.fromProductModel(product, user.email);
        await favoritesBox.add(fav);
        snackBarEvent.value = SnackBarEvent(
          AppStrings.favoriteToggleAdd.tr,
          isError: false,
        );
      }
    } catch (_) {
      snackBarEvent.value = SnackBarEvent(
        AppStrings.updateFavoritesFailed.tr,
        isError: true,
      );
    } finally {
      loadingFavoriteIds.remove(id);
    }
  }

  void retry() {
    _loadAll();
    fadeInController.reset();
  }
}
