import 'dart:async';

import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/blocs/basket_bloc.dart';
import 'package:book_shelf/blocs/book_item_bloc.dart';
import 'package:book_shelf/model/models.dart';
import 'package:book_shelf/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  CartItem({Key key, @required this.book, @required this.index})
      : super(key: key);

  final BookModel book;
  final int index;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  BasketBloc _basketBloc;
  BookItemBloc _bookItemBloc;
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[getContent(), getBottomLine()]);
  }

  @override
  void didUpdateWidget(CartItem oldWidget) {
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
          getInkWellIcon(),
          Container(
            child: getHeadIcon(),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: getMiddleWidget(),
          )),
          Padding(
            child: getRightButton(),
            padding: const EdgeInsets.only(right: 10),
          )
        ],
      ),
    );
  }

  Widget getInkWellIcon() {
    return StreamBuilder(
        stream: _basketBloc.isSelected,
        initialData: false,
        builder: (context, snapshot) {
          return InkWell(
              onTap: () {
                _basketBloc.switchSelectBook.add(widget.index);
              },
              child: Icon(
                widget.book.isSelected
                    ? Icons.check_circle_outline
                    : Icons.radio_button_unchecked,
                color: Theme.of(context).accentColor,
              ));
        });
  }

  Widget getHeadIcon() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: new CachedNetworkImage(
        width: 106,
        height: 106,
        fit: BoxFit.fill,
        imageUrl: widget.book.url,
        placeholder: (context, url) => new ProgressView(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
    );
  }

  Widget getRightButton() {
    return StreamBuilder(
      stream: _bookItemBloc.isInBorrowingBasket,
      initialData: false,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
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

  Text getText(text, double fontSize, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, color: color),
    );
  }

  Widget getMiddleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getText(widget.book.name, 18, Colors.black),
        getText(widget.book.description, 14, Color(0xffcccccc)),
      ],
    );
  }
}
