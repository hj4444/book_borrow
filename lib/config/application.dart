import 'package:event_bus/event_bus.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Application {
  static Router router;
  static EventBus eventBus;

  static navigateTo(
      {@required BuildContext context,
      @required route,
      transition = TransitionType.inFromRight}) {
    router.navigateTo(context, route, transition: transition);
  }
}
