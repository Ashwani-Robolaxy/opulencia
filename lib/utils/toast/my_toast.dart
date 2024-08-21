// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class MyToast {
//   static successToast(String text, BuildContext context) {
//     Fluttertoast.showToast(
//         msg: text,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }

//   static failToast(String text, BuildContext context) {
//     Fluttertoast.showToast(
//         msg: text,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }

//   static infoToast(String text, BuildContext context) {
//     Fluttertoast.showToast(
//         msg: text,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }
// }

// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:opulencia/theme/styles.dart';

class MyToast {
  static void successToast(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: Styles.mediumText(context).copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void failToast(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: Styles.mediumText(context).copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  

  static void infoToast(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: Styles.mediumText(context).copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
