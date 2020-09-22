import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_chat_app/helpers/validators.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  ForgetPasswordBloc() : super(ForgetPasswordInitial());
  final AuthService _auth = AuthService();

  final _emailController = BehaviorSubject<String>();
  Function(String) get emailChanged => _emailController.sink.add;
  Stream<String> get email =>
      _emailController.stream.transform(Validators.emailValidator);

  final _oldpasswordController = BehaviorSubject<String>();
  Function(String) get oldPasswordChanged => _oldpasswordController.sink.add;
  Stream<String> get oldPassword =>
      _oldpasswordController.stream.transform(Validators.passwordValidator);

  final _newPasswordController = BehaviorSubject<String>();
  Function(String) get newPasswordChanged => _newPasswordController.sink.add;
  Stream<String> get newPassword =>
      _newPasswordController.stream.transform(Validators.passwordValidator);

  final _confirmPasswordController = BehaviorSubject<String>();
  Function(String) get confirmPasswordChanged =>
      _confirmPasswordController.sink.add;
  Stream<String> get confirmPassword =>
      _confirmPasswordController.stream.transform(Validators.passwordValidator);

  Stream<bool> get submitcheck => Rx.combineLatest4(email, oldPassword,
      confirmPassword, confirmPassword, (a, b, c, d) => true);

  @override
  Stream<ForgetPasswordState> mapEventToState(
    ForgetPasswordEvent event,
  ) async* {
    if (event is UpdatePasswordPressedEvent) {
      if (_confirmPasswordController.value ==
          _newPasswordController.value.trim()) {
        var t = await _auth.resetPassword(
            _emailController.value.trim(),
            _oldpasswordController.value.trim(),
            _confirmPasswordController.value.trim());
        if (t) {}
      }
    }
  }
}
