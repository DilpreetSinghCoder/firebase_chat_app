import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      var tt = email.trim();
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: tt, password: password);
      var user = result.user;
      return _user(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signupWithEmailAndPassword(String email, String password) async {
    try {
      email = email.trim();
      password = password.trim();
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      return _user(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> resetPassword(
      String email, String password, String newPassword) async {
    // var authCredentials =
    //     EmailAuthProvider.getCredential(email: email, password: password);
    try {
      // var authResult =
      //await firebaseUser.reauthenticateWithCredential(authCredentials);
      // if (authResult.user != null) {
      //   var firebaseUser = await _auth.currentUser();
      //   firebaseUser.updatePassword(password);
      //   return true;
      // }
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
