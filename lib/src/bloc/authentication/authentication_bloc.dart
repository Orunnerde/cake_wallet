import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import './authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserService userService;

  AuthenticationBloc({this.userService});

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final canAuth = await userService.canAuthenticate();

      if (canAuth) {
        yield AuthenticationAllowed();
      } else {
        yield AuthenticationDenied();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationUnauthenticated();
    }
  }
}
