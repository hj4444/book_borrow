import 'package:book_shelf/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookIcon extends StatelessWidget {
  final String bookUrl;
  BookIcon(this.bookUrl);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: new CachedNetworkImage(
        width: 106,
        height: 106,
        fit: BoxFit.fill,
        imageUrl: bookUrl,
        placeholder: (context, url) => new ProgressView(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
    );
  }
}
