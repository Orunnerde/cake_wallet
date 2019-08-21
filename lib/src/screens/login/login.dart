import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';
import 'package:cake_wallet/src/bloc/login/login.dart';
import 'package:cake_wallet/src/bloc/authentication/authentication.dart';
import 'package:cake_wallet/src/user_service.dart';

class LoginScreen extends StatelessWidget {
  final UserService userService;

  LoginScreen({this.userService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider(
            builder: (context) {
              return LoginBloc(
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                userService: userService,
              );
            },
            child: _LoginPinCode()));
  }
}

class _LoginPinCode extends PinCode {
  _LoginPinCode() : super((_, __) {});

  @override
  _LoginPinCodeState createState() => _LoginPinCodeState();
}

class _LoginPinCodeState extends PinCodeState<_LoginPinCode> {
  LoginBloc _loginBloc;
  String title = 'Enter your PIN';

  @override
  void onPinCodeEntered(PinCodeState state) {
    final password = pin.fold("", (ac, val) => ac + '$val');

    _loginBloc.dispatch(SignIn(password: password));
    super.onPinCodeEntered(state);
  }

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            clear();

            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: body(context));
  }
}
