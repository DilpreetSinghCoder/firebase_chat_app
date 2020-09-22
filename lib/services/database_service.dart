import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/models/chatroom_model.dart';
import 'package:firebase_chat_app/models/conversation_model.dart';
import 'package:firebase_chat_app/models/user_model.dart';

class DatabaseService {
  getUserByUserName(String name) async {
    return await Firestore.instance
        .collection('email')
        .where('name', isEqualTo: name)
        .getDocuments()
        .then((value) => value);
  }

  getUserByEmail(String userEmail) async {
    // QuerySnapshot snapshot;

    var result = await Firestore.instance
        .collection('email')
        .getDocuments()
        .then((value) => value.documents
            .map((element) => User(
                  userName: element.data.values.first,
                  userEmail: element.data.values.skip(1).first,
                  userId: element.documentID,
                ))
            .toList());
    return result
        .where((element) => element.userEmail.trim() == userEmail)
        .toList();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection('email').add(userMap);
  }

  createChatroom(String chatroomId, chatroomMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .setData(chatroomMap)
        .catchError((e) => {print(e.toString())});
  }

  addConversationMessages(String chatroomId, messageMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .collection('chats')
        .add(messageMap);
  }

  Future<List<ConversationModel>> getConversationMessages(
      String chatroomId) async {
    var result = await Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .getDocuments();
    List<ConversationModel> list = result.documents
        .map(
          (e) => new ConversationModel(e.data.values.skip(2).toString(),
              e.data.values.skip(1).first, e.data.values.first),
        )
        .toList();
    return list;
  }

  Future<List<ChatroomModel>> getChatRooms(String userEmail) async {
    var result = await Firestore.instance
        .collection('chatroom')
        .where('users', arrayContains: userEmail)
        .getDocuments();

    var list = result.documents
        .map((e) => ChatroomModel(
              e.data.values.first.first == userEmail
                  ? e.data.values.first[1]
                  : e.data.values.first.first,
              e.documentID,
              e.data.values.first.first == userEmail
                  ? e.data.values.first[1]
                  : e.data.values.first.first,
            ))
        .toList();
    return list;
  }
}
