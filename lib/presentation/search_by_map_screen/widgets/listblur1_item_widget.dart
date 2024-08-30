import '../controller/search_by_map_controller.dart';
import '../models/listblur1_item_model.dart';
import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/widgets/custom_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Listblur1ItemWidget extends StatelessWidget {
  Listblur1ItemWidget(this.listblur1ItemModelObj);

  Listblur1ItemModel listblur1ItemModelObj;

  var controller = Get.find<SearchByMapController>();

  @override
  Widget build(BuildContext context) {
    return Container(
     
      margin: getMargin(
        top: 8.5,
        bottom: 8.5,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: getMargin(
            right: 2,
            bottom: 1,
          ),
          decoration: AppDecoration.fillWhiteA700.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder16,
             boxShadow: [
                                      BoxShadow(
                                        color: ColorConstant.gray90019,
                                        spreadRadius: getHorizontalSize(
                                          0.00,
                                        ),
                                        blurRadius: getHorizontalSize(
                                          10.00,
                                        ),
                                        offset: Offset(
                                          0,
                                          4,
                                        ),
                                      ),
                                    ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: getVerticalSize(
                  96.00,
                ),
                width: getHorizontalSize(
                  88.00,
                ),
                margin: getMargin(
                  left: 12,
                  top: 12,
                  bottom: 12,
                ),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          getHorizontalSize(
                            12.00,
                          ),
                        ),
                        child: CommonImageView(
                          imagePath: ImageConstant.imgImg,
                          height: getVerticalSize(
                            96.00,
                          ),
                          width: getHorizontalSize(
                            88.00,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: getMargin(
                          left: 8,
                          top: 8,
                          right: 10,
                          bottom: 10,
                        ),
                        decoration: AppDecoration.fillWhiteA700.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder13,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: getPadding(
                                left: 8,
                                top: 2,
                                right: 8,
                              ),
                              child: Text(
                                "lbl_29".tr,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: AppStyle.txtNotoSansJPBold12Gray902,
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 8,
                                right: 8,
                                bottom: 1,
                              ),
                              child: Text(
                                "lbl_mar".tr,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: AppStyle.txtNotoSansJPMedium8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(
                  left: 12,
                  top: 20,
                  right: 12,
                  bottom: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: getHorizontalSize(
                        184.00,
                      ),
                      margin: getMargin(
                        right: 10,
                      ),
                      child: Text(
                        "msg_startup_business".tr,
                        maxLines: null,
                        textAlign: TextAlign.start,
                        style: AppStyle.txtNotoSansJPBold14,
                      ),
                    ),
                    Padding(
                      padding: getPadding(
                        top: 19,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: getPadding(
                              top: 8,
                              bottom: 8,
                            ),
                            child: CommonImageView(
                              svgPath: ImageConstant.imgLocation16x16,
                              height: getSize(
                                16.00,
                              ),
                              width: getSize(
                                16.00,
                              ),
                            ),
                          ),
                          Padding(
                            padding: getPadding(
                              left: 4,
                              top: 8,
                              bottom: 5,
                            ),
                            child: Text(
                              "lbl_landing_park".tr,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style:
                                  AppStyle.txtNotoSansJPMedium12Bluegray301,
                            ),
                          ),
                          CustomButton(
                            width: 64,
                            text: "lbl_join".tr,
                            margin: getMargin(
                              left: 43,
                            ),
                            shape: ButtonShape.RoundedBorder8,
                            padding: ButtonPadding.PaddingAll6,
                            fontStyle:
                                ButtonFontStyle.NotoSansJPMedium12WhiteA700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}