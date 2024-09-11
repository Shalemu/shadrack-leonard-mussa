import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mauzoApp/colors/app_theme.dart';
import 'package:mauzoApp/core/utils/services/storage_service.dart';
import 'core/app_export.dart';
final ThemeData theme = ThemeData();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(StorageService());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppLocalization(),
      theme:  AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: Get.deviceLocale, 
      fallbackLocale: Locale('en', 'US'),
      title: 'mauzoApp',
      initialBinding: InitialBindings(),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
