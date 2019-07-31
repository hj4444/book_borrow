import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/blocs/basket_bloc.dart';
import 'package:book_shelf/consts/color.dart';
import 'package:book_shelf/model/models.dart';
import 'package:book_shelf/widgets/cart_buttom.dart';
import 'package:book_shelf/widgets/cart_item.dart';
import 'package:flutter/material.dart';

class BorrowingBasketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BasketBloc basketBloc = BlocProvider.of<BasketBloc>(context);
    return Scaffold(
      appBar: new AppBar(
        title: Text('书架'),
      ),
      body: StreamBuilder(
        stream: basketBloc.borrowingBasket,
        builder:
            (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
          if (snapshot.hasData) {
            return Column(children: <Widget>[
              Expanded(
                  child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  BookModel item = snapshot.data[index];
                  return Dismissible(
                    resizeDuration: Duration(milliseconds: 100),
                    key: Key(item.name),
                    onDismissed: (direction) {
                      snapshot.data.removeAt(index);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("${item.name}   成功移除"),
                        backgroundColor: ColorConst.themeColor,
                        duration: Duration(seconds: 1),
                      ));
                    },
                    background: Container(color: ColorConst.themeColor),
                    child: CartItem(
                      book: item,
                      index: index,
                    ),
                  );
                },
              )),
              CartBottom()
            ]);
          }
          return Container();
        },
      ),
    );
  }
}
