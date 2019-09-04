import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/common/transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/common/pending_transaction.dart';

abstract class Wallet {
  WalletType walletType;

  Function(Wallet wallet) onBalanceChange;

  Observable<SyncStatus> syncStatus;

  Future<String> getFilename();

  Future<String> getName();

  Future<String> getAddress();

  Future<String> getSeed();

  Future<String> getFullBalance();

  Future<String> getUnlockedBalance();

  Future<int> getCurrentHeight();

  Future<int> getNodeHeight();

  TransactionHistory getHistory();

  Future<void> connectToNode(
      {String uri,
      String login,
      String password,
      bool useSSL = false,
      bool isLightWallet = false});

  Future<void> startSync();

  Future<PendingTransaction> createTransaction(TransactionCreationCredentials credentials);
}