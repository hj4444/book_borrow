import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/dao/user_borrow_dao.dart';
import 'package:book_shelf/dao/user_dao.dart';
import 'package:book_shelf/model/models.dart';
import 'package:common_utils/common_utils.dart';
import 'package:rxdart/rxdart.dart';

class BasketBloc extends BlocBase {
  final Set<BookModel> _borrowingBasket = Set<BookModel>();
  String beginDate = DateUtil.getDateStrByDateTime(DateTime.now(),
      format: DateFormat.YEAR_MONTH_DAY);
  String endDate = DateUtil.getDateStrByDateTime(DateTime.now(),
      format: DateFormat.YEAR_MONTH_DAY);
  BehaviorSubject<int> _basketTotalController =
      new BehaviorSubject<int>(seedValue: 0);

  Stream<int> get outTotalBasket => _basketTotalController.stream;

  BehaviorSubject<BookModel> _bookAddController =
      new BehaviorSubject<BookModel>();

  Sink<BookModel> get inAddBook => _bookAddController.sink;

  BehaviorSubject<BookModel> _bookRemoveController =
      new BehaviorSubject<BookModel>();

  Sink<BookModel> get inRemoveBook => _bookRemoveController.sink;

  BehaviorSubject<List<BookModel>> _borrowingBasketController =
      new BehaviorSubject<List<BookModel>>(seedValue: []);

  Stream<List<BookModel>> get borrowingBasket =>
      _borrowingBasketController.stream;

  BehaviorSubject _allCheckController = new BehaviorSubject();

  Sink get allCheck => _allCheckController.sink;

  BehaviorSubject<int> _switchSelectController = new BehaviorSubject<int>();

  Sink<int> get switchSelectBook => _switchSelectController.sink;

  final BehaviorSubject<bool> _isSelectedSubject =
      BehaviorSubject<bool>(seedValue: false);

  Stream<bool> get isSelected => _isSelectedSubject.stream;

  final BehaviorSubject<bool> _isAllSelectedSubject =
      BehaviorSubject<bool>(seedValue: false);

  Stream<bool> get isAllSelected => _isAllSelectedSubject.stream;

  final BehaviorSubject<String> _beginDateController =
      BehaviorSubject<String>();

  Sink<String> get beginDateSink => _beginDateController.sink;

  Stream<String> get beginDateStream => _beginDateController.stream;
  final BehaviorSubject<String> _endDateController = BehaviorSubject<String>();

  Sink<String> get endDateSink => _endDateController.sink;

  Stream<String> get endDateStream => _endDateController.stream;

  BehaviorSubject _borrowController = new BehaviorSubject();
  Sink get borrowSink => _borrowController.sink;
  void _postActionOnBasket() {
    _borrowingBasketController.sink.add(_borrowingBasket.toList());
    _basketTotalController.sink.add(_borrowingBasket.length);
  }

  BasketBloc() {
    _bookAddController.listen(_handleAddBasket);
    _bookRemoveController.listen(_handleRemoveBasket);
    _allCheckController.listen((_) {
      _switchAllCheck();
    });
    _switchSelectController.listen(_switchSelect);
    _beginDateController.listen(_setBeginDate);
    _endDateController.listen(_setEndDate);
    _borrowController.listen((_) {
      _userBorrow();
    });
  }

  @override
  void dispose() {
    _basketTotalController.close();
    _borrowingBasketController.close();
    _bookAddController.close();
    _bookRemoveController.close();
    _allCheckController.close();
    _switchSelectController.close();
    _isSelectedSubject.close();
    _isAllSelectedSubject.close();
    _beginDateController.close();
    _endDateController.close();
    _borrowController.close();
  }

  void _handleAddBasket(BookModel bookModel) {
    _borrowingBasket.add(bookModel);
    _postActionOnBasket();
  }

  void _handleRemoveBasket(BookModel bookModel) {
    _borrowingBasket.remove(bookModel);
    _postActionOnBasket();
  }

  bool _isAllChecked() {
    return _borrowingBasket.every((i) => i.isSelected);
  }

  void _switchAllCheck() {
    if (_isAllChecked()) {
      _borrowingBasket.forEach((i) => i.isSelected = false);
      _isAllSelectedSubject.add(false);
      _isSelectedSubject.add(false);
    } else {
      _borrowingBasket.forEach((i) => i.isSelected = true);
      _isAllSelectedSubject.add(true);
      _isSelectedSubject.add(true);
    }
  }

  bool hasSelect() {
    return _borrowingBasket.any((i) => i.isSelected);
  }

  void _switchSelect(int index) {
    _borrowingBasket.elementAt(index).isSelected =
        !_borrowingBasket.elementAt(index).isSelected;
    _isSelectedSubject.add(_borrowingBasket.elementAt(index).isSelected);
  }

  void _setBeginDate(String dt) {
    beginDate = dt;
  }

  void _setEndDate(String dt) {
    endDate = dt;
  }

  void _userBorrow() async {
    List<UserBookModel> items = new List();
    var userId = await UserDao.getUserId();
    _borrowingBasket.forEach((book) {
      if (book.isSelected) {
        items
          ..add(new UserBookModel(book.id, userId, book.name, book.description,
              book.url, beginDate, endDate));
      }
    });
    var userBooks = new UserBookListModel(items: items);
    UserBorrowDao.borrow(userBooks).then((onValue) {
      _borrowingBasket.removeWhere((item) => item.isSelected == true);
      _postActionOnBasket();
      _isAllSelectedSubject.sink.add(false);
    }).catchError((e) {
      print("catchError " + e.toString());
    });
  }
}
