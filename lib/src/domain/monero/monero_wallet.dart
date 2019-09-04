import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/common/pending_transaction.dart';
import 'package:cake_wallet/src/domain/monero/monero_transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/monero/monero_transaction_history.dart';

const moneroBlockSize = 1000;

class MoneroWallet extends Wallet {
  static const platform =
      const MethodChannel('com.cakewallet.wallet/monero-wallet');

  static const syncStateChannel =
      BasicMessageChannel('sync_state', StringCodec());

  static const walletHeightChannel =
      BasicMessageChannel('wallet_height', StringCodec());

  static const balanceChangeChannel =
      BasicMessageChannel('balance_change', StringCodec());

  static Future<T> getValue<T>({String key, Map arguments = const {}}) async {
    try {
      return await platform.invokeMethod(key, arguments);
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Function(int height) onHeightChange;
  Function(Wallet wallet) onBalanceChange;

  get syncStatus => _syncStatus.stream;
  BehaviorSubject<SyncStatus> _syncStatus;

  int _cachedBlockchainHeight;
  bool _isSaving;
  int _lastSaveTime;
  int _lastRefreshTime;

  TransactionHistory _changedTransactionHistory;

  MoneroWallet() {
    _cachedBlockchainHeight = 0;
    _isSaving = false;
    _lastSaveTime = 0;
    _lastRefreshTime = 0;

    _syncStatus = BehaviorSubject<SyncStatus>();

    walletHeightChannel.setMessageHandler((String h) async {
      final height = int.parse(h);

      print('new height $h');

      if (onHeightChange != null) {
        onHeightChange(height);
      }

      final nodeHeight = await getNodeHeightOrUpdate(height);
      print('nodeHeight $nodeHeight');
      if (height > 0 && ((nodeHeight - height) < moneroBlockSize)) {
        _syncStatus.add(SyncedSyncStatus());
      } else {
        _syncStatus.add(SyncingSyncStatus(height, nodeHeight));
      }

      return '';
    });

    balanceChangeChannel.setMessageHandler((_) async {
      print("balance changed");

      if (onBalanceChange != null) {
        onBalanceChange(this);
      }

      return '';
    });

    syncStateChannel.setMessageHandler((state) async {
      if (state == 'refreshed') {
        final nodeH =  await getNodeHeight();
        print('nodeH $nodeH');
        if (await getCurrentHeight() == 0) { return ''; }

        _syncStatus.add(SyncedSyncStatus());

        print('refreshed');

        final now = DateTime.now().millisecondsSinceEpoch;
        final diff = now - _lastRefreshTime;

        if (diff >= 0 && diff < 60000) {
          return '';
        }

        await store();

        _lastRefreshTime = now;
      }

      return '';
    });
  }

  Future<String> getFilename() async {
    return getValue(key: 'getFilename');
  }

  Future<String> getName() async {
    return getValue(key: 'getName');
  }

  Future<String> getAddress() async {
    return getValue(key: 'getAddress');
  }

  Future<String> getSeed() async {
    return getValue(key: 'getSeed');
  }

  Future<String> getFullBalance() async {
    return getValue(key: 'getBalance', arguments: {'account_index': 0});
  }

  Future<String> getUnlockedBalance() async {
    return getValue(key: 'getUnlockedBalance', arguments: {'account_index': 0});
  }

  Future<int> getCurrentHeight() async {
    return getValue(key: 'getCurrentHeight');
  }

  Future<int> getNodeHeight() async {
    return getValue(key: 'getNodeHeight');
  }

  Future<void> connectToNode(
      {String uri,
      String login,
      String password,
      bool useSSL = false,
      bool isLightWallet = false}) async {
    try {
      final arguments = {
        'uri': uri,
        'login': login,
        'password': password,
        'use_ssl': useSSL,
        'is_light_wallet': isLightWallet
      };

      await platform.invokeMethod('connectToNode', arguments);
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> startSync() async {
    try {
      await platform.invokeMethod('startSync');
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  TransactionHistory getHistory() {
    if (_changedTransactionHistory == null) {
      _changedTransactionHistory = MoneroTransactionHistory(platform: platform);

      syncStatus.listen((status) async {
        if (status is SyncedSyncStatus) {
          await _changedTransactionHistory.update();
        }
      });
    }

    return _changedTransactionHistory;
  }

  Future<void> askForSave() async {
    final diff = DateTime.now().millisecondsSinceEpoch - _lastSaveTime;

    if (_lastSaveTime != 0 && diff < 120000) {
      return;
    }

    await store();
  }

  Future<void> store() async {
    try {
      _isSaving = true;
      await platform.invokeMethod('store');
      _isSaving = false;
    } on PlatformException catch (e) {
      print(e);
      _isSaving = false;
      throw e;
    }
  }

  Future<int> getNodeHeightOrUpdate(int baseHeight) async {
    if (_cachedBlockchainHeight < baseHeight) {
      _cachedBlockchainHeight = await getNodeHeight();
    }

    return _cachedBlockchainHeight;
  }

  Future<PendingTransaction> createTransaction(
      TransactionCreationCredentials credentials) async {
    MoneroTransactionCreationCredentials _credentials =
        credentials as MoneroTransactionCreationCredentials;

    final arguments = {
      'address': _credentials.address,
      'paymentId': _credentials.paymentId,
      'amount': _credentials.amount,
      'priority': _credentials.priority.index,
      'accountIndex': 0
    };

    final transactionId = await platform.invokeMethod('createTransaction', arguments);
    return PendingTransaction(id: transactionId, platform: platform);
  }
}