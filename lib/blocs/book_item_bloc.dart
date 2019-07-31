import 'dart:async';

import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/model/models.dart';
import 'package:rxdart/rxdart.dart';

class BookItemBloc extends BlocBase {
  final BehaviorSubject<bool> _isInBorrowingBasketController =
      BehaviorSubject<bool>();
  Stream<bool> get isInBorrowingBasket => _isInBorrowingBasketController.stream;

  final StreamController<List<BookModel>> _borrowingBasketController =
      StreamController<List<BookModel>>();
  Sink<List<BookModel>> get borrowingBasket => _borrowingBasketController.sink;

  BookItemBloc(BookModel book) {
    _borrowingBasketController.stream
        .map((list) => list.any((BookModel item) => item.id == book.id))
        .listen((isSelected) => _isInBorrowingBasketController.add(isSelected));
  }

  @override
  void dispose() {
    _borrowingBasketController.close();
    _isInBorrowingBasketController.close();
  }
}
