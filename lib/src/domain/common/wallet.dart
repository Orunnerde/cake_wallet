import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/common/transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/common/pending_transaction.dart';
import 'package:sqflite/sqflite.dart';

abstract class Wallet {
  static final walletsTable = 'wallets';
  static final idColumn = 'id';
  static final nameColumn = 'name';
  static final isRecoveryColumn = 'is_recovery';
  static final restoreHeightColumn = 'restore_height';

  static Future<void> setInitialWalletData(
      {Database db,
      bool isRecovery,
      String name,
      WalletType type,
      int restoreHeight = 0}) async {
    final id = walletTypeToString(type).toLowerCase() + '_' + name;
    await db.insert(walletsTable, {
      idColumn: id,
      nameColumn : name,
      isRecoveryColumn: isRecovery,
      restoreHeightColumn: restoreHeight
    });
  }

  static Future<void> updateWalletData(
      {Database db,
      bool isRecovery,
      String name,
      WalletType type}) async {
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

  Observable<Wallet> onBalanceChange;

  Observable<SyncStatus> syncStatus;

  Future<String> getFilename();

  Future<String> getName();

  Future<String> getAddress();

  Future<String> getSeed();

  Future<String> getFullBalance();

  Future<String> getUnlockedBalance();

  Future<int> getCurrentHeight();

  Future<int> getNodeHeight();

  Future<bool> isConnected();

  Future<void> close();

  TransactionHistory getHistory();

  Future<void> connectToNode(
      {String uri,
      String login,
      String password,
      bool useSSL = false,
      bool isLightWallet = false});

  Future<void> startSync();

  Future<PendingTransaction> createTransaction(
      TransactionCreationCredentials credentials);
}
