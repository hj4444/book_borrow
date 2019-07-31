import 'package:book_shelf/bloc_helpers/bloc_event_state.dart';

class RegistrationEvent extends BlocEvent {
  RegistrationEvent({
    this.event,
    this.name,
    this.password,
    this.actualName,
  });

  final RegistrationEventType event;
  final String name;
  final String password;
  final String actualName;
}

enum RegistrationEventType {
  none,
  working,
}
