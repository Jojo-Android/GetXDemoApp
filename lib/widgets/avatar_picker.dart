import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

class AvatarPicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onTap;

  const AvatarPicker({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imagePath != null &&
        imagePath!.isNotEmpty &&
        File(imagePath!).existsSync();
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: Dimensions.avatarLargeRadius,
              backgroundColor: colorScheme.secondaryContainer,
              backgroundImage: hasImage ? FileImage(File(imagePath!)) : null,
              child: !hasImage
                  ? Icon(Icons.account_circle, size: Dimensions.accountIconSize)
                  : null,
            ),
            if (onTap == null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                      Dimensions.avatarLargeRadius,
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: Dimensions.loaderStrokeWidth,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: Dimensions.spacing4,
              right: Dimensions.spacing4,
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingEditIcon),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  color: colorScheme.onPrimary,
                  size: Dimensions.editIconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
