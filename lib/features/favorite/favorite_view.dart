import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_string.dart';
import 'package:getx_demo_app/constants/dimensions.dart';

import '../../widgets/product_list_tile.dart';
import 'favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.favoritePageTitle.tr),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.favoriteEmptyMessageHorizontalPadding,
              ),
              child: Text(
                AppStrings.favoritePageEmptyMessage.tr,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadFavorites,
          color: colorScheme.primary,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: Dimensions.favoritePaddingVertical,
              horizontal: Dimensions.favoritePaddingHorizontal,
            ),
            itemCount: controller.favorites.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: Dimensions.favoriteListSeparatorHeight),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final product = controller.favorites[index];
              return ProductListTile(
                product: product.toProductModel(),
                isFavorite: true,
                isLoadingFavorite:
                    controller.removingProductId.value == product.id,
                onFavoriteToggle: (_) => controller.removeFavorite(product.id),
              );
            },
          ),
        );
      }),
    );
  }
}
