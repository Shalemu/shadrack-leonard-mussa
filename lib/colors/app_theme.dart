import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mauzoApp/colors/app_colors.dart';

class AppTheme {
  final _getStorage = GetStorage();
  final storageKey = "isDarkMode";

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isSavedDarkMode() {
    bool isDarkMode =
        Get.theme.scaffoldBackgroundColor == AppColors.blackBackgroundColor;
    return _getStorage.read(storageKey) ?? isDarkMode;
  }

  void saveThemeMode(bool isDarkMode) {
    _getStorage.write(storageKey, isDarkMode);
  }

  void changeTheme() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeMode(!isSavedDarkMode());
    androidSystemNavigationBarColor();
  }

  void androidSystemNavigationBarColor() {
    if (GetPlatform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Get.theme.scaffoldBackgroundColor ==
                  AppColors.blackBackgroundColor
              ? AppColors.blackBackgroundColor
              : AppColors.whiteBackgroundColor,
          systemNavigationBarIconBrightness:
              Get.theme.scaffoldBackgroundColor ==
                      AppColors.blackBackgroundColor
                  ? Brightness.light
                  : Brightness.dark,
        ),
      );
    }
  }

  void androidSystemNavigationBarColorHomeFeed() {
    if (GetPlatform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Get.theme.scaffoldBackgroundColor !=
                  AppColors.blackBackgroundColor
              ? AppColors.blackBackgroundColor
              : AppColors.whiteBackgroundColor,
          systemNavigationBarIconBrightness:
              Get.theme.scaffoldBackgroundColor !=
                      AppColors.blackBackgroundColor
                  ? Brightness.light
                  : Brightness.dark,
        ),
      );
    }
  }

  static final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      surfaceTintColor: AppColors.whiteBackgroundColor,
    ),
    scaffoldBackgroundColor: AppColors.whiteBackgroundColor,
    cardTheme: CardTheme(
      surfaceTintColor: Get.theme.colorScheme.surface,
    ),
    colorScheme: AppTheme.lightScheme(),
    // textTheme: GoogleFonts.urbanistTextTheme(Typography.blackHelsinki),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      surfaceTintColor: AppColors.blackBackgroundColor,
    ),
    cardTheme: CardTheme(
      surfaceTintColor: Get.theme.colorScheme.surface,
    ),
    scaffoldBackgroundColor: AppColors.blackBackgroundColor,
    colorScheme: AppTheme.darkScheme(),
    iconTheme: const IconThemeData(
      color: AppColors.whiteBackgroundColor,
      opacity: 0.8,
      size: 25,
    ),
    // textTheme: GoogleFonts.urbanistTextTheme(Typography.whiteHelsinki),
    useMaterial3: true,
  );


  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278203717),
      surfaceTint: Color(4281754743),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280899434),
      onPrimaryContainer: Color(4293261055),
      secondary: Color(4287516416),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294944077),
      onSecondaryContainer: Color(4282786816),
      tertiary: Color(4282197834),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284565870),
      onTertiaryContainer: Color(4294832127),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294768888),
      onSurface: Color(4280032027),
      onSurfaceVariant: Color(4282468428),
      outline: Color(4285626492),
      outlineVariant: Color(4290889676),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413680),
      inversePrimary: Color(4288663011),
      primaryFixed: Color(4290570751),
      onPrimaryFixed: Color(4278198057),
      primaryFixedDim: Color(4288663011),
      onPrimaryFixedVariant: Color(4279979102),
      secondaryFixed: Color(4294958273),
      onSecondaryFixed: Color(4281210368),
      secondaryFixedDim: Color(4294948983),
      onSecondaryFixedVariant: Color(4285282816),
      tertiaryFixed: Color(4294236671),
      onTertiaryFixed: Color(4280750644),
      tertiaryFixedDim: Color(4292525288),
      onTertiaryFixedVariant: Color(4283776610),
      surfaceDim: Color(4292729305),
      surfaceBright: Color(4294768888),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294374386),
      surfaceContainer: Color(4294045164),
      surfaceContainerHigh: Color(4293650407),
      surfaceContainerHighest: Color(4293255905),
    );
  }

  
  

   static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4288663011),
      surfaceTint: Color(4288663011),
      onPrimary: Color(4278203717),
      primaryContainer: Color(4278599248),
      onPrimaryContainer: Color(4288926183),
      secondary: Color(4294953371),
      onSecondary: Color(4283180800),
      secondaryContainer: Color(4293956920),
      onSecondaryContainer: Color(4281538816),
      tertiary: Color(4292525288),
      onTertiary: Color(4282198090),
      tertiaryContainer: Color(4282921301),
      onTertiaryContainer: Color(4292919789),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279505683),
      onSurface: Color(4293255905),
      onSurfaceVariant: Color(4290889676),
      outline: Color(4287337110),
      outlineVariant: Color(4282468428),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255905),
      inversePrimary: Color(4281754743),
      primaryFixed: Color(4290570751),
      onPrimaryFixed: Color(4278198057),
      primaryFixedDim: Color(4288663011),
      onPrimaryFixedVariant: Color(4279979102),
      secondaryFixed: Color(4294958273),
      onSecondaryFixed: Color(4281210368),
      secondaryFixedDim: Color(4294948983),
      onSecondaryFixedVariant: Color(4285282816),
      tertiaryFixed: Color(4294236671),
      onTertiaryFixed: Color(4280750644),
      tertiaryFixedDim: Color(4292525288),
      onTertiaryFixedVariant: Color(4283776610),
      surfaceDim: Color(4279505683),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4280032027),
      surfaceContainer: Color(4280295199),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281676852),
    );
  }

 
  

}