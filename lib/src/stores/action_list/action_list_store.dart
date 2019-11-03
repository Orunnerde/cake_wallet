import 'dart:async';
import 'package:cake_wallet/src/domain/common/transaction_direction.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_provider_description.dart';
import 'package:cake_wallet/src/stores/action_list/action_list_display_mode.dart';
import 'package:cake_wallet/src/stores/action_list/trade_filter_store.dart';
import 'package:cake_wallet/src/stores/action_list/transaction_filter_store.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/monero/account.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/domain/exchange/trade.dart';
import 'package:cake_wallet/src/domain/exchange/trade_history.dart';

part 'action_list_store.g.dart';

abstract class ActionListItem {
  DateTime get date;
}

class TransactionListItem extends ActionListItem {
  final TransactionInfo transaction;

  DateTime get date => transaction.date;

  TransactionListItem({this.transaction});
}

class TradeListItem extends ActionListItem {
  final Trade trade;

  DateTime get date => trade.createdAt;

  TradeListItem({this.trade});
}

class DateSectionItem extends ActionListItem {
  final DateTime date;

  DateSectionItem(this.date);
}

class ActionListStore = ActionListBase with _$ActionListStore;

abstract class ActionListBase with Store {
  static List<ActionListItem> formattedItemsList(List<ActionListItem> items) {
    var formattedList = List<ActionListItem>();
    DateTime lastDate;
    items.sort((a, b) => b.date.compareTo(a.date));

    for (int i = 0; i < items.length; i++) {
      final transaction = items[i];
      final txDateUtc = transaction.date.toUtc();
      final txDate = DateTime(txDateUtc.year, txDateUtc.month, txDateUtc.day);

      if (lastDate == null) {
        lastDate = txDate;
        formattedList.add(DateSectionItem(transaction.date));
        formattedList.add(transaction);
        continue;
      }

      if (lastDate.compareTo(txDate) == 0) {
        formattedList.add(transaction);
        continue;
      }

      lastDate = txDate;
      formattedList.add(DateSectionItem(transaction.date));
      formattedList.add(transaction);
    }

    return formattedList;
  }

  @observable
  List<TransactionListItem> transactions;

  @observable
  List<TradeListItem> trades;

  @computed
  List<ActionListItem> get items {
    var _items = List<ActionListItem>();

    if (_settingsStore.actionlistDisplayMode
        .contains(ActionListDisplayMode.transactions)) {
      List<TransactionListItem> _transactions = [];
      final needToFilter = !transactionFilterStore.displayOutgoing ||
          !transactionFilterStore.displayIncoming ||
          (transactionFilterStore.startDate != null &&
              transactionFilterStore.endDate != null);

      if (needToFilter) {
        _transactions = transactions.where((item) {
          var allowed = true;

          if (allowed &&
              transactionFilterStore.startDate != null &&
              transactionFilterStore.endDate != null) {
            allowed = transactionFilterStore.startDate
                    .isBefore(item.transaction.date) &&
                transactionFilterStore.endDate.isAfter(item.transaction.date);
          }

          if (allowed &&
              (!transactionFilterStore.displayOutgoing ||
                  transactionFilterStore.displayIncoming)) {
            allowed = (transactionFilterStore.displayOutgoing &&
                    item.transaction.direction ==
                        TransactionDirection.outgoing) ||
                (transactionFilterStore.displayIncoming &&
                    item.transaction.direction ==
                        TransactionDirection.incoming);
          }

          return allowed;
        }).toList();
      } else {
        _transactions = transactions;
      }

      _items.addAll(_transactions);
    }

    if (_settingsStore.actionlistDisplayMode
        .contains(ActionListDisplayMode.trades)) {
      List<TradeListItem> _trades = [];

      final needToFilter =
          !tradeFilterStore.displayChangeNow || !tradeFilterStore.displayXMRTO;

      if (needToFilter) {
        _trades = trades.where((item) {
          return (!tradeFilterStore.displayXMRTO &&
                  item.trade.provider != ExchangeProviderDescription.xmrto) ||
              (!tradeFilterStore.displayChangeNow &&
                  item.trade.provider != ExchangeProviderDescription.changeNow);
        }).toList();
      } else {
        _trades = trades;
      }

      _items.addAll(_trades);
    }

    return formattedItemsList(_items);
  }

  TransactionFilterStore transactionFilterStore;
  TradeFilterStore tradeFilterStore;

  WalletService _walletService;
  TransactionHistory _history;
  TradeHistory _tradeHistory;
  SettingsStore _settingsStore;
  Account _account;
  StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<List<TransactionInfo>> _onTransactionsChangeSubscription;
  StreamSubscription<Account> _onAccountChangeSubscription;

  ActionListBase(
      {@required WalletService walletService,
      @required TradeHistory tradeHistory,
      @required SettingsStore settingsStore,
      @required this.transactionFilterStore,
      @required this.tradeFilterStore}) {
    transactions = List<TransactionListItem>();
    trades = List<TradeListItem>();
    _walletService = walletService;
    _settingsStore = settingsStore;
    _tradeHistory = tradeHistory;

    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);

    updateTradeList();
  }

  @override
  void dispose() {
    if (_onTransactionsChangeSubscription != null) {
      _onTransactionsChangeSubscription.cancel();
    }

    if (_onAccountChangeSubscription != null) {
      _onAccountChangeSubscription.cancel();
    }

    _onWalletChangeSubscription.cancel();
    super.dispose();
  }

  @action
  Future updateTradeList() async {
    final trades = await _tradeHistory.all();
    this.trades = trades.map((trade) => TradeListItem(trade: trade)).toList();
  }

  Future _updateTransactionsList() async {
    await _history.refresh();
    final _transactions = await _history.getAll();
    await _setTransactions(_transactions);
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (_onTransactionsChangeSubscription != null) {
      _onTransactionsChangeSubscription.cancel();
    }

    if (_onAccountChangeSubscription != null) {
      _onAccountChangeSubscription.cancel();
    }

    _history = wallet.getHistory();
    _onTransactionsChangeSubscription = _history.transactions
        .listen((transactions) => _setTransactions(transactions));

    if (wallet is MoneroWallet) {
      _account = wallet.account;
      _onAccountChangeSubscription = wallet.onAccountChange.listen((account) {
        _account = account;
        _updateTransactionsList();
      });
    }

    await _updateTransactionsList();
  }

  Future _setTransactions(List<TransactionInfo> transactions) async {
    List<TransactionInfo> _transactions;

    final wallet = _walletService.currentWallet;

    if (wallet is MoneroWallet) {
      _transactions =
          transactions.where((tx) => tx.accountIndex == _account.id).toList();
    } else {
      _transactions = transactions;
    }

    this.transactions = _transactions
        .map((tx) {
          // final amount = _price * tx.amountRaw();
          final fiatAmount = '0 ${_settingsStore.fiatCurrency}';
          tx.changeFiatAmount(fiatAmount);
          return tx;
        })
        .map((tx) => TransactionListItem(transaction: tx))
        .toList();
  }
}
