import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_chat_app/helpers/helper_functions.dart';
import 'package:firebase_chat_app/models/conversation_model.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc(this.chatroomId) : super(ConversationInitial()) {
    updateConversation();
  }
  final String chatroomId;

  final _conversationController = BehaviorSubject<List<ConversationModel>>();
  Stream<List<ConversationModel>> get conversation async* {
    var result = await _database.getConversationMessages(chatroomId);
    yield result;
  }

  void updateConversation() async {
    var tt = await _database.getConversationMessages(chatroomId);
    _messagesListController.add(tt);
  }

  Stream<List<ConversationModel>> get messagesList =>
      _messagesListController.stream;
  final _messagesListController = BehaviorSubject<List<ConversationModel>>();

  DatabaseService _database = DatabaseService();
  final _messageController = BehaviorSubject<String>();
  final messageController = TextEditingController();

  get messasgeChanged => _messageController.sink.add;

  Stream<String> get message => _messageController.stream;
  List<ConversationModel> list = List<ConversationModel>();
  @override
  Stream<ConversationState> mapEventToState(
    ConversationEvent event,
  ) async* {
    if (event is SendPressedEvent) {
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
    }
  }

  void dispose() {
    _messageController.close();
    _conversationController.close();
    _messagesListController.close();
  }
}
