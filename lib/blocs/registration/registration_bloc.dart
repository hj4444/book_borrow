import 'package:book_shelf/bloc_helpers/bloc_event_state.dart';
import 'package:book_shelf/blocs/registration/registration_event.dart';
import 'package:book_shelf/blocs/registration/registration_state.dart';
import 'package:book_shelf/dao/user_dao.dart';
import 'package:book_shelf/model/models.dart';

class RegistrationBloc
    extends BlocEventStateBase<RegistrationEvent, RegistrationState> {
  RegistrationBloc()
      : super(
          initialState: RegistrationForm(),
        );

  @override
  Stream<RegistrationState> eventHandler(
      RegistrationEvent event, RegistrationState currentState) async* {
    if (event.event == RegistrationEventType.working) {
      yield RegistrationLoading();
      //print('Registration of ${event.name}/${event.password}');
      try {
        var req = new RegisterReq(event.name, event.password, event.actualName);
        var user = await UserDao.register(req);
        UserDao.setUserSession(user);
        yield RegistrationSuccess();
      } catch (error) {
        yield RegistrationFailure(error.toString());
      }
    }
  }
}
