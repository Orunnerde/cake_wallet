import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cake_wallet/src/bloc/login/login.dart';
import 'package:cake_wallet/src/bloc/authentication/authentication.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';

import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';

class LoginScreen extends StatelessWidget {
  final UserService userService;
  final SharedPreferences sharedPreferences;
  final WalletListService walletsService;
  final WalletService walletService;

  LoginScreen(
      {@required this.userService,
      @required this.sharedPreferences,
      @required this.walletsService,
      @required this.walletService});

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
                  walletService: walletService,
                  walletsService: walletsService,
                  sharedPreferences: sharedPreferences);
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

          if (state is LoginWalletLoading) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Loading your wallet'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: body(context));
  }
}
