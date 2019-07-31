import 'dart:async';

import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/validators/validator_name.dart';
import 'package:book_shelf/validators/validator_password.dart';
import 'package:rxdart/rxdart.dart';

class LoginFormBloc extends Object
    with NameValidator, PasswordValidator
    implements BlocBase {
  final BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  Function(String) get onNameChanged => _nameController.sink.add;

  Function(String) get onPasswordChanged => _passwordController.sink.add;

  Stream<String> get name => _nameController.stream.transform(validateName);

  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get registerValid =>
      Observable.combineLatest2(name, password, (e, p) => true);

  @override
  void dispose() {
    _nameController?.close();
    _passwordController?.close();
  }
}
