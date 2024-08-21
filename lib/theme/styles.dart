import 'package:flutter/material.dart';
import 'package:opulencia/utils/strings/strings.dart';

class Styles {
  // static Color primary = const Color.fromARGB(255, 0, 49, 83);
  static Color primary = const Color.fromARGB(255, 193, 10, 83);
  static Color orangeColor = Colors.orange;
  static Color greenColor = Colors.green;
  static Color red = Colors.red;
  static Color blue = Colors.blue;

  static TextStyle largeText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).canvasColor,
        fontSize: 25,
        fontFamily: Strings.appFont,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w400);
  }

  static TextStyle largeBoldText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).canvasColor,
        fontSize: 25,
        fontFamily: Strings.appFont,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w600);
  }

  static TextStyle mediumText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).canvasColor,
        fontSize: 16,
        fontFamily: Strings.appFont,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w400);
  }

  static TextStyle mediumBoldText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).canvasColor,
        fontSize: 16,
        overflow: TextOverflow.ellipsis,
        fontFamily: Strings.appFont,
        fontWeight: FontWeight.w600);
  }

  static TextStyle smallBoldText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).canvasColor,
        fontSize: 12,
        overflow: TextOverflow.ellipsis,
        fontFamily: Strings.appFont,
        fontWeight: FontWeight.w600);
  }

  static TextStyle smallText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).canvasColor,
        fontSize: 12,
        overflow: TextOverflow.ellipsis,
        fontFamily: Strings.appFont,
        fontWeight: FontWeight.w500);
  }
}
