import '../../widgets/spacing.dart';
import 'controller/onboarding_001_controller.dart';
import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class Onboarding001Screen extends GetWidget<Onboarding001Controller> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   VerticalSpace(height: 30),
                  Padding(
                      padding: getPadding(left: 25, top: 25, right: 25),
                      child: Text("lbl_skip".tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: AppStyle.txtNotoSansJPMedium14)),
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          height: getVerticalSize(361.00),
                          width: getHorizontalSize(321.00),
                          margin: getMargin(left: 25, top: 52, right: 25),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                  padding: getPadding(bottom: 10),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          getHorizontalSize(20.00)),
                                      child: CommonImageView(
                                          imagePath:
                                              ImageConstant.imgRectangle22398,
                                          height: getVerticalSize(336.00),
                                          width: getHorizontalSize(321.00),
                                          fit: BoxFit.cover)))))),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: getPadding(left: 25, top: 66, right: 25),
                          child: Text("msg_best_booking_app".tr,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: AppStyle.txtPlusJakartaSansBold24.copyWith(
                                  letterSpacing: 0.12, height: 1.29)))),
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          width: getHorizontalSize(260.00),
                          margin: getMargin(left: 25, top: 21, right: 25),
                          child: Text("msg_explore_the_best".tr,
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: AppStyle.txtPlusJakartaSansSemiBold14
                                  .copyWith(
                                      letterSpacing: 0.07, height: 1.57)))),
                  CustomButton(
                      width: 324,
                      text: "lbl_get_started".tr.toUpperCase(),
                      margin:
                          getMargin(left: 25, top: 46, right: 24, bottom: 5),
                      shape: ButtonShape.RoundedBorder16,
                      alignment: Alignment.center,
                      onTap: (){
                        Get.toNamed(AppRoutes.loginEmptyStateScreen);
                      },
                      
                      )
                ])));
  }
}
