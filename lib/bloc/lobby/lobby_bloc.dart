import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_chat_app/helpers/helper_functions.dart';
import 'package:firebase_chat_app/models/chatroom_model.dart';
import 'package:firebase_chat_app/screens/conversation_screen.dart';
import 'package:firebase_chat_app/screens/login_screen.dart';
import 'package:firebase_chat_app/screens/search_screen.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  LobbyBloc(this._context) : super(LobbyInitial()) {
    getChatRooms();
  }
  BuildContext _context;

  final _database = DatabaseService();
  final _auth = AuthService();

  Function(List<ChatroomModel>) get emailChanged =>
      _chatroomListController.sink.add;
  final _chatroomListController = BehaviorSubject<List<ChatroomModel>>();
  Stream<List<ChatroomModel>> get chatroomList =>
      _chatroomListController.stream;

  void getChatRooms() async {
    String email =
        (await HelperFunctions.getUserEmailSharedPrefernece()).trim();

    _database.getChatRooms(email).then((value) {
      _chatroomListController.add(value);
    });
  }

  String chatroomId;

  @override
  Stream<LobbyState> mapEventToState(
    LobbyEvent event,
  ) async* {
    if (event is LogoutPressedEvent) {
      _auth.signOut();
      HelperFunctions.saveUserLoggedInSharedPrefernece(false);
      Navigator.pushReplacement(
          _context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(title: "Login"),
          ));
    }
    if (event is OpenConversationPressedEvent) {
      Navigator.push(
          _context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatroomId: event.chatroomId,
              chatroomName: event.name,
            ),
          )).then((value) => getChatRooms());
    }
    if (event is SearchPressedEvent) {
      Navigator.push(
          _context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(),
          )).then((value) => getChatRooms());
    }
  }
}
