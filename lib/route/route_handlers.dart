import 'package:book_shelf/pages/borrow_history.dart';
import 'package:book_shelf/pages/home_page.dart';
import 'package:book_shelf/pages/main_page.dart';
import 'package:book_shelf/pages/registration_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var homeRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HomePage();
});

var registerRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RegistrationPage();
});

var borrowHistoryRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BorrowHistory();
});

var mainPageRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MainPage();
});
