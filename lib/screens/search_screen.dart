import 'package:firebase_chat_app/bloc/search/search_bloc.dart';
import 'package:firebase_chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  final Function onTap;

  const SearchTile({Key key, this.userName, this.userEmail, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        title: Text(userName ?? ''),
        leading: Icon(Icons.people),
        subtitle: Text(userEmail ?? ''),
        trailing: Icon(Icons.add),
        onTap: onTap,
      ),
    );
  }
}

// var _searchBloc = kiwi.KiwiContainer().resolve<SearchBloc>();
ScrollController _scrollController = ScrollController();
@override
void dispose() {
  _scrollController.dispose();
}

List<User> sList = List<User>();

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = SearchBloc(context);
    return BlocProvider(
      create: (context) => SearchBloc(context),
      child: SearchPage(),
    );
  }
}

class SearchPage extends StatelessWidget {
  SearchBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<SearchBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<String>(
                      stream: bloc.search,
                      builder: (context, snapshot) => TextField(
                          onChanged: bloc.searchChanged,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            hintText: 'Search username...',
                            border: OutlineInputBorder(),
                          )),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      bloc.add(SearchPressedEvent());
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder<List<User>>(
                    stream: bloc.searchResult,
                    builder: (context, snapshot) {
                      var searchResult = snapshot.data;
                      return ListView.separated(
                        itemCount:
                            searchResult != null ? searchResult.length : 0,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Container(
                              child: Row(
                                children: <Widget>[
                                  SearchTile(
                                    userEmail: searchResult[index].userEmail,
                                    userName: searchResult[index].userName,
                                    onTap: () => {
                                      bloc
                                        ..add(AddToChatroomPressedEvent(
                                            searchResult[index]))
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
