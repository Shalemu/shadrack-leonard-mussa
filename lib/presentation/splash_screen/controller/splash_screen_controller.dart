// splash_controller.dart
import 'package:get/get.dart';
import 'package:mauzoApp/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    print('SplashController: Checking login status...');
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    print('SplashController: Getting SharedPreferences instance...');
    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? token = prefs.getString('user_token');
    String username = prefs.getString('item_name') ?? "Default Name";
    String deviceKey = prefs.getString('device_key') ?? "Default Device Key";

    print('Login status: $isLoggedIn, Token: $token');

    if (isLoggedIn) {
      print('Navigating to HomeVtwoPage...');
      Get.offNamed(AppRoutes.homeVtwoPage, arguments: {
        'itemName': username,
        'token': token,
        'deviceKey': deviceKey,
      });
    } else {
      print('Navigating to Onboarding...');
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.offNamed(AppRoutes.onboarding001Screen);
      });
    }
  }
}
