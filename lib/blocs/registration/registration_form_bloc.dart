import 'dart:async';

import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/validators/validator_actual_name.dart';
import 'package:book_shelf/validators/validator_name.dart';
import 'package:book_shelf/validators/validator_password.dart';
import 'package:rxdart/rxdart.dart';

class RegistrationFormBloc extends Object
    with NameValidator, PasswordValidator, ActualNameValidator
    implements BlocBase {
  final BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<String> _actualNameController =
      BehaviorSubject<String>();
  Function(String) get onNameChanged => _nameController.sink.add;
  Function(String) get onPasswordChanged => _passwordController.sink.add;
  Function(String) get onActualNameChanged => _actualNameController.sink.add;
  Stream<String> get name => _nameController.stream.transform(validateName);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get actualName =>
      _actualNameController.stream.transform(validateActualName);
  Stream<bool> get registerValid =>
      Observable.combineLatest3(name, password, actualName, (e, p, c) => true);

  @override
  void dispose() {
    _nameController?.close();
    _passwordController?.close();
    _actualNameController?.close();
  }
}
