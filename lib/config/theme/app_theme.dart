import 'package:flutter/material.dart';
import 'package:portal_gun/lib.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }

  // TODO(Jose): dark theme
  // static ThemeData get dark {
  //   final colorScheme = ColorScheme.fromSeed(
  //     seedColor: AppColors.primary,
  //     brightness: Brightness.dark,
  //   );

  //   return ThemeData(useMaterial3: true, colorScheme: colorScheme);
  // }
}
