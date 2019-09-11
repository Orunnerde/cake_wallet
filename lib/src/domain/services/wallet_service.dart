import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/common/pending_transaction.dart';

class WalletService extends Wallet {
  Function(Wallet wallet) onWalletChange;
  
  get onBalanceChange => _onBalanceChange.stream;
  get syncStatus => _syncStatus.stream;
  get syncStatusValue => _syncStatus.value;
  get walletType => _currentWallet.walletType;
  get currentWallet => _currentWallet;

  set currentWallet(Wallet wallet) {
    _currentWallet = wallet;
    _currentWallet.onBalanceChange.listen((wallet) => _onBalanceChange.add(wallet));
    _currentWallet.syncStatus.listen((status) => _syncStatus.add(status));

    if (onWalletChange != null) {
      onWalletChange(wallet);
    }
  }

  BehaviorSubject<Wallet> _onBalanceChange;
  BehaviorSubject<SyncStatus> _syncStatus;
  Wallet _currentWallet;

  WalletService({this.onWalletChange}) {
    _currentWallet = null;
    walletType = WalletType.NONE;
    _syncStatus = BehaviorSubject<SyncStatus>();
    _onBalanceChange = BehaviorSubject<Wallet>();
  }

  WalletType getType() => WalletType.MONERO;

  Future<String> getFilename() => _currentWallet.getFilename();

  Future<String> getName() => _currentWallet.getName();

  Future<String> getAddress() => _currentWallet.getAddress();

  Future<String> getSeed() => _currentWallet.getSeed();

  Future<String> getFullBalance() => _currentWallet.getFullBalance();

  Future<String> getUnlockedBalance() => _currentWallet.getUnlockedBalance();

  Future<int> getCurrentHeight() => _currentWallet.getCurrentHeight();

  Future<int> getNodeHeight() => _currentWallet.getNodeHeight();

  Future<bool> isConnected() => _currentWallet.isConnected();

  Future<void> connectToNode(
          {String uri,
          String login,
          String password,
          bool useSSL = false,
          bool isLightWallet = false}) =>
      _currentWallet.connectToNode(
          uri: uri,
          login: login,
          password: password,
          useSSL: useSSL,
          isLightWallet: isLightWallet);

  Future<void> startSync() => _currentWallet.startSync();

  TransactionHistory getHistory() => _currentWallet.getHistory();

  Future<PendingTransaction> createTransaction(
          TransactionCreationCredentials credentials) =>
      _currentWallet.createTransaction(credentials);
}
