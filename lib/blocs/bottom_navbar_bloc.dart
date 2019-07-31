import 'dart:async';

import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import "package:book_shelf/consts/consts.dart";

class BottomNavBarBloc implements BlocBase{
  final StreamController<NavBarItemType> _navBarController =
      StreamController<NavBarItemType>.broadcast();

  NavBarItemType defaultItem = NavBarItemType.HOME;

  Stream<NavBarItemType> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItemType.HOME);
        break;
      case 1:
        _navBarController.sink.add(NavBarItemType.MY_BOOK);
        break;
    }
  }

  @override
  void dispose() {
    _navBarController?.close();
  }
}
