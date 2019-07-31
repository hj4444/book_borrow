import 'dart:collection';

import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/consts/consts.dart';
import 'package:book_shelf/dao/book_dao.dart';
import 'package:book_shelf/event/status_event.dart';
import 'package:book_shelf/model/models.dart';
import 'package:common_utils/common_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc implements BlocBase {
  BehaviorSubject<List<BookModel>> _booksController =
      BehaviorSubject<List<BookModel>>();

  Sink<List<BookModel>> get _booksSink => _booksController.sink;
  Stream<List<BookModel>> get booksStream => _booksController.stream;

  List<BookModel> _booksList;
  int _bookPage = 0;
  BehaviorSubject<StatusEvent> _homeController = BehaviorSubject<StatusEvent>();
  Sink<StatusEvent> get _homeSink => _homeController.sink;
  Stream<StatusEvent> get homeStream =>
      _homeController.stream.asBroadcastStream();

  @override
  void dispose() {
    _booksController.close();
    _homeController.close();
  }

  Future getData({String labelId, int page}) {
    switch (labelId) {
      case Consts.TITLE_NAME:
        return getBooksByPager(labelId, page);
      default:
        return Future.delayed(new Duration(seconds: 1));
        break;
    }
  }

  Future onLoadMore({String labelId}) {
    int _page = 0;
    switch (labelId) {
      case Consts.TITLE_NAME:
        _page = ++_bookPage;
        break;
      default:
        break;
    }
    return getData(labelId: labelId, page: _page);
  }

  Future onRefresh({String labelId}) {
    switch (labelId) {
      case Consts.TITLE_NAME:
        _bookPage = 0;
        break;
      default:
        break;
    }

    return getData(labelId: labelId, page: 0);
  }

  Future getBooksByPager(String labelId, int page) async {
    return BookDao.getBooksByPager(page: page).then((list) {
      if (_booksList == null) {
        _booksList = new List();
      }
      if (page == 0) {
        _booksList.clear();
      }
      _booksList.addAll(list);
      _booksSink.add(UnmodifiableListView<BookModel>(_booksList));
      _homeSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? RefreshStatus.noMore
              : RefreshStatus.idle));
    }).catchError(() {
      _bookPage--;
      _homeSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }
}
