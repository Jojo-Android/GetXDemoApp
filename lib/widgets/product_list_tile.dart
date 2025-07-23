import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo_app/constants/app_durations.dart';
import 'package:getx_demo_app/constants/app_string.dart';
import 'package:getx_demo_app/constants/dimensions.dart';

import '../constants/app_keys.dart';
import '../model/product_model.dart';

typedef FavoriteToggleCallback = Future<void> Function(ProductModel product);

class ProductListTile extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite;
  final bool isLoadingFavorite;
  final FavoriteToggleCallback onFavoriteToggle;

  const ProductListTile({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.isLoadingFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final colorScheme = theme.colorScheme;

    final tooltipText = isFavorite
        ? AppStrings.removeFromFavoritesTooltip.tr
        : AppStrings.favoriteToggleAdd.tr;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.borderRadiusMedium),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.spacing4,
        vertical: Dimensions.spacing4,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        splashColor: colorScheme.primary,
        highlightColor: colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingProductTile,
            vertical: Dimensions.spacing10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  Dimensions.borderRadiusSmall,
                ),
                child: Image.network(
                  product.image,
                  width: Dimensions.productImageSize,
                  height: Dimensions.productImageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.broken_image,
                    size: Dimensions.productImageErrorIconSize,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimensions.spacing4),
                    Text(
                      product.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.spacing12),
              Tooltip(
                message: tooltipText,
                child: AnimatedSwitcher(
                  duration: AppDurations.animationMedium,
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: isLoadingFavorite
                      ? SizedBox(
                          key: const ValueKey(AppKeys.loading),
                          width: Dimensions.loaderSize,
                          height: Dimensions.loaderSize,
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        )
                      : IconButton(
                          key: ValueKey(isFavorite ? AppKeys.favorite: AppKeys.notFavorite),
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: isFavorite
                                ? colorScheme.error
                                : colorScheme.onSurface,
                            size: Dimensions.favoriteIconSize,
                          ),
                          onPressed: isLoadingFavorite
                              ? null
                              : () async {
                                  await onFavoriteToggle(product);
                                },
                          splashRadius: Dimensions.favoriteButtonRadius,
                          tooltip: tooltipText,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
