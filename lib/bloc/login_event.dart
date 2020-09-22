part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginPressedEvent extends LoginEvent {}

class ResetPressedEvent extends LoginEvent {}

class SignUpPressedEvent extends LoginEvent {}
