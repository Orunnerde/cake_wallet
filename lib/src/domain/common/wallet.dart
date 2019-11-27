import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/common/transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/common/pending_transaction.dart';
import 'package:cake_wallet/src/domain/common/balance.dart';
import 'package:cake_wallet/src/domain/common/node.dart';

abstract class Wallet {
  static final walletsTable = 'wallets';
  static final idColumn = 'id';
  static final nameColumn = 'name';
  static final isRecoveryColumn = 'is_recovery';
  static final restoreHeightColumn = 'restore_height';

  static Future setInitialWalletData(
      {Database db,
      bool isRecovery,
      String name,
      WalletType type,
      int restoreHeight = 0}) async {
    final id = walletTypeToString(type).toLowerCase() + '_' + name;
    await db.insert(walletsTable, {
      idColumn: id,
      nameColumn: name,
      isRecoveryColumn: isRecovery,
      restoreHeightColumn: restoreHeight
    });
  }

  static Future updateWalletData(
      {Database db, bool isRecovery, String name, WalletType type}) async {
    final id = walletTypeToString(type).toLowerCase() + '_' + name;
    await db.update(walletsTable, {'$isRecoveryColumn': isRecovery},
        where: '$idColumn = ?', whereArgs: [id]);
  }

  static Future<bool> getIsRecovery(
      Database db, String name, WalletType type) async {
    final id = walletTypeToString(type).toLowerCase() + '_' + name;
    final wallets = await db.query(walletsTable,
        columns: [isRecoveryColumn], where: '$idColumn = ?', whereArgs: [id]);
    var isRecovery = false;

    if (wallets.length != 0) {
      isRecovery = wallets[0][isRecoveryColumn];
    }

    return isRecovery;
  }

  WalletType getType();

  Database db;
  WalletType walletType;

  Observable<Balance> onBalanceChange;

  Observable<SyncStatus> syncStatus;

  Observable<String> get onNameChange;

  Observable<String> get onAddressChange;

  String get name;

  String get address;

  Future updateInfo();

  Future<String> getFilename();

  Future<String> getName();

  Future<String> getAddress();

  Future<String> getSeed();

  Future<Map<String, String>> getKeys();

  Future<String> getFullBalance();

  Future<String> getUnlockedBalance();

  Future<int> getCurrentHeight();

  Future<int> getNodeHeight();

  Future<bool> isConnected();

  Future close();

  TransactionHistory getHistory();

  Future connectToNode({Node node, bool useSSL = false, bool isLightWallet = false});

  Future startSync();

  Future<PendingTransaction> createTransaction(
      TransactionCreationCredentials credentials);

  Future rescan({int restoreHeight = 0});
}
