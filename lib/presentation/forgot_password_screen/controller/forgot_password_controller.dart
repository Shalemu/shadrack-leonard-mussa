import 'package:mauzoApp/core/app_export.dart';import 'package:mauzoApp/presentation/forgot_password_screen/models/forgot_password_model.dart';import 'package:flutter/material.dart';class ForgotPasswordController extends GetxController {TextEditingController inputController = TextEditingController();

Rx<ForgotPasswordModel> forgotPasswordModelObj = ForgotPasswordModel().obs;

@override void onReady() { super.onReady(); } 
@override void onClose() { super.onClose(); inputController.dispose(); } 
 }
