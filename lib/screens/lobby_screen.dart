import 'package:firebase_chat_app/bloc/lobby/lobby_bloc.dart';
import 'package:firebase_chat_app/models/chatroom_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyScreen extends StatefulWidget {
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LobbyBloc>(
      create: (context) => LobbyBloc(context),
      child: LobbyPage(),
    );
  }
}

class LobbyPage extends StatelessWidget {
  LobbyBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<LobbyBloc>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                bloc.add(LogoutPressedEvent());
              },
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
        title: Text('Lobby'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: bloc.chatroomList,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List<ChatroomModel> list = snapshot.data;

                      bloc.chatroomId = list[index].chatroomId;
                      return ChatroomTile(
                        name: list[index].userName,
                        onTap: () {
                          bloc.add(OpenConversationPressedEvent(
                              list[index].name, list[index].chatroomId));
                        },
                      );
                    },
                  )
                : Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          bloc.add(SearchPressedEvent());
        },
      ),
    );
  }
}

class ChatroomTile extends StatelessWidget {
  final String name;
  final Function onTap;

  const ChatroomTile({Key key, this.name, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.person),
        title: Text(name),
      ),
    );
  }
}
