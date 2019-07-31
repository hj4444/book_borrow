import 'package:book_shelf/blocs/user_bloc.dart';
import 'package:book_shelf/consts/consts.dart';
import 'package:book_shelf/pages/about_page.dart';
import 'package:book_shelf/pages/setting_page.dart';
import 'package:book_shelf/utils/utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class MainLeftPage extends StatefulWidget {
  final UserBloc _userBloc;
  MainLeftPage(this._userBloc);
  @override
  State<StatefulWidget> createState() {
    return new _MainLeftPageState();
  }
}

class PageInfo {
  PageInfo(this.titleId, this.title, this.iconData, this.page,
      [this.withScaffold = true]);
  String titleId;
  String title;
  IconData iconData;
  Widget page;
  bool withScaffold;
}

class _MainLeftPageState extends State<MainLeftPage> {
  List<PageInfo> _pageInfo = new List();

  @override
  void initState() {
    super.initState();
    _pageInfo.add(PageInfo(Consts.TITLE_ABOUT, "关于", Icons.info, AboutPage()));
    _pageInfo.add(PageInfo(
        Consts.TITLE_SIGN_OUT, "设置", Icons.power_settings_new, SettingPage()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(
                top: ScreenUtil.getInstance().statusBarHeight, left: 10.0),
            child: new SizedBox(
              height: 120,
              width: double.infinity,
              child: new Stack(
                children: <Widget>[
                  StreamBuilder(
                      stream: widget._userBloc.userStream,
                      initialData: widget._userBloc.userModel,
                      builder: (context, snapshot) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              height: 64,
                              width: 64,
                              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    image: new AssetImage(
                                        Utils.getImgPath("ic_login"))),
                              ),
                            ),
                            new Text(
                              widget._userBloc.userModel.name,
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      })
                ],
              ),
            ),
          ),
          new Expanded(
              child: new ListView.builder(
            padding: const EdgeInsets.all(0.0),
            itemCount: _pageInfo.length,
            itemBuilder: (BuildContext context, int index) {
              PageInfo pageInfo = _pageInfo[index];
              return new ListTile(
                leading: new Icon(pageInfo.iconData),
                title: new Text(pageInfo.title),
              );
            },
          ))
        ],
      ),
    );
  }
}
