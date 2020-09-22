import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_chat_app/helpers/helper_functions.dart';
import 'package:firebase_chat_app/helpers/validators.dart';
import 'package:firebase_chat_app/screens/lobby_screen.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  BuildContext _context;
  SignupBloc(this._context) : super(SignupInitial());

  final AuthService _auth = AuthService();
  final DatabaseService _database = DatabaseService();

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;
  Function(String) get nameChanged => _nameController.sink.add;

  Stream<String> get email =>
      _emailController.stream.transform(Validators.emailValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(Validators.passwordValidator);
  Stream<String> get name => _nameController.stream;

  Stream<bool> get submitcheck =>
      Rx.combineLatest2(email, password, (a, b) => true);

  void dispose() {
    _emailController?.close();
    _passwordController?.close();
    _nameController?.close();
  }

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is SignupPressedEvent) {
      var result = await _auth.signupWithEmailAndPassword(
          _emailController.value, _passwordController.value);
      if (result != null) {
        Map<String, String> userInfoMap = {
          "email": _emailController.value?.trim(),
          "name": _nameController.value?.trim(),
        };
        _database.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserEmailSharedPrefernece(_emailController.value);
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(builder: (_context) => LobbyScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        showDialog(
            context: _context,
            builder: (context) => AlertDialog(
                  title: Text(
                    "Alert",
                    textAlign: TextAlign.center,
                  ),
                  content: Text("Email is Already Registered."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));
      }
    }
  }
}
