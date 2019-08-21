import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserEvent extends Equatable {
  UserEvent([List props = const <dynamic>[]]) : super(props);
}

class SetPinCode extends UserEvent {
  String pin;

  SetPinCode({@required this.pin}) : super([pin]);
}

class AppStarted extends UserEvent {}

class LoggedIn extends UserEvent {
  final String token;

  LoggedIn({@required this.token}) : super([token]);
}

class LoggedOut extends UserEvent {}