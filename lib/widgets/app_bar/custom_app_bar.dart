import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mauzoApp/core/app_export.dart';

import '../../presentation/select_language_screen/controller/select_language_controller.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    required this.height,
    this.styleType,
    this.leadingWidth,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
    this.backgroundColor = Colors.transparent, // Default to transparent
  });

  final double height;
  final Style? styleType;
  final double? leadingWidth;
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Color backgroundColor; // Store background color

  // Controller for language localization
  final controller = Get.put(SelectLanguageController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0, // Remove shadow
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor, // Set background color
      flexibleSpace: _getStyle(), // Use flexible space for decoration
      leadingWidth: leadingWidth ?? 0,
      leading: _getLeadingWidget(),
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  // Adjusts the back button rotation for RTL locales
  Widget? _getLeadingWidget() {
    return controller.locale == Locale('ar')
        ? RotatedBox(
            quarterTurns: 2,
            child: leading,
          )
        : leading;
  }

  // Size for the AppBar
  @override
  Size get preferredSize => Size(
        size.width,
        height,
      );

  // Styles the background of the AppBar
  Widget? _getStyle() {
    switch (styleType) {
      case Style.bgFillWhiteA700:
        return Container(
          width: size.width,
          height: height,
          decoration: BoxDecoration(
            color: ColorConstant.whiteA700, // Background color from constants
          ),
        );
      default:
        return null; // No additional styling if not specified
    }
  }
}

// Enum for different styles
enum Style {
  bgFillWhiteA700,
}
