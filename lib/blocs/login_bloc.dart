import 'dart:async';
import 'package:firebase_chat_app/helpers/helper_functions.dart';
import 'package:firebase_chat_app/helpers/validators.dart';
import 'package:firebase_chat_app/Constants/constants.dart';
import 'package:firebase_chat_app/screens/lobby_screen.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final AuthService _auth = AuthService();

  BuildContext _context;
  LoginBloc(this._context) {
    performLoginStatus();
  }
  void performLoginStatus() async {
    if (await HelperFunctions.getUserLoggedInSharedPrefernece()) {
      Constants.myId =
          (await HelperFunctions.getUserEmailSharedPrefernece()).trim();

      Navigator.pushReplacement(
          _context,
          MaterialPageRoute(
            builder: (context) => LobbyScreen(),
          ));
    }
  }

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<String> get email =>
      _emailController.stream.transform(Validators.emailValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(Validators.passwordValidator);

  Stream<bool> get submitcheck =>
      Rx.combineLatest2(email, password, (a, b) => true);

  login() async {
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
            });
  }

  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
