part of 'lobby_bloc.dart';

@immutable
abstract class LobbyEvent {}

class LogoutPressedEvent extends LobbyEvent {}

class SearchPressedEvent extends LobbyEvent {}

// ignore: must_be_immutable
class OpenConversationPressedEvent extends LobbyEvent {
  String name;
  String chatroomId;
  OpenConversationPressedEvent(this.name, this.chatroomId);
}
