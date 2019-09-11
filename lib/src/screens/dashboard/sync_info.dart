import 'package:cake_wallet/src/domain/common/transaction_priority.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/common/pending_transaction.dart';
import 'package:cake_wallet/src/domain/monero/monero_transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/monero/subaddress_list.dart';
import 'package:cake_wallet/src/domain/monero/subaddress.dart';

class SyncInfo extends ChangeNotifier {
  WalletService _walletService;
  SyncStatus _syncStatus;

  SyncInfo(
      {SyncStatus syncStatus = const NotConnectedSyncStatus(),
      @required WalletService walletService}) {
    _syncStatus = syncStatus;
    _walletService = walletService;

    if (walletService.currentWallet != null) {
      walletService.syncStatus.listen((status) => this.status = status);
    }
  }

  get status => _syncStatus;

  set status(SyncStatus status) {
    _syncStatus = status;
    notifyListeners();
  }
}

class TransactionsInfo extends ChangeNotifier {
  WalletService _walletService;
  List<TransactionInfo> _transactions = [];
  TransactionHistory _history;

  TransactionsInfo({@required WalletService walletService}) {
    _walletService = walletService;

    if (walletService.currentWallet != null) {
      onWalletChanged(walletService.currentWallet);
    }

    walletService.onWalletChange = (wallet) => onWalletChanged(wallet);
  }

  get transactions => _transactions;

  set transactions(List<TransactionInfo> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  Future<void> updateTransactionsList() async {
    await _history.refresh();
    transactions = await _history.getAll();
  }

  Future<void> onWalletChanged(Wallet wallet) async {
    _history = wallet.getHistory();
    _history.transactions
        .listen((transactions) => this.transactions = transactions);
    await updateTransactionsList();
  }
}

enum FiatCurrency { USD, EUR }
enum CryptoCurrency { XMR }

String fiatToString(FiatCurrency fiat) {
  switch (fiat) {
    case FiatCurrency.USD:
      return 'USD';
    case FiatCurrency.EUR:
      return 'EUR';
    default:
      return '';
  }
}

String cryptoToString(CryptoCurrency crypto) {
  switch (crypto) {
    case CryptoCurrency.XMR:
      return 'XMR';
    default:
      return '';
  }
}

const coinMarketCapAuthority = 'api.coinmarketcap.com';
const coinMarketCapPath = '/v2/ticker/';
var _cachedPrices = {};

Future<double> fetchPriceFor({CryptoCurrency crypto, FiatCurrency fiat}) async {
  final fiatStringified = fiatToString(fiat);

  if (_cachedPrices[fiatStringified] != null) {
    return _cachedPrices[fiatStringified];
  }

  final uri = Uri.https(coinMarketCapAuthority, coinMarketCapPath,
      {'structure': 'array', 'convert': fiatStringified});

  try {
    final response = await get(uri.toString());

    if (response.statusCode == 200) {
      final responseJSON = json.decode(response.body);
      final data = responseJSON['data'];
      double price;

      for (final item in data) {
        if (item['symbol'] == cryptoToString(crypto)) {
          price = item['quotes'][fiatStringified]['price'];
          _cachedPrices[fiatStringified] = price;
          break;
        }
      }

      return price;
    }

    return 0.0;
  } catch (e) {
    print('e $e');
    throw e;
  }
}

class BalanceInfo extends ChangeNotifier {
  WalletService _walletService;
  String _fullBalance;
  String _unlockedBalance;
  String _fiatFullBalance;
  String _fiatUnlockedBalance;

  BalanceInfo(
      {String fullBalance = '0.0',
      String unlockedBalance = '0.0',
      @required WalletService walletService}) {
    _fullBalance = fullBalance;
    _unlockedBalance = unlockedBalance;
    _fiatFullBalance = '0.0';
    _fiatUnlockedBalance = '0.0';
    _walletService = walletService;

    if (_walletService.currentWallet != null) {
      _walletService.onBalanceChange.listen((wallet) async {
        if (this == null) { return; }
        
        print('Test 1');
        final fullBalance = await wallet.getFullBalance();
        final unlockedBalance = await wallet.getUnlockedBalance();

        if (this.fullBalance != fullBalance) {
          this.fullBalance = fullBalance;
        }

        if (this.unlockedBalance != unlockedBalance) {
          this.unlockedBalance = unlockedBalance;
        }
      });

      onWalletChanged(_walletService.currentWallet);
    }

    _walletService.onWalletChange = (wallet) => onWalletChanged(wallet);
  }

  void onBalanceChange(Wallet wallet) async {
    final fullBalance = await wallet.getFullBalance();
    final unlockedBalance = await wallet.getUnlockedBalance();

    if (this.fullBalance != fullBalance) {
      this.fullBalance = fullBalance;
    }

    if (this.unlockedBalance != unlockedBalance) {
      this.unlockedBalance = unlockedBalance;
    }
  }

