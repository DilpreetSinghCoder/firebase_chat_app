import 'package:firebase_chat_app/bloc/signup/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (context) => SignupBloc(context),
      child: SignupPage(),
    );
  }
}

class SignupPage extends StatelessWidget {
  SignupBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<SignupBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign-up'),
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
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder<String>(
                    stream: bloc.name,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.nameChanged,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          errorText: snapshot.error),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder<String>(
                    stream: bloc.email,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.emailChanged,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                          errorText: snapshot.error),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: StreamBuilder<String>(
                    stream: bloc.password,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.passwordChanged,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
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
                        child: Text('Sign-Up'),
                        onPressed: snapshot.hasData
                            ? () => {bloc.add(SignupPressedEvent())}
                            : null,
                      ),
                    )),
              ],
            )));
  }
}
