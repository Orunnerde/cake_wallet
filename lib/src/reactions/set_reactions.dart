import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/start_updating_price.dart';
import 'package:cake_wallet/src/stores/sync/sync_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/stores/price/price_store.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';
import 'package:cake_wallet/src/stores/login/login_store.dart';

setReactions(
    {@required SettingsStore settingsStore,
    @required PriceStore priceStore,
    @required SyncStore syncStore,
    @required WalletStore walletStore,
    @required WalletService walletService,
    @required AuthenticationStore authenticationStore,
    @required LoginStore loginStore}) {
  connectToNode(settingsStore: settingsStore, walletStore: walletStore);
  onSyncStatusChange(syncStore: syncStore, walletStore: walletStore);
  onCurrentWalletChange(
      walletStore: walletStore,
      settingsStore: settingsStore,
      priceStore: priceStore);
  autorun((_) async {
    if (authenticationStore.state == AuthenticationState.allowed) {
      loginStore.loadCurrentWallet();
    }
  });
}

connectToNode({SettingsStore settingsStore, WalletStore walletStore}) =>
    reaction((_) => settingsStore.node,
        (node) async => await walletStore.connectToNode(node: node));

onSyncStatusChange({SyncStore syncStore, WalletStore walletStore}) =>
    reaction((_) => syncStore.status, (status) {
      if (status is ConnectedSyncStatus) {
        walletStore.startSync();
      }

      // Reconnect to the node if the app is not started sync after 30 seconds
      if (status is StartingSyncStatus) {
        Timer(Duration(seconds: 30), () async {
          final isConnected = await walletStore.isConnected();

          if (syncStore.status is StartingSyncStatus && !isConnected) {
            walletStore.reconnect();
          }
        });
      }
    });

onCurrentWalletChange(
        {WalletStore walletStore,
        SettingsStore settingsStore,
        PriceStore priceStore}) =>
    reaction((_) => walletStore.name, (_) {
      walletStore.connectToNode(node: settingsStore.node);
      startUpdatingPrice(settingsStore: settingsStore, priceStore: priceStore);
    });
