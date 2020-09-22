import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_chat_app/Constants/constants.dart';
import 'package:firebase_chat_app/blocs/base_bloc.dart';
import 'package:firebase_chat_app/helpers/helper_functions.dart';
import 'package:firebase_chat_app/helpers/validators.dart';
import 'package:firebase_chat_app/screens/forget_password_screen.dart';
import 'package:firebase_chat_app/screens/lobby_screen.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> implements BaseBloc {
  LoginBloc(this._context) : super(LoginInitial()) {
    performLoginStatus();
  }
  final AuthService _auth = AuthService();
  final BuildContext _context;

  Stream<bool> get submitcheck =>
      Rx.combineLatest2(email, password, (a, b) => true);

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  void performLoginStatus() async {
    if (await HelperFunctions.getUserLoggedInSharedPrefernece()) {
      Constants.myId =
          (await HelperFunctions.getUserEmailSharedPrefernece()).trim();

      Navigator.push(
          _context,
          MaterialPageRoute(
            builder: (context) => LobbyScreen(),
          ));
    }
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginPressedEvent) {
      await _auth
          .signInWithEmailAndPassword(
              _emailController.value, _passwordController.value)
          .then((value) => {
                if (value != null)
                  {
                    HelperFunctions.saveUserEmailSharedPrefernece(
                        _emailController.value),
                    HelperFunctions.saveUserLoggedInSharedPrefernece(true),
                    Constants.myId = _emailController.value.trim(),
                    Navigator.pushReplacement(
                        _context,
                        MaterialPageRoute(
                          builder: (context) => LobbyScreen(),
                        ))
                  }
                else
                  {
                    showDialog(
                        context: _context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                "Alert",
                                textAlign: TextAlign.center,
                              ),
                              content: Text("Wrong Credentials!"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            ))
                  }
              });
    } else if (event is ResetPressedEvent) {
      Navigator.push(
          _context,
          MaterialPageRoute(
            builder: (context) => ForgetPassword(),
          ));
    } else if (event is SignUpPressedEvent) {}
  }

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<String> get email =>
      _emailController.stream.transform(Validators.emailValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(Validators.passwordValidator);

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
