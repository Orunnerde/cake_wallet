import 'dart:async';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:cake_wallet/src/bloc/authentication/authentication.dart';

import './login.dart';
// import 'package:cake_wallet/src/screens/dashboard/sync_info.dart';

// import 'package:cake_wallet/src/user_service.dart';
// import 'package:cake_wallet/src/wallets_service.dart';
// import '../../monero_wallet.dart';

import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
// import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';

// final wallet = MoneroWallet();

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService userService;
  final AuthenticationBloc authenticationBloc;
  final WalletService walletService;
  final WalletListService walletsService;
  final SharedPreferences sharedPreferences;

  LoginBloc(
      {@required this.userService,
      @required this.authenticationBloc,
      @required this.walletService,
      @required this.walletsService,
      @required this.sharedPreferences});

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SignIn) {
      yield LoginLoading();

      try {
        final isAuth = await userService.authenticate(event.password);

        if (isAuth) {
          final walletName = sharedPreferences.getString('current_wallet_name');
          await walletsService.openWallet(walletName);

          await walletService.connectToNode(
              uri: 'node.moneroworld.com:18089',
              login: '',
              password: '');
          await walletService.startSync();
          authenticationBloc.dispatch(LoggedIn(password: event.password));
        } else {
          yield LoginFailure(error: 'Incorrect password');
        }

        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
