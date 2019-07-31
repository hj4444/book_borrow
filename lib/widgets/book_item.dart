import 'dart:async';

import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/blocs/basket_bloc.dart';
import 'package:book_shelf/blocs/book_item_bloc.dart';
import 'package:book_shelf/model/models.dart';
import 'package:book_shelf/widgets/book_icon.dart';
import 'package:book_shelf/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class BookItem extends StatefulWidget {
  BookItem({
    Key key,
    @required this.book,
  }) : super(key: key);

  final BookModel book;

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  BasketBloc _basketBloc;
  BookItemBloc _bookItemBloc;
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[getContent(), getBottomLine()]);
  }

  @override
  void didUpdateWidget(BookItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _initBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initBloc();
  }

  void _initBloc() {
    _bookItemBloc = BookItemBloc(widget.book);
    _basketBloc = BlocProvider.of<BasketBloc>(context);
    _subscription =
        _basketBloc.borrowingBasket.listen(_bookItemBloc.borrowingBasket.add);
  }

  void _disposeBloc() {
    _bookItemBloc?.dispose();
    _subscription?.cancel();
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  Widget getBottomLine() {
    return Container(color: Color(0xffcccccc), height: 0.5);
  }

  Widget getContent() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          BookIcon(widget.book.url),
          Container(
            width: 220,
            padding: const EdgeInsets.only(left: 10),
            child: getMiddleWidget(),
          ),
          Expanded(child: getRightButton())
        ],
      ),
    );
  }

  Widget getRightButton() {
    return StreamBuilder(
      stream: _bookItemBloc.isInBorrowingBasket,
      initialData: false,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                snapshot.data
                    ? _basketBloc.inRemoveBook.add(widget.book)
                    : _basketBloc.inAddBook.add(widget.book);
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                      color: Colors.blue,
                      child: snapshot.data
                          ? Icon(Icons.remove, size: 20, color: Colors.white)
                          : Icon(Icons.add, size: 20, color: Colors.white))),
            ),
          ],
        );
      },
    );
  }

  Widget getMiddleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextWidget(widget.book.name, 18, Colors.black),
        TextWidget(widget.book.description, 14, Color(0xffcccccc)),
      ],
    );
  }
}
