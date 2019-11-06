import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

enum LoginState { initial, loading, loggedInt, failure, banned }

abstract class LoginStoreBase with Store {
  static const maxFailedLogins = 3;
  static const banTimeout = 180; // 3 mins
  static const banTimeoutKey = 'ban_timeout';

  final AuthenticationStore authStore;
  final UserService userService;
  final WalletService walletService;
  final WalletListService walletsService;
  final SharedPreferences sharedPreferences;

  @observable
  LoginState state;

  @observable
  String errorMessage;

  @observable
  int _failureCounter;

  LoginStoreBase(
      {@required this.authStore,
      @required this.userService,
      @required this.walletService,
      @required this.walletsService,
      @required this.sharedPreferences}) {
    state = LoginState.initial;
    _failureCounter = 0;
  }

  Future auth({String password}) async {
    state = LoginState.initial;
    final _banDuration = banDuration();
    
    if (_banDuration != null) {
        errorMessage = 'Banned for ${_banDuration.inMinutes} minuts';
        state = LoginState.banned;
        return;
    }

    final isAuth = await userService.authenticate(password);

    if (isAuth) {
      state = LoginState.loading;
      final walletName = sharedPreferences.getString('current_wallet_name');
      await walletsService.openWallet(walletName);
      authStore.loggedIn();
      state = LoginState.loggedInt;
      _failureCounter = 0;
    } else {
      _failureCounter += 1;

      if (_failureCounter >= maxFailedLogins) {
        final banDuration = await ban();
        errorMessage = 'Banned for ${banDuration.inMinutes} minuts';
        state = LoginState.banned;
        return;
      }

      errorMessage = 'Incorrect password';
      state = LoginState.failure;
    }
  }

  Duration banDuration() {
    final unbanTimestamp = sharedPreferences.getInt(banTimeoutKey);
    final unbanTime = DateTime.fromMillisecondsSinceEpoch(unbanTimestamp);
    final now = DateTime.now();

    if (now.isAfter(unbanTime)) {
      return null;
    }

    return Duration(milliseconds: unbanTimestamp - now.millisecondsSinceEpoch);
  }

  Future<Duration> ban() async {
    final multiplier = _failureCounter - maxFailedLogins + 1;
    final timeout = (multiplier * banTimeout) * 1000;
    final unbanTimestamp = DateTime.now().millisecondsSinceEpoch + timeout;
    await sharedPreferences.setInt(banTimeoutKey, unbanTimestamp);
    
    return Duration(milliseconds: timeout);
  }
}
