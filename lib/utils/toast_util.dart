import 'package:flutter/material.dart';

class ToastUtil {
  static void showToast(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        textColor: Colors.black,
        label: '撤消',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
      duration: Duration(seconds: 3), // 持续时间
      //animation,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
