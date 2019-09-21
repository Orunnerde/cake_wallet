import 'dart:async';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

enum LoginState { initial, loading, loggedInt, failure }

abstract class LoginStoreBase with Store {
  final AuthenticationStore authStore;
  final UserService userService;
  final WalletService walletService;
  final WalletListService walletsService;
  final SharedPreferences sharedPreferences;

  @observable
  LoginState state;

  @observable
  String errorMessage;

  LoginStoreBase(
      {@required this.authStore,
      @required this.userService,
      @required this.walletService,
      @required this.walletsService,
      @required this.sharedPreferences}) {
    state = LoginState.initial;
  }

  Future auth({String password}) async {
    state = LoginState.initial;
    final isAuth = await userService.authenticate(password);

    if (isAuth) {
      state = LoginState.loading;
      final walletName = sharedPreferences.getString('current_wallet_name');
      await walletsService.openWallet(walletName);
      authStore.loggedIn();
      state = LoginState.loggedInt;
    } else {
      state = LoginState.failure;
      errorMessage = 'Incorrect password';
    }
  }
}
