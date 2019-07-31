import 'dart:async';

const String _kNameRule = r"^[A-Za-z0-9]{4,}$";

class NameValidator {
  final StreamTransformer<String, String> validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    final RegExp nameExp = new RegExp(_kNameRule);

    if (!nameExp.hasMatch(name) || name.isEmpty) {
      sink.addError('请输入一个有效的姓名');
    } else {
      sink.add(name);
    }
  });
}
