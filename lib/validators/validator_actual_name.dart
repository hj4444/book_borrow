import 'dart:async';

class ActualNameValidator {
  final StreamTransformer<String, String> validateActualName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.isEmpty) {
      sink.addError('请输入真实姓名');
    } else {
      sink.add(name);
    }
  });
}
