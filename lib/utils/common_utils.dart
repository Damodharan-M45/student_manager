import 'package:fluttertoast/fluttertoast.dart';
import 'package:resize/resize.dart';
import 'package:flutter/material.dart';

class CommonUtils {
  static void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void showToast(message, color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 2,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 12.0.sp,
    );
  }
}
