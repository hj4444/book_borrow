import 'package:book_shelf/bloc_helpers/bloc_event_state.dart';
import 'package:book_shelf/blocs/session/session_event.dart';
import 'package:book_shelf/blocs/session/session_state.dart';
import 'package:book_shelf/consts/consts.dart';
import 'package:flustars/flustars.dart';

class SessionBloc extends BlocEventStateBase<SessionEvent, SessionState> {
  SessionBloc() : super(initialState: SessionUninitialized());

  @override
  Stream<SessionState> eventHandler(
      SessionEvent event, SessionState currentState) async* {
    if (event is SessionStarted) {
      var result = SpUtil.getString(Consts.USER);

      // show splash screen
      await Future.delayed(Duration(seconds: 1));
      if (result != null && result != "") {
        yield SessionAuthenticated();
      } else {
        yield SessionUnAuthenticated();
      }
    }

    if (event is SessionLogin) {
      yield SessionAuthenticated();
    }

    if (event is SessionLogout) {
      SpUtil.remove(Consts.USER);

      yield SessionUnAuthenticated();
    }
  }
}
