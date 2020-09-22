import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/Constants/constants.dart';
import 'package:firebase_chat_app/helpers/helper_functions.dart';
import 'package:firebase_chat_app/models/user_model.dart';
import 'package:firebase_chat_app/screens/conversation_screen.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class SearchBloc implements BaseBloc {
  BuildContext _context;
  int listCount;
  SearchBloc(this._context);
  Stream<List<User>> get searchResult => _searchResultController.stream;

  final _searchResultController = BehaviorSubject<List<User>>();

  List<User> sList = List<User>();
  final _searchController = BehaviorSubject<String>();
  final DatabaseService _database = DatabaseService();
  Stream<String> get search => _searchController.stream;
  Function(String) get searchChanged => _searchController.sink.add;

  final _searchListController = BehaviorSubject<List<User>>();
  Stream<List<User>> get searchList => _searchListController.stream;
  Function(List<User>) get searchListChanged => _searchListController.sink.add;

  searchUserByName() async {
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

  @override
  void dispose() {
    _searchController.close();
    _searchListController.close();
  }

  String getChatroomId(String a, String b) {
    a = a.trim();

    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  addToChatroom(User searchResult) async {
    var myEmail = await HelperFunctions.getUserEmailSharedPrefernece();
    var t = searchResult.userEmail.trim();
    var tt = await _database.getUserByEmail(t);
    myEmail = myEmail ?? tt.first.userName;
    String chatroomId = getChatroomId(searchResult.userEmail.trim(), myEmail);
    var recieverEmail = searchResult.userEmail.trim();
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
            chatroomName: searchResult.userEmail,
          ),
        ));
  }
}