  get fullBalance => _fullBalance;

  set fullBalance(String balance) {
    _fullBalance = balance;
    fetchPriceFor(crypto: CryptoCurrency.XMR, fiat: FiatCurrency.USD)
        .then((price) {
      final fiatBalance = double.parse(_fullBalance) * price;
      final numberFormat = NumberFormat("#,##0.00", "en_US");
      fiatFullBalance = numberFormat.format(fiatBalance);
    });

    notifyListeners();
  }

  get unlockedBalance => _unlockedBalance;

  set unlockedBalance(String balance) {
    _unlockedBalance = balance;
    notifyListeners();
  }

  get fiatFullBalance => _fiatFullBalance;
  get fiatUnlockedBalance => _fiatUnlockedBalance;

  set fiatFullBalance(String balance) {
    _fiatFullBalance = balance;
    notifyListeners();
  }

  set fiatUnlockedBalance(String balance) {
    _fiatUnlockedBalance = balance;
    notifyListeners();
  }

  Future<void> updateBalances() async {
    if (_walletService.currentWallet == null) {
      return;
    }

    fullBalance = await _walletService.getFullBalance();
    unlockedBalance = await _walletService.getUnlockedBalance();
  }

  Future<void> onWalletChanged(Wallet wallet) async {
    _walletService.onBalanceChange.listen((wallet) async {
      print('Test 1');
      final fullBalance = await wallet.getFullBalance();
      final unlockedBalance = await wallet.getUnlockedBalance();

      if (this.fullBalance != fullBalance) {
        this.fullBalance = fullBalance;
      }

      if (this.unlockedBalance != unlockedBalance) {
        this.unlockedBalance = unlockedBalance;
      }
    });

    await updateBalances();
  }
}

class WalletInfo extends ChangeNotifier {
  get address => _address;
  get name => _name;
  get subaddress => _subaddress;

  String _address;
  String _name;
  Subaddress _subaddress;
  WalletService _walletService;

  WalletInfo({@required WalletService walletService}) {
    _walletService = walletService;
    _name = "Monero Wallet";

    if (_walletService.currentWallet != null) {
      _walletService.getAddress().then((address) => _setAddress(address));
      _walletService.getName().then((address) => _setName(address));

      if (_walletService.currentWallet is MoneroWallet) {
        final subaddressList = _walletService.currentWallet.getSubaddress();
        subaddressList
            .refresh(accountIndex: 0)
            .then((_) => subaddressList.getAll())
            .then((subaddresses) => subaddresses[0])
            .then((primary) => _setSubaddress(primary));
      }
    }

    _walletService.onWalletChange = (wallet) => onWalletChanged(wallet);
  }

  void onWalletChanged(Wallet wallet) async {
    final address = await wallet.getAddress();
    _setAddress(address);

    if (wallet is MoneroWallet) {
      final subaddressList = wallet.getSubaddress();
      await subaddressList.refresh(accountIndex: 0);
      final subaddresses = await subaddressList.getAll();
      final primary = subaddresses[0];
      _setSubaddress(primary);
    }
  }

  void changeCurrentSubaddress(Subaddress subaddress) {
    _setSubaddress(subaddress);
  }

  void _setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void _setName(String name) {
    _name = name;
    notifyListeners();
  }

  void _setSubaddress(Subaddress subaddress) {
    _subaddress = subaddress;
    notifyListeners();
  }
}

enum SendState {
  CREATING_TRANSACTION,
  TRANSACTION_CREATED,
  COMMITTING,
  COMMITTED,
  ERROR,
  NONE
}

class SendInfo extends ChangeNotifier {
  Exception error;
  TransactionPriority priority = TransactionPriority.DEFAULT;

  get needToSendAll => _needToSendAll;

  set needToSendAll(bool flag) {
    _needToSendAll = flag;

    if (_needToSendAll) {
      _cryptoAmountRaw = 'ALL';
      _fiatAmountRaw = '';
    }

    notifyListeners();
  }

  get state => _state;

  set state(SendState state) {
    print('new state $state');
    _state = state;
    notifyListeners();
  }

  get fiatAmount => _fiatAmount;

  set fiatAmount(String amount) {
    _fiatAmountRaw = amount;

    fetchPriceFor(crypto: CryptoCurrency.XMR, fiat: FiatCurrency.USD)
        .then((price) => amount.isEmpty ? null : double.parse(amount) / price)
        .then((amount) =>
            amount == null ? '' : _cryptoNumberFormat.format(amount))
        .then((amount) => _cryptoAmountRaw = amount);
  }

  get cryptoAmount => _cryptoAmount;

