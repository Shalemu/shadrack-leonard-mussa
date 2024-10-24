import 'package:mauzoApp/models/item.dart';

import '../controller/home_vtwo_controller.dart';
import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final Item listItemModelObj;

  ListItemWidget(this.listItemModelObj);

  final controller = Get.find<HomeVtwoController>();

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: () {
            Get.toNamed(AppRoutes.detailEventScreen);
          },
          child: Container(
            height: getVerticalSize(290.00),
            width: getHorizontalSize(250.00),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(getHorizontalSize(20.00)),
                    child: CommonImageView(
                      imagePath: listItemModelObj.img,
                      height: getVerticalSize(290.00),
                      width: getHorizontalSize(250.00),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: getPadding(all: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: getHorizontalSize(48.00),
                          margin: getMargin(left: 10),
                          decoration: AppDecoration.fillWhiteA700.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: getPadding(top: 7),
                                child: Text(
                                  listItemModelObj.unit,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: AppStyle.txtNotoSansJPRegular12,
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 1, bottom: 4),
                                child: Text(
                                  listItemModelObj.salePrice as String,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: AppStyle.txtNotoSansJPRegular12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: getHorizontalSize(226.00),
                          decoration: AppDecoration.outlineGray90033.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: getHorizontalSize(197.00),
                                margin: getMargin(left: 12, top: 17, right: 12),
                                child: Text(
                                  listItemModelObj.name,
                                  maxLines: null,
                                  textAlign: TextAlign.start,
                                  style: AppStyle.txtNotoSansJPBold14,
                                ),
                              ),
                              Padding(
                                padding: getPadding(left: 6, top: 11, right: 6, bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: getPadding(top: 7, bottom: 6),
                                          child: Text(
                                            "Quantity: ${listItemModelObj.minStock}",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: AppStyle.txtNotoSansJPRegular12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CustomButton(
                                      width: 64,
                                      text: "Add", // Example button text
                                      variant: ButtonVariant.FillIndigo1004c,
                                      shape: ButtonShape.RoundedBorder8,
                                      padding: ButtonPadding.PaddingAll6,
                                      fontStyle: ButtonFontStyle.NotoSansJPMedium12,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
