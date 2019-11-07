import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/stores/wallet_creation/wallet_creation_state.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';

part 'wallet_creation_store.g.dart';

class WalletCreationStore = WalletCreationStoreBase with _$WalletCreationStore;

abstract class WalletCreationStoreBase with Store {
  final AuthenticationStore authStore;
  final WalletListService walletListService;
  final SharedPreferences sharedPreferences;

  @observable
  WalletCreationState state;

  @observable
  String errorMessage;

  WalletCreationStoreBase( 
      {@required this.authStore,
      @required this.walletListService,
      @required this.sharedPreferences}) {
    state = WalletCreationStateInitial();
  }

  @action
  Future create({String name}) async {
    state = WalletCreationStateInitial();

    try {
      state = WalletIsCreating();
      await walletListService.create(name);
      authStore.created();
      state = WalletCreatedSuccessfully();
    } catch (e) {
      state = WalletCreationFailure(error: e.toString());
    }
  }
}
