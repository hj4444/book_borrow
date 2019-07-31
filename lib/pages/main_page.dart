import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/blocs/bottom_navbar_bloc.dart';
import 'package:book_shelf/blocs/user_bloc.dart';
import 'package:book_shelf/config/application.dart';
import 'package:book_shelf/consts/consts.dart';
import 'package:book_shelf/pages/home_page.dart';
import 'package:book_shelf/pages/main_left_page.dart';
import 'package:book_shelf/pages/my_page.dart';
import 'package:book_shelf/utils/screen_util.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BottomNavBarBloc _bottomNavBarBloc;
  UserBloc _userBloc;
  var curItemType = NavBarItemType.HOME;
  final navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<BottomNavigationBarItem> _bottomItems() {
    return [
      _bottomItem(NavBarItemType.HOME),
      _bottomItem(NavBarItemType.MY_BOOK)
    ];
  }

  BottomNavigationBarItem _bottomItem(NavBarItemType type) {
    return BottomNavigationBarItem(
      icon: Icon(
        BOTTOM_ICONS[type.index],
      ),
      title: Text(
        BOTTOM_TITLES[type.index],
      ),
      backgroundColor: Colors.blue,
    );
  }

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
    _userBloc = UserBloc();
  }

  Widget _itemBody(NavBarItemType type) {
    switch (type) {
      case NavBarItemType.HOME:
        return HomePage(
          labelId: Consts.TITLE_NAME,
          scaffoldKey: scaffoldKey,
        );
      case NavBarItemType.MY_BOOK:
        return MyPage(_userBloc);
      default:
        return HomePage(labelId: Consts.TITLE_NAME);
    }
  }

  @override
  void dispose() {
    _bottomNavBarBloc?.dispose();
    _userBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: Consts.DESIGN_WIDTH)..init(context);
    return new MaterialApp(
      onGenerateRoute: Application.router.generator,
      navigatorKey: navigatorKey,
      theme: ThemeData(
          primaryColor: Colors.lightBlueAccent[700], accentColor: Colors.blue),
      home: BlocProvider<BottomNavBarBloc>(
        bloc: _bottomNavBarBloc,
        child: Scaffold(
          key: scaffoldKey,
          body: StreamBuilder<NavBarItemType>(
            stream: _bottomNavBarBloc.itemStream,
            initialData: _bottomNavBarBloc.defaultItem,
            builder:
                (BuildContext context, AsyncSnapshot<NavBarItemType> snapshot) {
              return _itemBody(snapshot.data);
            },
          ),
          bottomNavigationBar: StreamBuilder(
            stream: _bottomNavBarBloc.itemStream,
            initialData: _bottomNavBarBloc.defaultItem,
            builder:
                (BuildContext context, AsyncSnapshot<NavBarItemType> snapshot) {
              return BottomNavigationBar(
                items: _bottomItems(),
                currentIndex: snapshot.data.index,
                type: BottomNavigationBarType.fixed,
                onTap: _bottomNavBarBloc.pickItem,
              );
            },
          ),
          drawer: Drawer(
            child: MainLeftPage(_userBloc),
          ),
        ),
      ),
    );
  }
}
