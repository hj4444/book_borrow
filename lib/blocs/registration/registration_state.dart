import 'package:book_shelf/bloc_helpers/bloc_event_state.dart';

class RegistrationState extends BlocState {}

class RegistrationForm extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String error;
  RegistrationFailure(this.error);
}
