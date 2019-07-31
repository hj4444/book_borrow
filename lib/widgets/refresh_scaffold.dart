import 'package:book_shelf/widgets/custom_app_bar.dart';
import 'package:book_shelf/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef void OnLoadMore(bool up);

class RefreshScaffold extends StatefulWidget {
  const RefreshScaffold(
      {Key key,
      this.labelId,
      this.isLoading,
      @required this.controller,
      this.enablePullUp: true,
      this.onRefresh,
      this.onLoadMore,
      this.child,
      this.itemCount,
      this.itemBuilder,
      this.scaffoldKey})
      : super(key: key);

  final String labelId;
  final bool isLoading;
  final RefreshController controller;
  final bool enablePullUp;
  final RefreshCallback onRefresh;
  final OnLoadMore onLoadMore;
  final Widget child;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<StatefulWidget> createState() {
    return new RefreshScaffoldState();
  }
}

class RefreshScaffoldState extends State<RefreshScaffold>
    with AutomaticKeepAliveClientMixin {
  bool isShowFloatBtn = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.scrollController.addListener(() {
        int offset = widget.controller.scrollController.offset.toInt();
        if (offset < 480 && isShowFloatBtn) {
          isShowFloatBtn = false;
          setState(() {});
        } else if (offset > 480 && !isShowFloatBtn) {
          isShowFloatBtn = true;
          setState(() {});
        }
      });
    });
  }

  Widget buildFloatingActionButton() {
    if (widget.controller.scrollController == null ||
        widget.controller.scrollController.offset < 480) {
      return null;
    }

    return new FloatingActionButton(
        heroTag: widget.labelId,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.keyboard_arrow_up,
        ),
        onPressed: () {
          //_controller.scrollTo(0.0);
          widget.controller.scrollController.animateTo(0.0,
              duration: new Duration(milliseconds: 300), curve: Curves.linear);
        });
  }

  @override
  Widget build(BuildContext context) {
    String searchTerm = "";
    return new Scaffold(
        appBar: CustomAppBar((s) {
          setState(() {
            searchTerm = s;
          });
        }, widget.scaffoldKey),
        body: new Stack(
          children: <Widget>[
            new RefreshIndicator(
                child: new SmartRefresher(
                    controller: widget.controller,
                    enablePullDown: false,
                    enablePullUp: widget.enablePullUp,
                    enableOverScroll: false,
                    onRefresh: widget.onLoadMore,
                    child: widget.child ??
                        new ListView.builder(
                          itemCount: widget.itemCount,
                          itemBuilder: widget.itemBuilder,
                        )),
                onRefresh: widget.onRefresh),
            new Offstage(
              offstage: widget.isLoading != true,
              child: new Container(
                alignment: Alignment.center,
                color: Colors.grey[50],
                child: new ProgressView(),
              ),
            )
          ],
        ),
        floatingActionButton: buildFloatingActionButton());
  }

  @override
  bool get wantKeepAlive => true;
}
