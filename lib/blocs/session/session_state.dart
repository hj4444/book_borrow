import 'package:book_shelf/bloc_helpers/bloc_event_state.dart';

class SessionState extends BlocState {}

class SessionUninitialized extends SessionState {}

class SessionAuthenticated extends SessionState {}

class SessionUnAuthenticated extends SessionState {}
