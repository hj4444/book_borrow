import 'dart:async';

const String _kMin8CharsOneUpperOneLowerOneNumberOneSpecial =
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";

class PasswordValidator {
  final StreamTransformer<String, String> validatePassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) {
    final RegExp passwordExp =
        new RegExp(_kMin8CharsOneUpperOneLowerOneNumberOneSpecial);

    if (!passwordExp.hasMatch(password)) {
      sink.addError('请输入一个有效的密码');
    } else {
      sink.add(password);
    }
  });
}
