import 'package:mauzoApp/core/app_export.dart';
import 'package:flutter/material.dart';
//ignore: must_be_immutable
class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({this.onChanged});

  RxInt selectedIndex = 0.obs;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.inActiveHome,
      activeIcon: ImageConstant.inActiveHome,
      
      title: "lbl_home".tr,
      type: BottomBarEnum.Home,
    ),
    // BottomMenuModel(
    //   icon: ImageConstant.barcode,
    //    activeIcon: ImageConstant.activeSearch,
    //   title: "lbl_scanner".tr,
    //   type: BottomBarEnum.Scanner,
    // ),
    BottomMenuModel(
      icon: ImageConstant.imgClock,
       activeIcon: ImageConstant.imgClock,
      title: "lbl_cart".tr,
      type: BottomBarEnum.cart,
    ),
    BottomMenuModel(
      icon: ImageConstant.logout,
       activeIcon: ImageConstant.logout,
      title: "lbl_logout".tr,
      type: BottomBarEnum.logout,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgProfilecircle,
       activeIcon: ImageConstant.activeProfile,
      title: "lbl_profile".tr,
      type: BottomBarEnum.Profile,
    )
  ];

  Function(BottomBarEnum)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: getMargin(
          left: 1,
        ),
        decoration: BoxDecoration(
          color: ColorConstant.whiteA700,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          showSelectedLabels: true,
          showUnselectedLabels:true,
          elevation: 0,
          currentIndex: selectedIndex.value,
          type: BottomNavigationBarType.fixed,
          items: List.generate(bottomMenuList.length, (index) {
            return BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonImageView(
                    svgPath: bottomMenuList[index].icon,
                    height: getSize(
                      24.00,
                    ),
                    width: getSize(
                      24.00,
                    ),
                    color: ColorConstant.bluegray301,
                  ),
                  Padding(
                    padding: getPadding(
                      top: 5,
                    ),
                    child: Text(
                      bottomMenuList[index].title ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: AppStyle.txtNotoSansJPRegular10.copyWith(
                        // color: ColorConstant.bluegray301,
                      ),
                    ),
                  ),
                ],
              ),
              activeIcon: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonImageView(
                    svgPath:bottomMenuList[index].activeIcon,
                    height: getSize(
                      24.00,
                    ),
                    width: getSize(
                      24.00,
                    ),
                    color: ColorConstant.orange,
                  ),
                  Padding(
                    padding: getPadding(
                      top: 4,
                    ),
                    child: Text(
                      bottomMenuList[index].title ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: AppStyle.txtNotoSansJPBold10.copyWith(
                        color: ColorConstant.orange,
                      ),
                    ),
                  ),
                ],
              ),
              label: '',
            );
          }),
          onTap: (index) {
            selectedIndex.value = index;
            onChanged!(bottomMenuList[index].type);
          },
        ),
      ),
    );
  }
}

enum BottomBarEnum {
  Home,
  Explore,
  Favorites,
  Ticket,
  Profile, 
  cart, 
  Scanner, 
  logout,
}

class BottomMenuModel {
  BottomMenuModel({required this.icon, this.title, required this.type,
  this.activeIcon
  });

  String icon;
  String? activeIcon;

  String? title;

  BottomBarEnum type;
}

///Set default widget when screen is not configured with bottom menu
Widget getDefaultWidget() {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.all(10),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please replace the respective Widget here',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}
