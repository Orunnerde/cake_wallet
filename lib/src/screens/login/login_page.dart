import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';
import 'package:cake_wallet/src/stores/login/login_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class LoginPage extends BasePage {
  final UserService userService;
  final SharedPreferences sharedPreferences;
  final WalletListService walletsService;
  final WalletService walletService;

  LoginPage(
      {@required this.userService,
      @required this.sharedPreferences,
      @required this.walletsService,
      @required this.walletService});

  @override
  Widget body(BuildContext context) => _LoginPinCode();
}

class _LoginPinCode extends PinCode {
  _LoginPinCode() : super((_, __) => null, false);

  @override
  _LoginPinCodeState createState() => _LoginPinCodeState();
}

class _LoginPinCodeState extends PinCodeState<_LoginPinCode> {
  LoginStore _loginStore;
  String title = 'Enter your PIN';

  @override
  Future onPinCodeEntered(PinCodeState state) async {
    final password = pin.fold("", (ac, val) => ac + '$val');

    await _loginStore.auth(password: password);
    super.onPinCodeEntered(state);
  }

  @override
  Widget build(BuildContext context) {
    _setLoginStore(store: Provider.of<LoginStore>(context));
    return body(context);
  }

  void _setLoginStore({LoginStore store}) {
    if (_loginStore != null) {
      return;
    }

    _loginStore = store;

    reaction((_) => _loginStore.state, (state) {
      if (state == LoginState.failure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          clear();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(_loginStore.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        });
      }

      if (state == LoginState.loading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Loading your wallet'),
              backgroundColor: Colors.green,
            ),
          );
        });
      }
    });
  }
}
