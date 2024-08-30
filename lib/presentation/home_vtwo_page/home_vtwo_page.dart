import 'package:animate_do/animate_do.dart';
import 'package:mauzoApp/widgets/spacing.dart';

import '../home_vtwo_page/widgets/list_item_widget.dart';
import 'controller/home_vtwo_controller.dart';
import 'models/home_vtwo_model.dart';
import 'models/list_item_model.dart';
import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/widgets/app_bar/custom_app_bar.dart';
import 'package:mauzoApp/widgets/custom_search_view.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class HomeVtwoPage extends StatelessWidget {
  HomeVtwoController controller =
      Get.put(HomeVtwoController(HomeVtwoModel().obs));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        height: getVerticalSize(
          56.00,
        ),
        title: Padding(
          padding: getPadding(
            left: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: getPadding(
                    right: 40,
                  ),
                  child: Text(
                    "msg_find_events_near".tr,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: AppStyle.txtNotoSansJPRegular12,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: getPadding(
                    top: 5,
                  ),
                  child: Text(
                    "lbl_california_usa".tr,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: AppStyle.txtNotoSansJPBold18,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            margin: getMargin(
              left: 24,
              top: 5,
              right: 24,
              bottom: 6,
            ),
            color: ColorConstant.gray100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusStyle.roundedBorder13,
            ),
            child: Container(
              height: getSize(
                44.00,
              ),
              width: getSize(
                44.00,
              ),
              decoration: AppDecoration.fillGray100.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder13,
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: getPadding(
                        all: 10,
                      ),
                      child: CommonImageView(
                        svgPath: ImageConstant.imgVolume,
                        height: getSize(
                          24.00,
                        ),
                        width: getSize(
                          24.00,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: getSize(
                        8.00,
                      ),
                      width: getSize(
                        8.00,
                      ),
                      margin: getMargin(
                      left: 10,
                        top: 11,
                      
                        bottom: 25,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstant.redA200,
                        borderRadius: BorderRadius.circular(
                          getHorizontalSize(
                            4.00,
                          ),
                        ),
                        border: Border.all(
                          color: ColorConstant.whiteA700,
                          width: getHorizontalSize(
                            1.50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: getPadding(
          
            top: 19,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomSearchView(
                width: size.width,
                focusNode: FocusNode(),
                controller: controller.searchController,
                hintText: "lbl_search".tr,
                margin: getMargin(
                  right: 24,  left: 24,
                ),
                prefix: Container(
                  margin: getMargin(
                    left: 16,
                    top: 18,
                    right: 10,
                    bottom: 18,
                  ),
                  child: CommonImageView(
                    svgPath: ImageConstant.imgSearch,
                  ),
                ),
                prefixConstraints: BoxConstraints(
                  minWidth: getSize(
                    20.00,
                  ),
                  minHeight: getSize(
                    20.00,
                  ),
                ),
              ),
           VerticalSpace(height: 16),

              Container(
                height: getVerticalSize(40),
                child: GetBuilder<HomeVtwoController>(
                  builder: (getController) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: getPadding(
                       
                          left: 24,
                          right: 24
                      ),
                      shrinkWrap: true,
                      itemCount:controller.categoryList.length,
                      separatorBuilder: (context, index) => HorizontalSpace(width: 15),
                      itemBuilder:(context, index) {
                        
                        return    InkWell(
          highlightColor: Colors.transparent,
                          onTap: (){
                            getController.onCategoryListItemTap(index);

                          },
                          child: Container(
                              decoration:controller.selectedCategory.value==index? AppDecoration.fillprimary.copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder13,
                              ):AppDecoration.txtFillGray100.copyWith(
                                borderRadius: BorderRadiusStyle.txtRoundedBorder12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                controller.selectedCategory.value==index?  Padding(
                                    padding: getPadding(
                                      left: 16,
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    child: CommonImageView(
                                      svgPath: ImageConstant.imgRewind,
                                      height: getSize(
                                        16.00,
                                      ),
                                      width: getSize(
                                        16.00,
                                      ),
                                    ),
                                  ):HorizontalSpace(width: 14),
                                  Padding(
                                    padding: getPadding(
                                      left: 4,
                                      top: 12,
                                      right: 16,
                                      bottom: 9,
                                    ),
                                    child: Text(
                                      controller.categoryList[index],
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style:controller.selectedCategory.value==index? AppStyle.txtNotoSansJPBold12:AppStyle.txtNotoSansJPRegular12Gray902,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        );
                        
                      },
                     
                    );
                  }
                ),
              ),
            
              Padding(
                padding: getPadding(
                  top: 26,
                   left: 24,
                   right: 24
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "lbl_upcoming_events".tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: AppStyle.txtNotoSansJPBold16,
                    ),
                    Padding(
                      padding: getPadding(
                        
                        top: 1,
                        bottom: 2,
                      ),
                      child: Text(
                        "lbl_see_all".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: AppStyle.txtNotoSansJPMedium14Bluegray301,
                      ),
                    ),
                  ],
                ),
              ),
             
             
             VerticalSpace(height: 13),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: getVerticalSize(
                    320.00,
                  ),
               
                  child: Obx(
                    () => ListView.separated(
                      padding: getPadding(
                     
                          left: 24,
                          right: 24
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: controller
                          .homeVtwoModelObj.value.listItemList.length,
                          separatorBuilder: (context, index) => HorizontalSpace(width: 16),
                      itemBuilder: (context, index) {
                        ListItemModel model = controller
                            .homeVtwoModelObj.value.listItemList[index];
                        return FadeInLeft(
                          child: ListItemWidget(
                            model,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: getPadding(
                  top: 20,
                   left: 24,
                   right: 24
                ),
                child: Text(
                  "msg_suggestion_for_you".tr,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: AppStyle.txtNotoSansJPBold16,
                ),
              ),
            
            VerticalSpace(height: 13),
              ListView.separated(
                padding: getPadding(
                    right: 24,
                  left: 24,
                  bottom: 10
                ),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                separatorBuilder:(context, index) => VerticalSpace(height: 10),
                
                itemCount: controller
                          .homeVtwoModelObj.value.listItemList.length,

                itemBuilder: (context,index){
                   ListItemModel model = controller
                            .homeVtwoModelObj.value.listItemList[index];
                return   InkWell(
          highlightColor: Colors.transparent,
                  onTap: (){
                     Get.toNamed(AppRoutes.detailEventScreen);
                  },
                  child: Container(
                               
                  height: getVerticalSize(130),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                  imagePath: model.img,
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
                                decoration: AppDecoration.fillWhiteA700
                                    .copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder13,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: getPadding(
                                        left: 8,
                                        top: 2,
                                        right: 8,
                                      ),
                                      child: Text(
                                        model.day,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: AppStyle
                                            .txtNotoSansJPBold12Gray902,
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                        left: 8,
                                        right: 8,
                                        bottom: 1,
                                      ),
                                      child: Text(
                                        model.month,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: AppStyle
                                            .txtNotoSansJPMedium8,
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
                                203.00,
                              ),
                              child: Text(
                               model.title,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                style: AppStyle.txtNotoSansJPBold14,
                              ),
                            ),
                            Container(
                              width: getHorizontalSize(
                                203.00,
                              ),
                              margin: getMargin(
                                top: 19,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: getPadding(
                                      top: 7,
                                      bottom: 6,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            top: 1,
                                            bottom: 1,
                                          ),
                                          child: CommonImageView(
                                            svgPath: ImageConstant
                                                .imgLocation16x16,
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
                                          ),
                                          child: Text(
                                            model.location,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: AppStyle
                                                .txtNotoSansJPMedium12Bluegray301,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: AppDecoration
                                        .fillGray102
                                        .copyWith(
                                      borderRadius: BorderRadiusStyle
                                          .roundedBorder8,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: getPadding(
                                            left: 17,
                                            top: 7,
                                            right: 17,
                                            bottom: 6,
                                          ),
                                          child: Text(
                                            model.price,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: AppStyle
                                                .txtNotoSansJPMedium12primary,
                                          ),
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
                    ],
                  ),
                              ),
                );
             
              }),
          
          
            ],
          ),
        ),
      ),
    );
  }
}
