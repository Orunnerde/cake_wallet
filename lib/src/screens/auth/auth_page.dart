import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/stores/auth/auth_state.dart';
import 'package:cake_wallet/src/stores/auth/auth_store.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class AuthPage extends StatefulWidget {
  final Function(bool, AuthPage, BuildContext) onAuthenticationFinished;
  final bool closable;

  AuthPage({this.onAuthenticationFinished, this.closable = true});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final _key = GlobalKey<ScaffoldState>();
  final _pinCodeKey = GlobalKey<PinCodeState>();

  void changeProcessText(String text) {
    _key.currentState.showSnackBar(
        SnackBar(content: Text(text), backgroundColor: Colors.green));
  }

  void close() => Navigator.of(_key.currentContext).pop();

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context);
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    reaction((_) => authStore.state, (state) {
      if (state is AuthenticatedSuccessfully) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.onAuthenticationFinished != null) {
            widget.onAuthenticationFinished(true, widget, context);
          } else {
            _key.currentState.showSnackBar(
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
          _key.currentState.showSnackBar(
            SnackBar(
              content: Text('Authentication'),
              backgroundColor: Colors.green,
            ),
          );
        });
      }

      if (state is AuthenticationFailure || state is AuthenticationBanned) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pinCodeKey.currentState.clear();
          _key.currentState.showSnackBar(
            SnackBar(
              content: Text('Failed authentication. ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );

          if (widget.onAuthenticationFinished != null) {
            widget.onAuthenticationFinished(false, widget, context);
          }
        });
      }
    });

    return Scaffold(
        key: _key,
        appBar: CupertinoNavigationBar(
          leading: widget.closable ? CloseButton() : Container(),
          backgroundColor:
              _isDarkTheme ? Theme.of(context).backgroundColor : Colors.white,
          border: null,
        ),
        body: PinCode(
            (pin, _) => authStore.auth(
                password: pin.fold('', (ac, val) => ac + '$val')),
            false,
            _pinCodeKey));
  }
}
