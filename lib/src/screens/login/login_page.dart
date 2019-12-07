import 'package:cake_wallet/src/stores/auth/auth_state.dart';
import 'package:cake_wallet/src/stores/login/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/stores/auth/auth_store.dart';

class LoginPage extends BasePage {
  @override
  Widget leading(BuildContext context) => Container();

  @override
  Widget body(BuildContext context) => _LoginPinCode();
}

class _LoginPinCode extends PinCode {
  _LoginPinCode([Key key]) : super((_, __) => null, false, key);

  @override
  _LoginPinCodeState createState() => _LoginPinCodeState();
}

class _LoginPinCodeState extends PinCodeState<_LoginPinCode> {
  AuthStore _authStore;
  String title = 'Enter your PIN';

  @override
  Future onPinCodeEntered(PinCodeState state) async {
    final password = pin.fold("", (ac, val) => ac + '$val');

    await _authStore.auth(password: password);
    super.onPinCodeEntered(state);
  }

  @override
  Widget build(BuildContext context) {
    _setAuthStore(store: Provider.of<AuthStore>(context));
    return body(context);
  }

  void _setAuthStore({AuthStore store}) {
    if (_authStore != null) {
      return;
    }

    _authStore = store;

    reaction((_) => _authStore.state, (state) {
      print('CHANGED STATE $state');
      // if (state is AuthenticationFailure) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     clear();
      //     Scaffold.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(state.error),
      //         backgroundColor: Colors.red,
      //       ),
      //     );
      //   });
      // }

      // if (state is AuthenticationBanned) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     clear();
      //     Scaffold.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(state.error),
      //         backgroundColor: Colors.red,
      //       ),
      //     );
      //   });
      // }

      // if (state is AuthenticationInProgress) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     Scaffold.of(context).hideCurrentSnackBar();
      //     Scaffold.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text('Authentication'),
      //         backgroundColor: Colors.green,
      //       ),
      //     );
      //   });
      // }
    });

    // reaction((_) => _loginStore.state, (state) {
    //   if (state is LoadedCurrentWalletFailure) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       clear();
    //       Scaffold.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(state.errorMessage),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //     });
    //   }

    //   if (state is LoadingCurrentWallet) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       Scaffold.of(context).hideCurrentSnackBar();
    //       Scaffold.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('Loading your wallet'),
    //           backgroundColor: Colors.green,
    //         ),
    //       );
    //     });
    //   }
    // });
  }
}
