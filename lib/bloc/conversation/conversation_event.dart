part of 'conversation_bloc.dart';

@immutable
abstract class ConversationEvent {}

class SendPressedEvent extends ConversationEvent {}
