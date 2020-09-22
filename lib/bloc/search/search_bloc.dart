import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/Constants/constants.dart';
import 'package:firebase_chat_app/helpers/helper_functions.dart';
import 'package:firebase_chat_app/models/user_model.dart';
import 'package:firebase_chat_app/screens/conversation_screen.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._context) : super(SearchInitial());
  BuildContext _context;
  final DatabaseService _database = DatabaseService();
  Stream<List<User>> get searchResult => _searchResultController.stream;

  final _searchResultController = BehaviorSubject<List<User>>();

  List<User> sList = List<User>();
  final _searchController = BehaviorSubject<String>();
  Stream<String> get search => _searchController.stream;
  Function(String) get searchChanged => _searchController.sink.add;

  final _searchListController = BehaviorSubject<List<User>>();
  Stream<List<User>> get searchList => _searchListController.stream;
  Function(List<User>) get searchListChanged => _searchListController.sink.add;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchPressedEvent) {
      QuerySnapshot result =
          await _database.getUserByUserName(_searchController.value);
      print(result.toString());
      _searchResultController.add(result.documents
          .map((e) => new User(
                userEmail: e['email'],
                userName: e['name'],
              ))
          .toList()
          .where((element) => element.userEmail != Constants.myId)
          .toList());
    }
    if (event is AddToChatroomPressedEvent) {
      var myEmail = await HelperFunctions.getUserEmailSharedPrefernece();
      var t = event.searchResult.userEmail.trim();
      var tt = await _database.getUserByEmail(t);
      myEmail = myEmail ?? tt.first.userName;
      String chatroomId =
          getChatroomId(event.searchResult.userEmail.trim(), myEmail);
      var recieverEmail = event.searchResult.userEmail.trim();
      List<String> users = [recieverEmail, myEmail];
      Map<String, dynamic> userInfoMap = {
        'users': users,
        'chatroomid': chatroomId,
      };
      _database.createChatroom(chatroomId, userInfoMap);
      Navigator.pushReplacement(
          _context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatroomId: chatroomId,
              chatroomName: event.searchResult.userEmail,
            ),
          ));
    }
  }

  void dispose() {
    _searchController.close();
    _searchListController.close();
    _searchResultController.close();
  }

  String getChatroomId(String a, String b) {
    a = a.trim();

    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }
}
