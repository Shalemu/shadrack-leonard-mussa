import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/presentation/login_empty_state_screen/models/login_empty_state_model.dart';

class LoginEmptyStateController extends GetxController {
  TextEditingController inputController = TextEditingController();
  TextEditingController inputOneController = TextEditingController();

  // Observables for UI and data
  Rx<LoginEmptyStateModel> loginEmptyStateModelObj = LoginEmptyStateModel().obs;
  Rx<bool> isShowPassword = false.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // Dispose of text controllers when no longer needed
    inputController.dispose();
    inputOneController.dispose();
  }

  // Function triggered when login button is pressed
  void onTapButton(BuildContext context) async {
  print('Login button pressed'); // Debug line
  if (Form.of(context).validate()) {
    final username = inputController.text;
    final password = inputOneController.text;
    
    print('Username: $username, Password: $password'); // Debug line

    final url = Uri.parse('https://127.0.0.1/mauzo360/app-auth');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('Response status: ${response.statusCode}'); // Debug line
      print('Response body: ${response.body}'); // Debug line

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Login successful: $data'); // Debug line
        Get.offNamedUntil(AppRoutes.homeVtwoContainerScreen, (route) => false);
      } else {
        Get.snackbar('Login Failed', 'Please check your credentials and try again.');
      }
    } catch (error) {
      print('Error: $error'); // Debug line
      Get.snackbar('Error', 'An error occurred during login.');
    }
  } else {
    Get.snackbar('Validation Error', 'Please enter valid credentials.');
  }
}

}
