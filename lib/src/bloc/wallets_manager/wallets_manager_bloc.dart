import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/bloc/wallets_manager/wallets_manager_state.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import './wallets_manager.dart';

class WalletsManagerBloc
    extends Bloc<WalletsManagerEvent, WalletsManagerState> {
  final WalletListService walletsService;
  final WalletService walletService;
  final SharedPreferences sharedPreferences;

  WalletsManagerBloc(
      {@required this.walletsService,
      @required this.walletService,
      @required this.sharedPreferences});

  @override
  WalletsManagerState get initialState => WalletsManagerStateInitial();

  @override
  Stream<WalletsManagerState> mapEventToState(
    WalletsManagerEvent event,
  ) async* {
    if (event is CreateWallet) {
      yield CreatingWallet();

      try {
        await walletsService.create(event.name);
        yield WalletCreatedSuccessfully();
      } catch (e) {
        yield WalletCreatedFailed(e.toString());
      }
    }

    if (event is RestoreFromSeedWallet) {
      yield CreatingWallet();

      try {
        await walletsService.restoreFromSeed(
            event.name, event.seed, event.restoreHeight);
        yield WalletCreatedSuccessfully();
      } catch (e) {
        yield WalletCreatedFailed(e.toString());
      }
    }

    if (event is RestoreFromKeysWallet) {
      yield CreatingWallet();

      try {
        await walletsService.restoreFromKeys(event.name, event.restoreHeight,
            event.address, event.viewKey, event.spendKey);
        yield WalletCreatedSuccessfully();
      } catch (e) {
        yield WalletCreatedFailed(e.toString());
      }
    }
  }
}
