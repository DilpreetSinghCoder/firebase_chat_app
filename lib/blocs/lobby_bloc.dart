import 'package:firebase_chat_app/helpers/helper_functions.dart';
import 'package:firebase_chat_app/models/chatroom_model.dart';
import 'package:firebase_chat_app/screens/conversation_screen.dart';
import 'package:firebase_chat_app/screens/login_screen.dart';
import 'package:firebase_chat_app/screens/search_screen.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class LobbyBloc implements BaseBloc {
  final _database = DatabaseService();
  final _auth = AuthService();
  BuildContext _context;

  Function(List<ChatroomModel>) get emailChanged =>
      _chatroomListController.sink.add;
  final _chatroomListController = BehaviorSubject<List<ChatroomModel>>();
  Stream<List<ChatroomModel>> get chatroomList =>
      _chatroomListController.stream;

  setContext(BuildContext context) {
    _context = context;
  }

  search() {
    Navigator.push(
        _context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(),
        )).then((value) => getChatRooms());
  }

  @override
  void dispose() {
    _chatroomListController.close();
  }

  void getChatRooms() async {
    String email =
        (await HelperFunctions.getUserEmailSharedPrefernece()).trim();

    _database.getChatRooms(email).then((value) {
      _chatroomListController.add(value);
    });
  }

  String chatroomId;
  openConversation(String userName) {
    Navigator.push(
        _context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatroomId: chatroomId,
            chatroomName: userName,
          ),
        )).then((value) => getChatRooms());
  }

  void logoutAction() {
    _auth.signOut();
    HelperFunctions.saveUserLoggedInSharedPrefernece(false);
    Navigator.pushReplacement(
        _context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(title: "Login"),
        ));
  }
}
