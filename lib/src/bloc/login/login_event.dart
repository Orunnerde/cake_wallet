import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const <dynamic>[]]) : super(props);
}

class SignIn extends LoginEvent {
  final String password;

  SignIn({
    @required this.password,
  }) : super([password]);

}