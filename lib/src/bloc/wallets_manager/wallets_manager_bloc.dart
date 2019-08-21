import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/wallets_service.dart';
import 'package:cake_wallet/src/bloc/wallets_manager/wallets_manager_state.dart';
import './wallets_manager.dart';

class WalletsManagerBloc
    extends Bloc<WalletsManagerEvent, WalletsManagerState> {
  final WalletsService walletsService;
  final SharedPreferences sharedPreferences;

  WalletsManagerBloc({this.walletsService, this.sharedPreferences});

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
        sharedPreferences.setString('current_wallet_name', event.name);
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
        sharedPreferences.setString('current_wallet_name', event.name);
        yield WalletCreatedSuccessfully();
      } catch (e) {
        yield WalletCreatedFailed(e.toString());
      }
    }
  }
}
