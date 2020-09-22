import 'dart:async';

class Validators {
  static var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    var emailCheck = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailCheck) {
      sink.add(email);
    } else {
      sink.addError('Email is invalid');
    }
  });
  static var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 7 && password.length < 21) {
      sink.add(password);
    } else {
      sink.addError('password must be between 8 - 20 charactors');
    }
  });
}
