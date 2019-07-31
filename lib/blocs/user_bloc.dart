import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/dao/user_dao.dart';
import 'package:book_shelf/model/models.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements BlocBase {
  UserModel userModel;

  final BehaviorSubject<UserModel> _userController =
      BehaviorSubject<UserModel>();

  Sink<UserModel> get userSink => _userController.sink;

  Stream<UserModel> get userStream => _userController.stream;

  UserBloc() {
    UserDao.getUserInfo().then((user) {
      userModel = user;
    });
  }
  @override
  void dispose() {
    _userController.close();
  }
}
