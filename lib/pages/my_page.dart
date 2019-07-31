import 'package:book_shelf/blocs/user_bloc.dart';
import 'package:book_shelf/consts/consts.dart';
import 'package:book_shelf/pages/login_page.dart';
import 'package:book_shelf/route/routes.dart';
import 'package:book_shelf/utils/utils.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  final UserBloc _userBloc;

  MyPage(this._userBloc);

  @override
  State<StatefulWidget> createState() {
    return new MyInfoPageState();
  }
}

class MyInfoPageState extends State<MyPage> {
  var userAvatar;
  var userName;
  var icons = [];
  var titles = ["借阅记录"];
  var imagePaths = [
    Utils.getImgPath("ic_my_log"),
  ];
  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var rightArrowIcon = new Image.asset(
    Utils.getImgPath("ic_arrow_right"),
    width: Consts.ARROW_ICON_WIDTH,
    height: Consts.ARROW_ICON_WIDTH,
  );

  MyInfoPageState() {
    for (int i = 0; i < imagePaths.length; i++) {
      icons.add(getIconImage(imagePaths[i]));
    }
  }

  Widget getIconImage(path) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: new Image.asset(path,
          width: Consts.IMAGE_ICON_WIDTH, height: Consts.IMAGE_ICON_WIDTH),
    );
  }

  @override
  void initState() {
    super.initState();
    _showUserInfo();
  }

  _showUserInfo() {
    userAvatar = widget._userBloc.userModel?.icon;
    userName = widget._userBloc.userModel?.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("我的"),
        ),
        body: ListView.builder(
          itemCount: titles.length * 2,
          itemBuilder: (context, i) => renderRow(i),
        ));
  }

  renderRow(i) {
    if (i == 0) {
      var avatarContainer = Container(
        color: Theme.of(context).accentColor,
        height: 140.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userAvatar == null
                  ? Image.asset(
                      Utils.getImgPath("ic_login"),
                      width: 60.0,
                    )
                  : Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: NetworkImage(userAvatar), fit: BoxFit.cover),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
              Text(
                userName == null ? "点击头像登录" : userName,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
      return GestureDetector(
        onTap: () {
          if (widget._userBloc.userModel == null) {
            _login();
          }
        },
        child: avatarContainer,
      );
    }
    --i;
    if (i.isOdd) {
      return Divider(
        height: 1.0,
      );
    }
    i = i ~/ 2;
    String title = titles[i];
    var listItemContent = Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: Row(
        children: <Widget>[
          icons[i],
          Expanded(
              child: Text(
            title,
            style: titleTextStyle,
          )),
          rightArrowIcon
        ],
      ),
    );
    return InkWell(
      child: listItemContent,
      onTap: () {
        _handleListItemClick(title);
      },
    );
  }

  _showLoginDialog() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('没有登录，现在去登录吗？'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '取消',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  '确定',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _login();
                },
              )
            ],
          );
        });
  }

  _login() async {
    final result =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
    if (result != null && result == "refresh") {
      // 刷新用户信息
      //getUserInfo();
      // 通知动弹页面刷新
      //Constants.eventBus.fire(LoginEvent());
    }
  }

  _handleListItemClick(String title) {
    if (widget._userBloc.userModel == null) {
      _showLoginDialog();
    }

    if (title == '借阅记录') {
      Navigator.pushNamed(context, Routes.borrowHistoryPage);
    }
  }
}
