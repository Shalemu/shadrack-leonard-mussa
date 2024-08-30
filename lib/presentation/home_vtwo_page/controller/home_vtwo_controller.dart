import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/models/home_vtwo_model.dart';
import 'package:flutter/material.dart';

class HomeVtwoController extends GetxController {
  HomeVtwoController(this.homeVtwoModelObj);
 RxList<String> categoryList =
      RxList([
        'My feed',
        'Concerts',
        'Seminar',
        'Theater',
      ]);
      var selectedCategory=0.obs;
  TextEditingController searchController = TextEditingController();

  Rx<HomeVtwoModel> homeVtwoModelObj;

  

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }


  onCategoryListItemTap(int index){
    selectedCategory=RxInt(index);
    update();


  }
}
