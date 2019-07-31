import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/blocs/basket_bloc.dart';
import 'package:flutter/material.dart';

class BasketIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Icon(
          Icons.shopping_basket,
          color: Colors.white,
        ),
        NumberInRedCircle()
      ],
    );
  }
}

class NumberInRedCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BasketBloc basketBloc = BlocProvider.of<BasketBloc>(context);
    return Container(
      width: 12.0,
      height: 12.0,
      decoration:
          BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
      child: StreamBuilder<int>(
        stream: basketBloc.outTotalBasket,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Center(
            child: Text(
              snapshot.data < 10 ? snapshot.data.toString() : "9+",
              style: TextStyle(color: Colors.white, fontSize: 8.0),
            ),
          );
        },
      ),
    );
  }
}
