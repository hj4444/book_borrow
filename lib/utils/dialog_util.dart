import 'package:flutter/material.dart';

class DialogUtil {
  static Future<T> showMyDialog<T>(BuildContext context,
      {Widget title,
      Widget content,
      VoidCallback onConfim,
      VoidCallback onCancle}) {
    return showDialog<T>(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: title,
            content: content,
            actions: <Widget>[
              new FlatButton(
                onPressed: onConfim,
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: onCancle,
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  static Future<T> showMyDialogWithColumn<T>(BuildContext context,
      {Widget title,
      Column column,
      VoidCallback onConfim,
      VoidCallback onCancel}) {
    return showDialog<T>(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: title,
            content: new SingleChildScrollView(
              child: column,
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: onConfim,
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: onCancel,
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  static Future<T> showMyDialogWithListView<T>(BuildContext context,
      {ListView listview,
      Widget title,
      double width,
      double height,
      VoidCallback onConfirm,
      VoidCallback onCancel}) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: title,
          content: new Container(
            width: width,
            height: height,
            child: listview,
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: onConfirm,
              child: new Text("确认"),
            ),
            new FlatButton(
              onPressed: onCancel,
              child: new Text("取消"),
            ),
          ],
        );
      },
    );
  }
}
