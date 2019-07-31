import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  TextWidget(this.text, this.fontSize, this.color);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: fontSize, color: color),
    );
  }
}
