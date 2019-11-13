import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/common/pending_transaction.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/common/core_db.dart';
import 'package:cake_wallet/src/domain/common/node.dart';
import 'package:cake_wallet/src/domain/monero/account.dart';
import 'package:cake_wallet/src/domain/monero/account_list.dart';
import 'package:cake_wallet/src/domain/monero/subaddress_list.dart';
import 'package:cake_wallet/src/domain/monero/monero_transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/monero/monero_transaction_history.dart';
import 'package:cake_wallet/src/domain/monero/subaddress.dart';
import 'package:cake_wallet/src/domain/common/balance.dart';
import 'package:cake_wallet/src/domain/monero/monero_balance.dart';

const moneroBlockSize = 1000;

String formatAmount(String originAmount) {
  final int startIndex = originAmount.length - 1;
  int lastIndex = 0;

  for (int i = startIndex; i >= 0; i--) {
    if (originAmount[i] == "0") {
      lastIndex = i;
    } else if (i == startIndex) {
      lastIndex = i + 1;
      break;
    } else {
      break;
    }
  }

  if (lastIndex < 3) {
    return '0.00';
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
      int restoreHeight = 0}) async {
    await Wallet.setInitialWalletData(
        db: db,
        isRecovery: isRecovery,
        name: name,
        type: WalletType.monero,
        restoreHeight: restoreHeight);
    return await configured(
        isRecovery: isRecovery, restoreHeight: restoreHeight);
  }

  static Future<MoneroWallet> load(
      Database db, String name, WalletType type) async {
    final id = walletTypeToString(type).toLowerCase() + '_' + name;
    final wallets = await db.query(Wallet.walletsTable,
        columns: [Wallet.isRecoveryColumn, Wallet.restoreHeightColumn],
        where: '${Wallet.idColumn} = ?',
        whereArgs: [id]);
    var isRecovery = false;
    var restoreHeight = 0;

    if (wallets.length != 0) {
      final wallet = wallets[0];
      isRecovery = wallet[Wallet.isRecoveryColumn] == 1;
      restoreHeight = wallet[Wallet.restoreHeightColumn] ?? 0;
    }

    return await configured(
        isRecovery: isRecovery, restoreHeight: restoreHeight);
  }

  static Future<MoneroWallet> configured(
      {bool isRecovery, int restoreHeight}) async {
    final wallet = MoneroWallet(isRecovery: isRecovery);

    if (isRecovery) {
      await wallet.setRecoveringFromSeed();

      if (restoreHeight != null) {
        await wallet.setRefreshFromBlockHeight(height: restoreHeight);
      }
    }

    return wallet;
  }

  WalletType getType() => WalletType.monero;
  bool isRecovery;
  Observable<SyncStatus> get syncStatus => _syncStatus.stream;
  Observable<Balance> get onBalanceChange => _onBalanceChange.stream;
  Observable<Account> get onAccountChange => _account.stream;
  Observable<String> get onNameChange => _name.stream;
  Observable<String> get onAddressChange => _address.stream;
  Observable<Subaddress> get subaddress => _subaddress.stream;

  Account get account => _account.value;
  String get address => _address.value;
  String get name => _name.value;

  BehaviorSubject<Account> _account;
  BehaviorSubject<MoneroBalance> _onBalanceChange;
  BehaviorSubject<SyncStatus> _syncStatus;
  BehaviorSubject<String> _name;
  BehaviorSubject<String> _address;
  BehaviorSubject<Subaddress> _subaddress;
  int _cachedBlockchainHeight;
  bool _isSaving;
  int _lastSaveTime;
  int _lastRefreshTime;
  int _refreshHeight;
  int _lastSyncHeight;

  TransactionHistory _cachedTransactionHistory;
  SubaddressList _cachedSubaddressList;
  AccountList _cachedAccountList;

  MoneroWallet({this.isRecovery = false}) {
    _cachedBlockchainHeight = 0;
    _isSaving = false;
    _lastSaveTime = 0;
    _lastRefreshTime = 0;
    _refreshHeight = 0;
    _lastSyncHeight = 0;
    _name = BehaviorSubject<String>();
    _address = BehaviorSubject<String>();
    _syncStatus = BehaviorSubject<SyncStatus>();
    _onBalanceChange = BehaviorSubject<MoneroBalance>();
    _account = BehaviorSubject<Account>()..add(Account(id: 0));
    _subaddress = BehaviorSubject<Subaddress>();

    walletHeightChannel.setMessageHandler((h) async {
      final height = h.getUint64(0);
      final nodeHeight = await getNodeHeightOrUpdate(height);

      if (isRecovery && _refreshHeight <= 0) {
        _refreshHeight = height;
      }

      if (isRecovery &&
          (_lastSyncHeight == 0 ||
              (height - _lastSyncHeight) > moneroBlockSize)) {
        _lastSyncHeight = height;
        askForUpdateBalance();
        askForUpdateTransactionHistory();
      }

      if (height > 0 && ((nodeHeight - height) < moneroBlockSize)) {
        _syncStatus.add(SyncedSyncStatus());
      } else {
        _syncStatus.add(SyncingSyncStatus(height, nodeHeight, _refreshHeight));
      }

      return platformBinaryEmptyResponse;
    });

    balanceChangeChannel.setMessageHandler((_) async {
      askForUpdateBalance();
      askForUpdateTransactionHistory();

      return '';
    });

    syncStateChannel.setMessageHandler((_) async {
      final currentHeight = await getCurrentHeight();
      final nodeHeight = await getNodeHeightOrUpdate(currentHeight);

      askForUpdateTransactionHistory();

      if (currentHeight == 0) {
        return platformBinaryEmptyResponse;
      }

      if (_syncStatus.value is FailedSyncStatus) {
        return platformBinaryEmptyResponse;
      }

      _syncStatus.add(SyncedSyncStatus());

      if (isRecovery && (nodeHeight - currentHeight < moneroBlockSize)) {
        await setAsRecovered();
        askForUpdateBalance();
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

    getAccountList()
      ..refresh()
      ..getAll().then((account) => this._account.add(account[0]));
  }

  Future updateInfo() async {
    _name.value = await getName();
    _address.value = await getAddress();
    final subaddressList = getSubaddress();
    await subaddressList.refresh(
        accountIndex: _account.value != null ? _account.value.id : 0);
    final subaddresses = await subaddressList.getAll();
    _subaddress.value = subaddresses.first;
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

  Future<int> getNodeHeight() async {
    return getValue(key: 'getNodeHeight');
  }

  Future<Map<String, String>> getKeys() async {
    final map = await getValue(key: 'getKeys');

    return {
      'publicViewKey': map['publicViewKey'],
      'privateViewKey': map['privateViewKey'],
      'publicSpendKey': map['publicSpendKey'],
      'privateSpendKey': map['privateSpendKey'],
    };
  }

  Future close() async {
    try {
      await platform.invokeMethod('close');
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future connectToNode(
      {Node node, bool useSSL = false, bool isLightWallet = false}) async {
    try {
      _syncStatus.value = ConnectingSyncStatus();

      final arguments = {
        'uri': node.uri,
        'login': node.login,
        'password': node.password,
        'use_ssl': useSSL,
        'is_light_wallet': isLightWallet
      };

      await platform.invokeMethod('connectToNode', arguments);

      _syncStatus.value = ConnectedSyncStatus();
    } on PlatformException catch (e) {
      _syncStatus.value = FailedSyncStatus();
      print(e);
    }
  }

  Future startSync() async {
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

  AccountList getAccountList() {
    if (_cachedAccountList == null) {
      _cachedAccountList = AccountList(platform: platform);
    }

    return _cachedAccountList;
  }

  Future askForSave() async {
    final diff = DateTime.now().millisecondsSinceEpoch - _lastSaveTime;

    if (_lastSaveTime != 0 && diff < 120000) {
      return;
    }

    await store();
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
      'priority': _credentials.priority.serialize(),
      'accountIndex': _account.value.id
    };

    final Map transaction =
        await platform.invokeMethod('createTransaction', arguments);
    return PendingTransaction.fromMap(transaction, platform);
  }

  Future setRecoveringFromSeed() async {
    try {
      await platform
          .invokeMethod('setRecoveringFromSeed', const {'isRecovering': true});
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future setRefreshFromBlockHeight({int height}) async {
    try {
      _refreshHeight = height;
      await platform
          .invokeMethod('setRefreshFromBlockHeight', {'height': height});
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future setAsRecovered() async {
    final helper = await CoreDB.getInstance();
    final db = await helper.getDb();
    final name = await getName();
    await Wallet.updateWalletData(
        db: db, name: name, isRecovery: false, type: WalletType.monero);
    isRecovery = true;
  }

  Future askForUpdateBalance() async {
    final fullBalance = await getFullBalance();
    final unlockedBalance = await getUnlockedBalance();
    final needToChange = _onBalanceChange.value != null
        ? _onBalanceChange.value.fullBalance != fullBalance ||
            _onBalanceChange.value.unlockedBalance != unlockedBalance
        : true;

    if (!needToChange) {
      return;
    }

    _onBalanceChange.add(MoneroBalance(
        fullBalance: fullBalance, unlockedBalance: unlockedBalance));
  }

  Future askForUpdateTransactionHistory() async {
    await getHistory().update();
  }

  Future rescan({int restoreHeight = 0}) async {}

  void changeCurrentSubaddress(Subaddress subaddress) {
    _subaddress.value = subaddress;
  }

  void changeAccount(Account account) {
    _account.add(account);

    getSubaddress()
        .refresh(accountIndex: account.id)
        .then((_) => getSubaddress().getAll())
        .then((subaddresses) => _subaddress.value = subaddresses[0]);
  }

  Future store() async {
    if (_isSaving) {
      return;
    }

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

  Future<bool> isConnected() async {
    bool isConnected = false;

    try {
      _isSaving = true;
      isConnected = await platform.invokeMethod('getIsConnected');
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }

    return isConnected;
  }
}
