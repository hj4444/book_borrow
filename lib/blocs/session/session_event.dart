import 'package:book_shelf/bloc_helpers/bloc_event_state.dart';
import 'package:book_shelf/model/models.dart';

abstract class SessionEvent extends BlocEvent {}

class SessionStarted extends SessionEvent {}

class SessionLogin extends SessionEvent {
  UserModel user;
  SessionLogin(this.user);
}

class SessionLogout extends SessionEvent {}
