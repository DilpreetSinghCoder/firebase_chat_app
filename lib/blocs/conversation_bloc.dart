import 'package:firebase_chat_app/blocs/base_bloc.dart';
import 'package:firebase_chat_app/helpers/helper_functions.dart';
import 'package:firebase_chat_app/models/conversation_model.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ConversationBloc implements BaseBloc {
  final String chatroomId;

  ConversationBloc(this.chatroomId);

  final _conversationController = BehaviorSubject<List<ConversationModel>>();
  Stream<List<ConversationModel>> get conversation async* {
    var result = await _database.getConversationMessages(chatroomId);
    yield result;
  }

  final _messagesListController = BehaviorSubject<List<ConversationModel>>();
  Stream<List<ConversationModel>> get messagesList =>
      _messagesListController.stream;

  DatabaseService _database = DatabaseService();
  final _messageController = BehaviorSubject<String>();
  final messageController = TextEditingController();

  get messasgeChanged => _messageController.sink.add;

  Stream<String> get message => _messageController.stream;
  List<ConversationModel> list = List<ConversationModel>();

  sendMessage() async {
    String sendby = await HelperFunctions.getUserEmailSharedPrefernece();
    Map<String, String> messageMap = {
      'message': _messageController.value,
      'sendby': sendby,
      'time': DateTime.now().millisecondsSinceEpoch.toString()
    };
    messageController.clear();
    _database.addConversationMessages(chatroomId, messageMap);
    list.add(new ConversationModel(
      sendby,
      _messageController.value,
      DateTime.now().millisecondsSinceEpoch.toString(),
    ));
    // _messagesListController.add(list);
    var tt = await _database.getConversationMessages(chatroomId);
    _messagesListController.add(tt);
    // print(tt);
  }

  void updateConversation() async {
    var tt = await _database.getConversationMessages(chatroomId);
    _messagesListController.add(tt);
  }

  @override
  void dispose() {
    _messageController.close();
    _conversationController.close();
    _messagesListController.close();
  }
}
