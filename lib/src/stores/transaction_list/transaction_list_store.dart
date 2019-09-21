import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';

part 'transaction_list_store.g.dart';

class TransactionListStore = TransactionListBase with _$TransactionListStore;

abstract class TransactionListBase with Store {
  @observable
  List<TransactionInfo> transactions;

  TransactionHistory _history;
  StreamSubscription<Wallet> _onWalletChangeSubscription;
  StreamSubscription<List<TransactionInfo>> _onTransactionsChangeSubscription;

  TransactionListBase({@required WalletService walletService}) {
    if (walletService.currentWallet != null) {
      _onWalletChanged(walletService.currentWallet);
    }

    _onWalletChangeSubscription =
        walletService.onWalletChange.listen(_onWalletChanged);
  }

  @override
  void dispose() {
    if (_onTransactionsChangeSubscription != null) {
      _onTransactionsChangeSubscription.cancel();
    }

    _onWalletChangeSubscription.cancel();
    super.dispose();
  }

  Future _updateTransactionsList() async {
    await _history.refresh();
    transactions = await _history.getAll();
  }

  Future _onWalletChanged(Wallet wallet) async {
    if (_onTransactionsChangeSubscription != null) {
      _onTransactionsChangeSubscription.cancel();
    }

    _history = wallet.getHistory();
    _onTransactionsChangeSubscription = _history.transactions
        .listen((transactions) => this.transactions = transactions);
    await _updateTransactionsList();
  }
}
