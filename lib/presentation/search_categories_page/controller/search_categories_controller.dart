import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/presentation/search_categories_page/models/search_categories_model.dart';
import 'package:flutter/material.dart';

class SearchCategoriesController extends GetxController {
  SearchCategoriesController(this.searchCategoriesModelObj);
var isSearching=false.obs;
var inputController = TextEditingController().obs;
  Rx<SearchCategoriesModel> searchCategoriesModelObj;
  RxList<String> categoryList =
      RxList([
        'All',
        'Events',
        'Collections',
        'Organizers',
      ]);
      var selectedCategory=0.obs;
  RxList<ExploreCategoriesModel> exploreCategoriesList=RxList([

    ExploreCategoriesModel(title: 'Bigropy stories: A Journaling Workshop', img: ImageConstant.organizer1,
     location: 'California, CA', price: 'FREE',
      day: '30', month: 'Sep'),
    ExploreCategoriesModel(title: 'Creative self care: Guide to Intuitive Watercolor', img: ImageConstant.organizer2,
     location: 'New York, NY', price: '${Constants.currency}25.90',
      day: '01', month: 'Oct'),
    ExploreCategoriesModel(title: 'Graphic Design Swalla Bigger Event For Creators', img: ImageConstant.organizer3,
     location: 'Brooklyn, NY', price: '${Constants.currency}78.90',
      day: '10', month: 'Oct'),
  ]);

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  onFieildSubmitted(String val){
    isSearching=RxBool(true);
    update();


  }

  onCategoryListItemTap(int index){
    selectedCategory=RxInt(index);
    update();


  }

  onClearTap(){
     isSearching=RxBool(false);
     inputController.value.clear();
    update();

  }
}
