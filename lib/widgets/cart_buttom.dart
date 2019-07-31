import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/blocs/basket_bloc.dart';
import 'package:book_shelf/consts/color.dart';
import 'package:book_shelf/utils/screen_util.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BasketBloc basketBloc = BlocProvider.of<BasketBloc>(context);
    return StreamBuilder(
        stream: basketBloc.isAllSelected,
        initialData: false,
        builder: (context, snapshot) {
          return Container(
            height: ScreenUtil().L(54),
            decoration: BoxDecoration(
                color: ColorConst.cartBottomBgColor,
                border: Border(
                    top: BorderSide(
                        width: 1, color: ColorConst.divideLineColor))),
            padding: EdgeInsets.only(left: ScreenUtil().L(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                          onTap: () => basketBloc.allCheck.add(null),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                snapshot.data
                                    ? Icons.check_circle_outline
                                    : Icons.radio_button_unchecked,
                                color: ColorConst.themeColor,
                              ),
                              Text(
                                '全选',
                                style: TextStyle(letterSpacing: 2),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (basketBloc.hasSelect()) {
                      showMySimpleDialog(basketBloc, context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: new Text("警告"),
                              content: new Text("请选择书本"),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text("确认"),
                                ),
                                new FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text("取消"),
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 10),
                      color: ColorConst.goPayBtBgColor,
                      width: ScreenUtil().L(100),
                      height: ScreenUtil().L(54),
                      child: Text(
                        '借阅',
                        style: TextStyle(color: ColorConst.goPayBtTxtColor),
                      )),
                )
              ],
            ),
          );
        });
  }

  void showMySimpleDialog(BasketBloc basketBloc, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            titlePadding: EdgeInsets.all(12),
            title: new Text("选择日期", style: new TextStyle(fontSize: 10.0)),
            content: Container(
                height: MediaQuery.of(context).size.height / 5,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  StreamBuilder(
                      stream: basketBloc.beginDateStream,
                      initialData: DateTime.now(),
                      builder: (context, snapshot) {
                        return Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Text(DateUtil.getDateStrByTimeStr(
                                basketBloc.beginDate,
                                format: DateFormat.YEAR_MONTH_DAY)),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            RaisedButton(
                              child: Text(
                                '开始日期',
                                style: new TextStyle(fontSize: 12),
                              ),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateUtil.getDateTime(
                                                    basketBloc.beginDate) ==
                                                null
                                            ? DateTime.now()
                                            : DateUtil.getDateTime(
                                                basketBloc.beginDate),
                                        firstDate: DateTime(2019),
                                        lastDate: DateTime(2021))
                                    .then((date) {
                                  if (date != null) {
                                    basketBloc.beginDateSink
                                        .add(date.toString());
                                  }
                                });
                              },
                            )
                          ],
                        );
                      }),
                  StreamBuilder(
                      stream: basketBloc.endDateStream,
                      initialData: DateTime.now(),
                      builder: (context, snapshot) {
                        return Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Text(DateUtil.getDateStrByTimeStr(
                                basketBloc.endDate,
                                format: DateFormat.YEAR_MONTH_DAY)),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            RaisedButton(
                              child: Text(
                                '结束日期',
                                style: new TextStyle(fontSize: 12),
                              ),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateUtil.getDateTime(
                                              basketBloc.endDate) ==
                                          null
                                      ? DateTime.now()
                                      : DateUtil.getDateTime(
                                          basketBloc.endDate),
                                  firstDate: DateTime(2019),
                                  lastDate: DateTime(2021),
                                  //initialDatePickerMode: DatePickerMode.day,
                                  locale: Locale('zh'),
                                ).then((date) {
                                  if (date != null) {
                                    basketBloc.endDateSink.add(date.toString());
                                  }
                                });
                              },
                            )
                          ],
                        );
                      })
                ])),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  basketBloc.borrowSink.add(null);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
