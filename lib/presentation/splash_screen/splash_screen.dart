import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/presentation/splash_screen/controller/splash_screen_controller.dart';
import 'package:flutter/material.dart';

class SplashScreen extends GetWidget<SplashController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
        child: Scaffold(
            backgroundColor: ColorConstant.primary,
            body: Center(
              child: Text(Constants.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Noto Sans JP',
                fontSize: getFontSize(40),
                color: Colors.white,
                
                fontWeight: FontWeight.w700
              ),
              ),
            )));
  }



}
