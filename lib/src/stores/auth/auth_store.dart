import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';
import 'package:cake_wallet/src/stores/auth/auth_state.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  static const maxFailedLogins = 3;
  static const banTimeout = 180; // 3 mins
  static const banTimeoutKey = 'ban_timeout';

  final AuthenticationStore authStore;
  final UserService userService;
  final WalletService walletService;
  final WalletListService walletsService;
  final SharedPreferences sharedPreferences;

  @observable
  AuthState state;

  @observable
  int _failureCounter;

  AuthStoreBase(
      {@required this.authStore,
      @required this.userService,
      @required this.walletService,
      @required this.walletsService,
      @required this.sharedPreferences}) {
    state = AuthenticationStateInitial();
    _failureCounter = 0;
  }

  @action
  Future auth({String password}) async {
    state = AuthenticationStateInitial();
    final _banDuration = banDuration();
    
    if (_banDuration != null) {
        state = AuthenticationBanned(error: 'Banned for ${_banDuration.inMinutes} minuts');
        return;
    }

    final isAuth = await userService.authenticate(password);

    if (isAuth) {
      state = AuthenticationInProgress();
      final walletName = sharedPreferences.getString('current_wallet_name');
      await walletsService.openWallet(walletName);
      authStore.loggedIn();
      state = AuthenticatedSuccessfully();
      _failureCounter = 0;
    } else {
      _failureCounter += 1;

      if (_failureCounter >= maxFailedLogins) {
        final banDuration = await ban();
        state = AuthenticationBanned(error: 'Banned for ${banDuration.inMinutes} minuts');
        return;
      }

      state = AuthenticationFailure(error: 'Incorrect password');
    }
  }

  Duration banDuration() {
    final unbanTimestamp = sharedPreferences.getInt(banTimeoutKey);

    if (unbanTimestamp == null) {
      return null;
    }

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
