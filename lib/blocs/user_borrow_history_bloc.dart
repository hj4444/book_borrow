import 'dart:collection';

import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/dao/user_borrow_dao.dart';
import 'package:book_shelf/model/models.dart';
import 'package:rxdart/rxdart.dart';

class UserBorrowHistoryBloc implements BlocBase {
  BehaviorSubject<List<UserBorrowHistoryModel>> _borrowHistoryController =
      BehaviorSubject<List<UserBorrowHistoryModel>>();

  Sink<List<UserBorrowHistoryModel>> get borrowHistorySink =>
      _borrowHistoryController.sink;
  Stream<List<UserBorrowHistoryModel>> get borrowHistoryStream =>
      _borrowHistoryController.stream;
  List<UserBorrowHistoryModel> _borrowHistoryList;

  @override
  void dispose() {
    _borrowHistoryController?.close();
  }

  Future getUserBorrowHistory() async {
    return UserBorrowDao.getUserBookHistoryList().then((list) {
      if (_borrowHistoryList == null) {
        _borrowHistoryList = new List();
      }
      _borrowHistoryList.addAll(list);
      borrowHistorySink.add(
          UnmodifiableListView<UserBorrowHistoryModel>(_borrowHistoryList));
    }).catchError((e) {
      print("catchError " + e.toString());
    });
  }
}
