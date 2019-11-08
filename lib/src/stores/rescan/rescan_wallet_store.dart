import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';

part 'rescan_wallet_store.g.dart';

class RescanWalletStore = RescanWalletStoreBase with _$RescanWalletStore;

enum RescanWalletState {
  rescaning, none
}

abstract class RescanWalletStoreBase with Store {
  @observable
  RescanWalletState state;

  WalletListService _walletListService;

  RescanWalletStoreBase({@required WalletListService walletListService}) {
    _walletListService = walletListService;
    state = RescanWalletState.none;
  }

  @action
  Future rescanCurrentWallet({int restoreHeight}) async {
    state = RescanWalletState.rescaning;
    await _walletListService.rescanCurrentWallet(restoreHeight: restoreHeight);
    state = RescanWalletState.none;
  }
}
