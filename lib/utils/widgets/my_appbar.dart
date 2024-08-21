import 'package:flutter/material.dart';
import 'package:opulencia/utils/strings/strings.dart';

PreferredSize myAppBar(
    {required BuildContext context,
    required final String title,
    final Color? backgroundColor, // Make it nullable
    Color? foregroundColor,
    FontWeight? fontWeight,
    List<Widget>? action,
    PreferredSizeWidget? bottom,
    double? toolbarHeight,
    Widget? leading,
    double? leadingWidth,
    bool automaticallyImplyLeading = true}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      leading: leading,
      toolbarHeight: toolbarHeight,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? Theme.of(context).canvasColor,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontFamily: Strings.appFont,
          fontWeight: fontWeight ?? FontWeight.w700,
        ),
      ),
      actions: action ?? [],
      bottom: bottom,
    ),
  );
}
