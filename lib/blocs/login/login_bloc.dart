import 'package:book_shelf/bloc_helpers/bloc_event_state.dart';
import 'package:book_shelf/blocs/login/login_event.dart';
import 'package:book_shelf/blocs/login/login_state.dart';
import 'package:book_shelf/blocs/session/session_bloc.dart';
import 'package:book_shelf/blocs/session/session_event.dart';
import 'package:book_shelf/dao/user_dao.dart';
import 'package:book_shelf/model/models.dart';

class LoginBloc extends BlocEventStateBase<LoginEvent, LoginState> {
  final SessionBloc _sessionBloc;

  LoginBloc(this._sessionBloc) : super(initialState: LoginForm());

  @override
  Stream<LoginState> eventHandler(
      LoginEvent event, LoginState currentState) async* {
    if (event is LoginRequest) {
      yield LoginLoading();

      try {
        var loginModel = new LoginReq(event.name, event.password);
        var user = await UserDao.login(loginModel);

        if (user.id != 0) {
          _sessionBloc.emitEvent(SessionLogin(user));
          yield LoginForm();
        }
      } catch (error) {
        yield LoginFailure(error.toString());
      }
    }
  }
}
