part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchPressedEvent extends SearchEvent {}

// ignore: must_be_immutable
class AddToChatroomPressedEvent extends SearchEvent {
  User searchResult;
  AddToChatroomPressedEvent(this.searchResult);
}
