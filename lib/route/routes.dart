import 'package:book_shelf/route/route_handlers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static String root = "/";
  static String mainPage = "/main";
  static String homePage = "/home";
  static String registerPage = "/register";
  static String borrowHistoryPage = "/borrowHistory";
  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("Route was not found.");
    });
    router.define(registerPage, handler: registerRouteHandler);
    router.define(homePage, handler: homeRouteHandler);
    router.define(borrowHistoryPage, handler: borrowHistoryRouteHandler);
    router.define(mainPage, handler: mainPageRouteHandler);
  }
}
