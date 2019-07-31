import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/blocs/home_bloc.dart';
import 'package:book_shelf/model/models.dart';
import 'package:book_shelf/widgets/book_item.dart';
import 'package:book_shelf/widgets/refresh_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

bool isHomeInit = true;

class HomePage extends StatelessWidget {
  const HomePage({Key key, this.labelId, this.scaffoldKey}) : super(key: key);

  final String labelId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    RefreshController _controller = new RefreshController();
    final HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    bloc.homeStream.listen((event) {
      if (labelId == event.labelId) {
        _controller.sendBack(false, event.status);
      }
    });
    if (isHomeInit) {
      isHomeInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(labelId: labelId);
      });
    }

    return StreamBuilder(
        stream: bloc.booksStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
          return new RefreshScaffold(
            labelId: labelId,
            isLoading: snapshot.data == null,
            controller: _controller,
            onRefresh: () {
              return bloc.onRefresh(labelId: labelId);
            },
            onLoadMore: (up) {
              bloc.onLoadMore(labelId: labelId);
            },
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              BookModel model = snapshot.data[index];
              return new BookItem(book: model);
            },
            scaffoldKey: scaffoldKey,
          );
        });
  }
}
