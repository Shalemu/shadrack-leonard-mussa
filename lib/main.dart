import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mauzoApp/presentation/Components/customer_controller.dart';
import 'package:mauzoApp/presentation/favorites_page/controller/favorites_controller.dart';
import 'package:mauzoApp/presentation/favorites_page/models/favorites_model.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/controller/home_vtwo_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_export.dart';
import 'package:http/http.dart'
    as http; // Import the http package for HTTP requests

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _registerControllers();
  }

  void _registerControllers() {
    final favoritesModel = FavoritesModel();
    final favoritesModelRx = Rx<FavoritesModel>(favoritesModel);

    Get.put<FavoritesController>(FavoritesController(favoritesModelRx));
    Get.put<HomeVtwoController>(HomeVtwoController(''));
    Get.put<CustomerController>(CustomerController());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> refreshToken() async {
    print(
        'Starting token refresh process...'); // Print at the start of the function

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token != null) {
      print('Current token found: $token'); // Print the current token

      try {
        // Make a request to your refresh endpoint
        final response = await http.post(
          Uri.parse(
              'https://mauzo360.com/login/refresh-token'), // Example endpoint
          headers: {
            'Content-Type': 'application/json',
            // 'Authorization': 'Bearer $token', // Uncomment if your API requires an authorization header
          },
          body: jsonEncode({'token': token}),
        );

        print(
            'Response status: ${response.statusCode}'); // Print the response status code

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          print(
              'Response data: $data'); // Print the response body for debugging

          if (data['status'] == 1) {
            // Store the new token
            await prefs.setString('user_token', data['new_token']);
            print(
                'Token refreshed successfully. New token: ${data['new_token']}');
          } else {
            print('Failed to refresh token: ${data['message']}');
          }
        } else {
          print(
              'Error refreshing token: ${response.statusCode} - ${response.reasonPhrase}');
        }
      } catch (e) {
        print('Exception during token refresh: $e');
        // Optionally, you can show an alert to the user about the error.
      }
    } else {
      print(
          'No token found in SharedPreferences.'); // Print if no token is found
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshToken(); // Call refresh token when app is resumed
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppLocalization(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      title: 'mauzoApp',
      initialBinding: InitialBindings(),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
