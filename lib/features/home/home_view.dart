import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_durations.dart';
import 'package:getx_demo_app/constants/app_string.dart';
import 'package:getx_demo_app/constants/dimensions.dart';
import 'package:getx_demo_app/widgets/user_profile_app_bar.dart';

import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final theme = Get.theme;

    return Obx(() {
      final snack = controller.snackBarEvent.value;

      if (snack != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            snack.isError ? AppStrings.error.tr : AppStrings.success.tr,
            snack.message,
            backgroundColor: snack.isError
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
            snackPosition: SnackPosition.BOTTOM,
            duration: AppDurations.snackbarShort,
            colorText: Colors.white,
          );
          controller.snackBarEvent.value = null;
        });
      }

      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (controller.errorMessage.value.trim().isNotEmpty) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.pageHorizontalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: Dimensions.errorIconSize,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: Dimensions.spacingSmall),
                  Text(
                    controller.errorMessage.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimensions.spacingMedium),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: Text(AppStrings.retry.tr),
                    onPressed: controller.retry,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.elevatedButtonHorizontalPadding,
                        vertical: Dimensions.elevatedButtonVerticalPadding,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.elevatedButtonRadius,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
        appBar: const UserProfileAppBar(),
        body: FadeTransition(
          opacity: controller.fadeInController,
          child: ListView.builder(
            padding: const EdgeInsets.all(Dimensions.listPadding),
            itemCount: controller.products.length,
            itemBuilder: (_, index) {
              final product = controller.products[index];
              final isFav = controller.favoriteIds.contains(product.id);
              final isLoading = controller.loadingFavoriteIds.contains(
                product.id,
              );

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Dimensions.listCardBorderRadius,
                  ),
                ),
                margin: const EdgeInsets.only(
                  bottom: Dimensions.listCardMarginBottom,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(product.image),
                    radius: Dimensions.circleAvatarRadius,
                  ),
                  title: Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: isLoading
                      ? const SizedBox(
                          height: Dimensions.trailingLoadingIndicatorSize,
                          width: Dimensions.trailingLoadingIndicatorSize,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? theme.colorScheme.error : null,
                          ),
                          onPressed: () => controller.toggleFavorite(product),
                        ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
