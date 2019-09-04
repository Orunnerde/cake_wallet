import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';

class MoneroTransactionHistory extends TransactionHistory {
  
  get transactions => _transactions.stream;
  BehaviorSubject<List<TransactionInfo>> _transactions;
  
  MethodChannel _platform;

  MoneroTransactionHistory({MethodChannel platform}) {
    this._platform = platform;
    _transactions = BehaviorSubject<List<TransactionInfo>>();
  }

  Future<void> update() async {
    await refresh();
    final transactions = await getAll();
    _transactions.add(transactions);
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
    try {
      return await _platform.invokeMethod('refreshTransactionHistory');
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }
}
