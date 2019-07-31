import 'package:flutter/material.dart';

class Consts {
  static const String SERVER_ADDRESS = "http://g2539w9296.qicp.vip/";
  static const String TITLE_NAME = 'title_home';
  static const String TITLE_MY_BOOK = 'title_my_book';
  static const String TITLE_ABOUT = 'title_about';
  static const String TITLE_SIGN_OUT = 'title_signout';
  static const String BORROWING_BASKET = "borrowing_basket";
  static const String USER = "user";
  static const String SP_IS_LOGIN = "isLogin";
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;
  static const int DESIGN_WIDTH = 360;
}

const BOTTOM_ICONS = [
  Icons.home,
  Icons.person,
];
const BOTTOM_TITLES = [
  '首页',
  '我的',
];
enum NavBarItemType { HOME, MY_BOOK }
NavBarItemType convertItemType(index) {
  switch (index) {
    case 0:
      return NavBarItemType.HOME;
    case 1:
      return NavBarItemType.MY_BOOK;
    default:
      return NavBarItemType.HOME;
  }
}
