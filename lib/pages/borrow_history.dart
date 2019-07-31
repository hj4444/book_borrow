import 'package:book_shelf/blocs/user_borrow_history_bloc.dart';
import 'package:book_shelf/model/models.dart';
import 'package:book_shelf/widgets/book_icon.dart';
import 'package:book_shelf/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class BorrowHistory extends StatefulWidget {
  @override
  _BorrowHistory createState() => _BorrowHistory();
}

class _BorrowHistory extends State<BorrowHistory> {
  UserBorrowHistoryBloc _userBorrowHistoryBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("借阅记录"),
        ),
        body: _listInfos());
  }

  @override
  void initState() {
    super.initState();
    _userBorrowHistoryBloc = UserBorrowHistoryBloc();
    _userBorrowHistoryBloc.getUserBorrowHistory();
  }

  @override
  void dispose() {
    super.dispose();
    _userBorrowHistoryBloc?.dispose();
  }

  Widget _listInfos() {
    return StreamBuilder(
        stream: _userBorrowHistoryBloc.borrowHistoryStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<UserBorrowHistoryModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (content, index) {
                  UserBorrowHistoryModel model = snapshot.data[index];
                  return _listItem(model);
                });
          } else {
            return Container();
          }
        });
  }

  Widget _listItem(UserBorrowHistoryModel model) {
    return Container(
      height: 110,
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          BookIcon(model.url),
          Container(
            padding: const EdgeInsets.only(left: 20),
            height: 100,
            width: 250,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 140),
                  child: TextWidget(model.bookName, 18, Colors.black),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /* Container(
                        width: 40,
                        height: 20,
                        alignment: Alignment.bottomLeft,
                        child:
                            TextWidget(model.borrowDate, 14, Color(0xffcccccc)),
                      ),*/
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            TextWidget(
                                model.beginDate + "---", 14, Color(0xffcccccc)),
                            TextWidget(model.endDate, 14, Color(0xffcccccc)),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
