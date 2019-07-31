import 'dart:convert';

import 'package:book_shelf/consts/consts.dart';
import 'package:book_shelf/model/models.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class Utils {
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static int getUserId() {
    String strUser = SpUtil.getString(Consts.USER);
    UserModel user = UserModel.fromJson(json.decode(strUser));
    return user.id;
  }
}
