import 'dart:async';
import 'package:cake_wallet/src/domain/monero/subaddress.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/common/pending_transaction.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/monero/subaddress_list.dart';
import 'package:cake_wallet/src/domain/monero/monero_transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/monero/monero_transaction_history.dart';
import 'package:sqflite/sqflite.dart';

const moneroBlockSize = 1000;

String formatAmount(String originAmount) {
  int lastIndex = 1;

  for (int i = originAmount.length - 1; i >= 0; i--) {
    if (originAmount[i] == "0") {
      lastIndex = i;
    } else {
      break;
    }
  }

  if (lastIndex < 3) {
    lastIndex = 3;
  }

  return originAmount.substring(0, lastIndex);
}

class MoneroWallet extends Wallet {
  static final platformBinaryEmptyResponse = ByteData(4);
  static const platform =
      const MethodChannel('com.cakewallet.wallet/monero-wallet');

  static const syncStateChannel =
      BasicMessageChannel('sync_state', BinaryCodec());

  static const walletHeightChannel =
      BasicMessageChannel('wallet_height', BinaryCodec());

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

  static Future<MoneroWallet> createdWallet(
      {Database db,
      String name,
      WalletType type,
      bool isRecovery,
      int restoreHeight}) async {
    await Wallet.setInitialWalletData(
        db: db,
        isRecovery: isRecovery,
        name: name,
        type: WalletType.MONERO,
        restoreHeight: restoreHeight);
    return await configured(isRecovery: isRecovery);
  }

  static Future<MoneroWallet> load(
      Database db, String name, WalletType type) async {
    final id = walletTypeToString(type).toLowerCase() + '_' + name;
    final wallets = await db.query(Wallet.walletsTable,
        columns: [Wallet.isRecoveryColumn],
        where: '${Wallet.idColumn} = ?',
        whereArgs: [id]);
    var isRecovery = false;
    var restoreHeight = 0;

    if (wallets.length != 0) {
      isRecovery = wallets[0][Wallet.isRecoveryColumn] == 1;
      restoreHeight = wallets[0][Wallet.restoreHeightColumn];
    }

    return await configured(
        isRecovery: isRecovery, restoreHeight: restoreHeight);
  }

  static Future<MoneroWallet> configured(
      {bool isRecovery, int restoreHeight}) async {
    final wallet = MoneroWallet(isRecovery: isRecovery);

    if (isRecovery) {
      await wallet.setRecoveringFromSeed();

      if (restoreHeight != null || restoreHeight != 0) {
        await wallet.setRefreshFromBlockHeight(height: restoreHeight);
      }
    }

    return wallet;
  }

  get syncStatus => _syncStatus.stream;
  get onBalanceChange => _onBalanceChange.stream;
  bool isRecovery;
  Function(int height) onHeightChange;

  BehaviorSubject<Wallet> _onBalanceChange;
  BehaviorSubject<SyncStatus> _syncStatus;
  int _cachedBlockchainHeight;
  bool _isSaving;
  int _lastSaveTime;
  int _lastRefreshTime;

  TransactionHistory _cachedTransactionHistory;
  SubaddressList _cachedSubaddressList;

