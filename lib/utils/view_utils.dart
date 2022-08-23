import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/getwidget.dart';

class ViewUtils {
  ViewUtils._();

  static void showSnackBar(
      String message, GlobalKey<ScaffoldState> scaffoldKey) {
    final snackBar = SnackBar(
      content: Text(message.toString()),
      duration: const Duration(milliseconds: 3000),
    );
    if (scaffoldKey.currentState != null) {
      GFToast.showToast(
        message,
        (scaffoldKey.currentState?.context)!,
        toastPosition: GFToastPosition.TOP,
        backgroundColor: Colors.black54,
        toastBorderRadius: 3.0,
      );
      // ScaffoldMessenger.of((scaffoldKey.currentState?.context)!)
      //     .showSnackBar(snackBar);
    }
  }

  static void showSnackBarWithContext(String message, BuildContext context) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.TOP,
      backgroundColor: Colors.black54,
      toastBorderRadius: 3.0,
    );
  }
}
