import 'dart:async';
import 'package:firebase_chat_app/helpers/validators.dart';
import 'package:firebase_chat_app/screens/lobby_screen.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SignupBloc extends Object with Validators implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final AuthService _auth = AuthService();
  final DatabaseService _database = DatabaseService();

  BuildContext _context;
  SignupBloc(this._context);

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

  signup() async {
    var result = await _auth.signupWithEmailAndPassword(
        _emailController.value, _passwordController.value);
    if (result != null) {
      Map<String, String> userInfoMap = {
        "email": _emailController.value?.trim(),
        "name": _nameController.value?.trim(),
      };
      _database.uploadUserInfo(userInfoMap);
      Navigator.pushAndRemoveUntil(
        _context,
        MaterialPageRoute(builder: (_context) => LobbyScreen()),
        (Route<dynamic> route) => false,
      );

      // Navigator.pushReplacement(
      //     _context,
      //     MaterialPageRoute(
      //       builder: (_context) => LobbyScreen(),
      //     ));
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

  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
    _nameController?.close();
  }
}
