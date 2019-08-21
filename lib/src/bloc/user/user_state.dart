import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserState extends Equatable {
  UserState([List props = const <dynamic>[]]) : super(props);
}

class UserStateInitial extends UserState {}
class PinCodeSetSuccesfully extends UserState {}

class PinCodeSetFailed extends UserState {
  String msg;

  PinCodeSetFailed({@required this.msg}) : super([msg]);
}


class AuthenticationUninitialized extends UserState {}
class AuthenticationAuthenticated extends UserState {}
class AuthenticationUnauthenticated extends UserState {}
class AuthenticationLoading extends UserState {}