import 'package:mauzoApp/core/app_export.dart';import 'package:mauzoApp/presentation/favorites_page/models/favorites_model.dart';class FavoritesController extends GetxController {FavoritesController(this.favoritesModelObj);

Rx<FavoritesModel> favoritesModelObj;

@override void onReady() { super.onReady(); } 
@override void onClose() { super.onClose(); } 
 }
