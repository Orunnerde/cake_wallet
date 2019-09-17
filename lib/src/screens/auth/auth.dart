import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/screens/dashboard/sync_info.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';

class Auth extends StatelessWidget {
  final _key = GlobalKey<ScaffoldState>();
  Function(Auth) onAuthenticationSuccessful;
  Function(Auth) onAuthenticationFailed;

  Auth({this.onAuthenticationSuccessful, this.onAuthenticationFailed});

  void changeProcessText(String text) {
    print(text);
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
    return Scaffold(
        key: _key,
        appBar: CupertinoNavigationBar(
          leading: CloseButton(),
          backgroundColor: Colors.white,
          border: null,
        ),
        body: Consumer<AuthInfo>(builder: (context, authInfo, child) {
          if (authInfo.state == AuthState.AUTHENTICATED) {
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

          if (authInfo.state == AuthState.AUTHENTICATION) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Authentication'),
                  backgroundColor: Colors.green,
                ),
              );
            });
          }

          if (authInfo.state == AuthState.FAILED_AUTHENTICATION) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (onAuthenticationSuccessful != null) {
                onAuthenticationFailed(this);
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed authentication. Wrong password'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            });
          }

          return PinCode(
              (pin, _) =>
                  authInfo.auth(pin: pin.fold("", (ac, val) => ac + '$val')),
              false);
        }));
  }
}
