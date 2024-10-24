import 'package:flutter/material.dart';
import 'package:mauzoApp/core/utils/color_constant.dart';
import 'package:mauzoApp/core/utils/size_utils.dart';
import 'package:mauzoApp/theme/app_decoration.dart';
import 'package:mauzoApp/theme/app_style.dart';
import 'package:mauzoApp/widgets/common_image_view.dart';

class CustomItemCard extends StatelessWidget {
  final String name;
  final String quantity;
  final String location;
  final int price;
  final String imagePath;

  const CustomItemCard({
    Key? key,
    required this.name,
    required this.quantity,
    required this.location,
    required this.price,
    this.imagePath = 'assets/item_image.png', // Default image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getMargin(top: 8, right: 18),
      decoration: AppDecoration.fillWhiteA700.copyWith(
        boxShadow: [
          BoxShadow(
            color: ColorConstant.gray90019,
            blurRadius: getHorizontalSize(10.00),
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: getPadding(all: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(getHorizontalSize(12.00)),
            child: CommonImageView(
              imagePath: imagePath,
              height: getVerticalSize(96.00),
              width: getHorizontalSize(88.00),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: getHorizontalSize(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.txtNotoSansJPBold14,
                ),
                SizedBox(height: getVerticalSize(8)),
                Text(
                  'Qty: $quantity',
                  style: AppStyle.txtNotoSansJPBold12primary,
                ),
                SizedBox(height: getVerticalSize(8)),
                Row(
                  children: [
                    Icon(Icons.location_on, size: getSize(16.00)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.txtNotoSansJPMedium12Bluegray301,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getVerticalSize(8)),
              ],
            ),
          ),
          SizedBox(
            height: getVerticalSize(96.00), // Constrain the height of the column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Tsh. $price',
                  style: AppStyle.txtNotoSansJPBold12Orange(context),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.remove), onPressed: () {}),
                    Text('2'),
                    IconButton(icon: Icon(Icons.add), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
