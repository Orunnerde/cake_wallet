import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/stores/auth/auth_state.dart';
import 'package:cake_wallet/src/stores/auth/auth_store.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';

part 'login_store.g.dart';

abstract class LoginState {}

class InitialLoginState extends LoginState {}

class LoadingCurrentWallet extends LoginState {}

class LoadedCurrentWalletSuccessfully extends LoginState {}

class LoadedCurrentWalletFailure extends LoginState {
  final String errorMessage;

  LoadedCurrentWalletFailure({this.errorMessage});
}

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final AuthenticationStore authenticationStore;
  final AuthStore authStore;
  final SharedPreferences sharedPreferences;
  final WalletListService walletsService;

  @observable
  LoginState state;

  LoginStoreBase(
      {@required this.authenticationStore,
      @required this.authStore,
      @required this.sharedPreferences,
      @required this.walletsService}) {
    state = InitialLoginState();
    reaction((_) => authStore.state, (state) async {
      if (state is AuthenticatedSuccessfully) {
        await loadCurrentWallet();
      }
    });
  }

  @action
  Future loadCurrentWallet() async {
    state = InitialLoginState();

    try {
      state = LoadingCurrentWallet();
      final walletName = sharedPreferences.getString('current_wallet_name');
      await walletsService.openWallet(walletName);
      authenticationStore.loggedIn();
      state = LoadedCurrentWalletSuccessfully();
    } catch (e) {
      state = LoadedCurrentWalletFailure(errorMessage: e.toString());
    }
  }
}
