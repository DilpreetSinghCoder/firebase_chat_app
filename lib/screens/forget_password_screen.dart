import 'package:firebase_chat_app/bloc/forget_password/forget_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgetPasswordBloc>(
      create: (context) => ForgetPasswordBloc(),
      child: ForgetPasswordPage(),
    );
  }
}

// ignore: must_be_immutable
class ForgetPasswordPage extends StatelessWidget {
  ForgetPasswordBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ForgetPasswordBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Forget Password'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Chat Application',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Forget Password',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder<String>(
                    stream: bloc.email,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.emailChanged,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          errorText: snapshot.error),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder<String>(
                    stream: bloc.oldPassword,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.oldPasswordChanged,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Old Password',
                          errorText: snapshot.error),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder<String>(
                    stream: bloc.newPassword,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.newPasswordChanged,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New Password',
                          errorText: snapshot.error),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: StreamBuilder<String>(
                    stream: bloc.confirmPassword,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.confirmPasswordChanged,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          errorText: snapshot.error),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: StreamBuilder<bool>(
                      stream: bloc.submitcheck,
                      builder: (context, snapshot) => RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Change Password'),
                        onPressed: snapshot.hasData
                            ? () => {bloc.add(UpdatePasswordPressedEvent())}
                            : null,
                      ),
                    )),
              ],
            )));
  }
}
