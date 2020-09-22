import 'package:firebase_chat_app/bloc/login_bloc.dart';
import 'package:firebase_chat_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyLoginScreenState createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<LoginScreen> {
  // final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(context),
      child: LoginPage(widget: widget),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final LoginScreen widget;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.title == "" ? "Flutter Demo Home Page" : widget.title),
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
                      'Sign up',
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
                // FlatButton(
                //   onPressed: () {
                //     bloc.add(ResetPressedEvent());
                //     //forgot password screen
                //   },
                //   textColor: Colors.blue,
                //   child: Text('Forgot Password'),
                // ),
                SizedBox(height: 40),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: StreamBuilder<bool>(
                      stream: bloc.submitcheck,
                      builder: (context, snapshot) => RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Login'),
                        onPressed: snapshot.hasData
                            ? () => {bloc.add(LoginPressedEvent())}
                            : null,
                      ),
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Does not have account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //signup screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUp(null)));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }
}