  set cryptoAmount(String amount) {
    _cryptoAmountRaw = amount;

    fetchPriceFor(crypto: CryptoCurrency.XMR, fiat: FiatCurrency.USD)
        .then((price) => amount.isEmpty
            ? null
            : double.parse(amount.replaceAll(',', '.')) * price)
        .then(
            (amount) => amount == null ? '' : _fiatNumberFormat.format(amount))
        .then((amount) => _fiatAmountRaw = amount);
  }

  set _cryptoAmountRaw(String amount) {
    _cryptoAmount = amount;
    notifyListeners();
  }

  set _fiatAmountRaw(String amount) {
    _fiatAmount = amount;
    notifyListeners();
  }

  get pendingTransaction => _pendingTransaction;

  bool _needToSendAll;
  WalletService _walletService;
  SendState _state;
  PendingTransaction _pendingTransaction;
  String _fiatAmount;
  String _cryptoAmount;
  NumberFormat _cryptoNumberFormat;
  NumberFormat _fiatNumberFormat;

  SendInfo({@required WalletService walletService}) {
    _walletService = walletService;
    _fiatAmount = '';
    _cryptoAmount = '';
    _needToSendAll = false;
    _cryptoNumberFormat = NumberFormat()..maximumFractionDigits = 12;
    _fiatNumberFormat = NumberFormat()..maximumFractionDigits = 2;
  }

  Future<void> createTransaction({String address, String paymentId}) async {
    state = SendState.CREATING_TRANSACTION;

    try {
      final amount = _needToSendAll ? null : _cryptoAmount.replaceAll(',', '.');
      print('amount $amount');

      final credentials = MoneroTransactionCreationCredentials(
          address: address,
          paymentId: paymentId,
          amount: amount,
          priority: TransactionPriority.DEFAULT);

      _pendingTransaction = await _walletService.createTransaction(credentials);
      state = SendState.TRANSACTION_CREATED;
    } catch (e) {
      print('error ${e.toString()}');
      state = SendState.ERROR;
      error = e;
    }
  }

  Future<void> commitTransaction() async {
    try {
      state = SendState.COMMITTING;
      await _pendingTransaction.commit();
      state = SendState.COMMITTED;
    } catch (e) {
      print('error ${e.toString()}');
      state = SendState.ERROR;
      error = e;
    }

    _pendingTransaction = null;
  }

  void resetError() {
    error = null;
    state = SendState.NONE;
  }
}

class SubaddressListInfo extends ChangeNotifier {
  get subaddresses => _subaddresses;

  set subaddresses(List<Subaddress> subaddresses) {
    _subaddresses = subaddresses;
    notifyListeners();
  }

  WalletService _walletService;
  List<Subaddress> _subaddresses = [];
  SubaddressList _subaddressList;

  SubaddressListInfo({@required WalletService walletService}) {
    _walletService = walletService;

    if (walletService.currentWallet != null) {
      onWalletChanged(walletService.currentWallet);
    }

    walletService.onWalletChange = (wallet) => onWalletChanged(wallet);
  }

  Future<void> updateSubaddressList() async {
    await _subaddressList.refresh(accountIndex: 0);
    _subaddresses = await _subaddressList.getAll();
  }

  Future<void> onWalletChanged(Wallet wallet) async {
    if (wallet is MoneroWallet) {
      _subaddressList = wallet.getSubaddress();
      _subaddressList.subaddresses
          .listen((subaddress) => this.subaddresses = subaddress);
      await updateSubaddressList();

      return;
    }

    print('Incorrect wallet type for this operation (SubaddressList)');
  }
}

enum SubaddressCrationState { CREATING, CREATED, NONE }

class NewSubaddressInfo extends ChangeNotifier {
  get state => _state;

  set state(SubaddressCrationState state) {
    _state = state;
    notifyListeners();
  }

  WalletService _walletService;
  SubaddressList _subaddressList;
  SubaddressCrationState _state;

  NewSubaddressInfo({@required WalletService walletService}) {
    _walletService = walletService;

    if (walletService.currentWallet != null) {
      onWalletChanged(walletService.currentWallet);
    }

    walletService.onWalletChange = (wallet) => onWalletChanged(wallet);
    _state = SubaddressCrationState.NONE;
  }

  Future<void> add({String label}) async {
    state = SubaddressCrationState.CREATING;

    try {
      await _subaddressList.addSubaddress(accountIndex: 0, label: label);
      state = SubaddressCrationState.CREATED;
      _subaddressList.update();
    } catch (e) {
      print(e);
      state = SubaddressCrationState.NONE;
    }
  }

  Future<void> onWalletChanged(Wallet wallet) async {
    if (wallet is MoneroWallet) {
      _subaddressList = wallet.getSubaddress();
      return;
    }

    print('Incorrect wallet type for this operation (SubaddressList)');
  }
}
