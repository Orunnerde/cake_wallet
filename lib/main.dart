import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cake_wallet/router.dart';
import 'package:cake_wallet/src/user_service.dart';
import 'package:cake_wallet/src/bloc/authentication/authentication.dart';
import 'package:cake_wallet/src/screens/welcome/welcome.dart';
import 'package:cake_wallet/src/screens/splash/splash.dart';
import 'package:cake_wallet/src/screens/login/login.dart';

void main() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(BlocProvider<AuthenticationBloc>(
      builder: (context) {
        return AuthenticationBloc(
            userService: UserService(
                secureStorage: FlutterSecureStorage(),
                sharedPreferences: sharedPreferences))
          ..dispatch(AppStarted());
      },
      child: CakeWalletApp(sharedPreferences: sharedPreferences)));
}

class CakeWalletApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  CakeWalletApp({this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.white,
    ));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
        ),
        onGenerateRoute: (settings) =>
            Router.generateRoute(sharedPreferences, settings),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUninitialized) {
              return Splash();
            }
            if (state is AuthenticationAuthenticated) {
              return Container();
            }
            if (state is AuthenticationDenied) {
              return Welcome();
            }
            if (state is AuthenticationAllowed) {
              return LoginScreen(
                  userService: UserService(
                      sharedPreferences: sharedPreferences,
                      secureStorage: FlutterSecureStorage()));
            }
          },
        ));
  }
}
