import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/dimensions.dart';

class AppTheme {
  static final shoppingAppTheme = ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      background: AppColors.background,
      onBackground: AppColors.onBackground,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
      onError: AppColors.onError,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: Dimensions.textSizeTitleLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackground,
        letterSpacing: Dimensions.letterSpacingSmall,
      ),
      bodyMedium: TextStyle(
        fontSize: Dimensions.textSizeBodyMedium,
        color: AppColors.grey616161,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: Dimensions.letterSpacingMedium,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey9E9E9E,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      elevation: Dimensions.bottomNavElevation,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.borderRadiusButton),
        ),
        elevation: Dimensions.buttonElevation,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Dimensions.buttonFontSize,
          letterSpacing: Dimensions.letterSpacingMedium,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: Dimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.borderRadiusCard),
      ),
      shadowColor: AppColors.black.withOpacity(Dimensions.tileColorOpacity),
      margin: const EdgeInsets.symmetric(
        vertical: Dimensions.cardMarginVertical,
        horizontal: Dimensions.cardMarginHorizontal,
      ),
    ),
  );
}
