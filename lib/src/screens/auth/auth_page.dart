import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/stores/auth/auth_state.dart';
import 'package:cake_wallet/src/stores/auth/auth_store.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class AuthPage extends StatelessWidget {
  final _key = GlobalKey<ScaffoldState>();
  final Function(AuthPage) onAuthenticationSuccessful;
  final Function(AuthPage) onAuthenticationFailed;

  AuthPage({this.onAuthenticationSuccessful, this.onAuthenticationFailed});

  void changeProcessText(String text) {
    _key.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.green,
      ),
    );
  }

  void close() {
    Navigator.of(_key.currentContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    reaction((_) => authStore.state, (state) {
      if (state is AuthenticatedSuccessfully) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (onAuthenticationSuccessful != null) {
            onAuthenticationSuccessful(this);
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Authenticated'),
                backgroundColor: Colors.green,
              ),
            );
          }
        });
      }

      if (state is AuthenticationInProgress) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Authentication'),
              backgroundColor: Colors.green,
            ),
          );
        });
      }

      if (state is AuthenticationFailure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (onAuthenticationSuccessful != null) {
            onAuthenticationFailed(this);
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed authentication. ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    });

    return Scaffold(
        key: _key,
        appBar: CupertinoNavigationBar(
          leading: CloseButton(),
          backgroundColor: _isDarkTheme ? Theme.of(context).backgroundColor : Colors.white,
          border: null,
        ),
        body: PinCode(
            (pin, _) =>
                authStore.auth(pin: pin.fold("", (ac, val) => ac + '$val')),
            false));
  }
}
