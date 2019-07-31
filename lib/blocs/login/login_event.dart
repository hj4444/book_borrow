import 'package:book_shelf/bloc_helpers/bloc_event_state.dart';

abstract class LoginEvent extends BlocEvent {}

class LoginRequest extends LoginEvent {
  final String name;
  final String password;

  LoginRequest(this.name, this.password);
}
