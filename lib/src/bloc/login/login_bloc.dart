import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cake_wallet/src/bloc/authentication/authentication.dart';
import 'package:cake_wallet/src/user_service.dart';
import './login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService userService;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({this.userService, this.authenticationBloc});

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SignIn) {
      yield LoginLoading();

      try {
        final isAuth = await userService.authenticate(event.password);

        if (isAuth) {
          authenticationBloc.dispatch(LoggedIn(password: event.password));
        } else {
          yield LoginFailure(error: 'Incorrect password');  
        }
        
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
