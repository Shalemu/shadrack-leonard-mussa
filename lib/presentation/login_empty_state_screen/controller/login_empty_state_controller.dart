import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/presentation/login_empty_state_screen/models/login_empty_state_model.dart';
import 'package:flutter/material.dart';

class LoginEmptyStateController extends GetxController {
  TextEditingController inputController = TextEditingController();

 

  Rx<LoginEmptyStateModel> loginEmptyStateModelObj = LoginEmptyStateModel().obs;

  Rx<bool> isShowPassword = false.obs; 
  TextEditingController inputOneController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    inputController.dispose();
    inputOneController.dispose();
  }
}

