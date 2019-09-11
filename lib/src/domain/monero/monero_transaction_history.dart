import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';

class MoneroTransactionHistory extends TransactionHistory {
  
  get transactions => _transactions.stream;
  BehaviorSubject<List<TransactionInfo>> _transactions;

  bool _isUpdating = false;
  bool _isRefreshing = false;
  
  MethodChannel _platform;

  MoneroTransactionHistory({MethodChannel platform}) {
    this._platform = platform;
    _transactions = BehaviorSubject<List<TransactionInfo>>();
  }

  Future<void> update() async {
    if (_isUpdating) { return; }
    
    _isUpdating = true;
    await refresh();
    final transactions = await getAll();
    _transactions.add(transactions);
    _isUpdating = false;
  }

  Future<List<TransactionInfo>> getAll() async {
    try {
      List transactions = await _platform.invokeMethod('getAllTransactions');
      return transactions.map((tx) => TransactionInfo.fromMap(tx)).toList();
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<int> count() async {
    try {
      return await _platform.invokeMethod('getTransactionsCount');
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> refresh() async {
    if (_isRefreshing) { return; }

    try {
      _isRefreshing = true;
      return await _platform.invokeMethod('refreshTransactionHistory');
      _isRefreshing = false;
    } on PlatformException catch (e) {
      _isRefreshing = false;
      print(e);
      throw e;
    }
  }
}
