import 'package:book_shelf/pages/borrowing_basket_page.dart';
import 'package:book_shelf/widgets/basket_icon.dart';
import 'package:flutter/material.dart';

typedef SearchCallback = Function(String);

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final preferredSize = new Size.fromHeight(164.0);
  final SearchCallback onTextChanged;
  final GlobalKey<ScaffoldState> scaffoldKey;

  CustomAppBar(this.onTextChanged, this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.sort),
                    onPressed: () => scaffoldKey.currentState.openDrawer(),
                    color: Colors.white,
                    iconSize: 28.0,
                  ),
                  Text(
                    "发现",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(48.0),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => BorrowingBasketPage())),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BasketIcon(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 16.0, top: 10.0, right: 16.0, bottom: 12.0),
              child: TextField(
                onChanged: (s) => onTextChanged(s),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 12.0),
                    child: Icon(Icons.search),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "寻找什么?",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 10.0, color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