  MoneroWallet({this.isRecovery = false}) {
    _cachedBlockchainHeight = 0;
    _isSaving = false;
    _lastSaveTime = 0;
    _lastRefreshTime = 0;

    _syncStatus = BehaviorSubject<SyncStatus>();
    _onBalanceChange = BehaviorSubject<Wallet>();

    walletHeightChannel.setMessageHandler((h) async {
      final height = h.getUint64(0);

      print('height $height');

      if (onHeightChange != null) {
        onHeightChange(height);
      }

      final nodeHeight = await getNodeHeightOrUpdate(height);

      if (height > 0 && ((nodeHeight - height) < moneroBlockSize)) {
        _syncStatus.add(SyncedSyncStatus());
      } else {
        _syncStatus.add(SyncingSyncStatus(height, nodeHeight));
      }

      return platformBinaryEmptyResponse;
    });

    balanceChangeChannel.setMessageHandler((_) async {
      print('Balance changed');
      _onBalanceChange.add(this);

      getHistory()
          .update()
          .then((_) => print('ask to update transaction history'));
          
      return '';
    });

    syncStateChannel.setMessageHandler((_) async {
      final currentHeight = await getCurrentHeight();
      final nodeHeight = await getNodeHeight();

      getHistory()
          .update()
          .then((_) => print('ask to update transaction history'));

      if (currentHeight == 0) {
        return platformBinaryEmptyResponse;
      }

      if (_syncStatus.value is FailedSyncStatus) {
        return platformBinaryEmptyResponse;
      }

      _syncStatus.add(SyncedSyncStatus());

      if (isRecovery && (nodeHeight - currentHeight < moneroBlockSize)) {
        await setAsRecovered();
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = now - _lastRefreshTime;

      if (diff >= 0 && diff < 60000) {
        return ByteData(0);
      }

      await store();

      _lastRefreshTime = now;

      return platformBinaryEmptyResponse;
    });
  }

  WalletType getType() => WalletType.MONERO;

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
    return formatAmount(
        await getValue(key: 'getBalance', arguments: {'account_index': 0}));
  }

  Future<String> getUnlockedBalance() async {
    return formatAmount(await getValue(
        key: 'getUnlockedBalance', arguments: {'account_index': 0}));
  }

  Future<int> getCurrentHeight() async {
    return getValue(key: 'getCurrentHeight');
  }

  Future<bool> isConnected() async {
    return getValue(key: 'getIsConnected');
  }

  Future<int> getNodeHeight() async {
    return getValue(key: 'getNodeHeight');
  }

  Future<void> close() async {
    try {
      await platform.invokeMethod('close');
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> connectToNode(
      {String uri,
      String login,
      String password,
      bool useSSL = false,
      bool isLightWallet = false}) async {
    try {
      _syncStatus.value = ConnectingSyncStatus();

      final arguments = {
        'uri': uri,
        'login': login,
        'password': password,
        'use_ssl': useSSL,
        'is_light_wallet': isLightWallet
      };

      await platform.invokeMethod('connectToNode', arguments);

      _syncStatus.value = ConnectedSyncStatus();
    } on PlatformException catch (e) {
      _syncStatus.value = FailedSyncStatus();
      print(e);
      throw e;
    }
  }

  Future<void> startSync() async {
    try {
      _syncStatus.value = StartingSyncStatus();
      await platform.invokeMethod('startSync');
    } on PlatformException catch (e) {
      _syncStatus.value = FailedSyncStatus();
      print(e);
      throw e;
    }
  }

  TransactionHistory getHistory() {
    if (_cachedTransactionHistory == null) {
      _cachedTransactionHistory = MoneroTransactionHistory(platform: platform);

      syncStatus.listen((status) async {
        if (status is SyncedSyncStatus) {
          await _cachedTransactionHistory.update();
        }
      });
    }

    return _cachedTransactionHistory;
  }

  SubaddressList getSubaddress() {
    if (_cachedSubaddressList == null) {
      _cachedSubaddressList = SubaddressList(platform: platform);
    }

    return _cachedSubaddressList;
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

    final Map transaction =
        await platform.invokeMethod('createTransaction', arguments);
    return PendingTransaction.fromMap(transaction, platform);
  }

  Future<void> setRecoveringFromSeed() async {
    try {
      await platform
          .invokeMethod('setRecoveringFromSeed', const {'isRecovering': true});
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> setRefreshFromBlockHeight({int height}) async {
    try {
      await platform.invokeMethod('setRecoveringFromSeed', {'height': height});
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> setAsRecovered() async {
    final helper = await DbHelper.getInstance();
    final db = await helper.getDb();
    final name = await getName();
    await Wallet.updateWalletData(
        db: db, name: name, isRecovery: false, type: WalletType.MONERO);
    isRecovery = true;
  }
}
