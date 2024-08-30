import '../../../core/app_export.dart';
import 'list_item_model.dart';

class HomeVtwoModel {

 RxList<ListItemModel> listItemList=RxList([

    ListItemModel(title: 'Bigropy stories: A Journaling Workshop', img: ImageConstant.organizer1,
     location: 'California, CA', price: 'FREE',
      day: '30', month: 'Sep'),
    ListItemModel(title: 'Creative self care: Guide to Intuitive Watercolor', img: ImageConstant.organizer2,
     location: 'New York, NY', price: '${Constants.currency}25.90',
      day: '01', month: 'Oct'),
    ListItemModel(title: 'Graphic Design Swalla Bigger Event For Creators', img: ImageConstant.organizer3,
     location: 'Brooklyn, NY', price: '${Constants.currency}78.90',
      day: '10', month: 'Oct'),
  ]);

  
}
