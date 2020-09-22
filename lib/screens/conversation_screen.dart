import 'package:firebase_chat_app/bloc/conversation/conversation_bloc.dart';
import 'package:firebase_chat_app/models/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationScreen extends StatefulWidget {
  final String chatroomId;
  final String chatroomName;

  const ConversationScreen({Key key, this.chatroomId, this.chatroomName})
      : super(key: key);
  @override
  _ConversationScreenState createState() =>
      _ConversationScreenState(chatroomId, chatroomName);
}

class _ConversationScreenState extends State<ConversationScreen> {
  ConversationBloc bloc;
  final String chatroomId;
  final String chatroomName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  _ConversationScreenState(this.chatroomId, this.chatroomName);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConversationBloc>(
      create: (context) => ConversationBloc(chatroomId),
      child: ConversationPage(chatroomName: chatroomName),
    );
  }

  Widget chatMessageListView() {
    return Expanded(
      child: StreamBuilder<ConversationModel>(
          // stream: bloc./,
          builder: (context, snapshot) {
        return ListView.separated(
            itemBuilder: null,
            separatorBuilder: (context, index) => Divider(),
            itemCount: null);
      }),
    );
  }
}

// ignore: must_be_immutable
class ConversationPage extends StatelessWidget {
  ConversationPage({
    @required this.chatroomName,
  });

  final String chatroomName;
  ConversationBloc bloc;

  //chat list widget
  Widget messageTile(String message, bool isSendByMe) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      alignment: isSendByMe ? Alignment.centerLeft : Alignment.centerRight,
      decoration: BoxDecoration(
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                  topRight: Radius.circular(23))
              : BorderRadius.only(
                  bottomLeft: Radius.circular(23),
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23)),
          gradient: LinearGradient(
              colors: isSendByMe
                  ? [Colors.blue, Colors.blue[300]]
                  : [Colors.blue, Colors.blue])),
      child: Text(
        message == null ? '' : message,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(chatroomName),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 80),
              alignment: Alignment.topCenter,
              child: StreamBuilder<List<ConversationModel>>(
                  stream: bloc.messagesList,
                  builder: (context, snapshot) {
                    var messagesList = snapshot.data;
                    return ListView.separated(
                      itemCount: messagesList != null ? messagesList.length : 0,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            child: Row(
                              children: <Widget>[
                                messageTile(
                                  messagesList[index].message,
                                  messagesList[index].isSendByMe,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<String>(
                      stream: bloc.message,
                      builder: (context, snapshot) => TextField(
                          onChanged: bloc.messasgeChanged,
                          controller: bloc.messageController,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            hintText: 'Message...',
                            border: OutlineInputBorder(),
                          )),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      bloc.add(SendPressedEvent());
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
