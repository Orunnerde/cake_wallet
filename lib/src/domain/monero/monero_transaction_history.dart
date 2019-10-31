import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/common/transaction_history.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';

class MoneroTransactionHistory extends TransactionHistory {
  
  get transactions => _transactions.stream;
  BehaviorSubject<List<TransactionInfo>> _transactions;

  bool _isUpdating = false;
  bool _isRefreshing = false;
  bool _needToCheckForRefresh = false;
  
  MethodChannel _platform;

  MoneroTransactionHistory({MethodChannel platform}) {
    this._platform = platform;
    _transactions = BehaviorSubject<List<TransactionInfo>>.seeded([]);
  }

  Future<void> update() async {
    if (_isUpdating) { return; }
    
    
    try {
      _isUpdating = true;
      final _isNeedToRefresh = _needToCheckForRefresh ? await isNeedToRefresh() : true;
      var transactions;

      // print ('_isNeedToRefresh $_isNeedToRefresh');
      
      if (_isNeedToRefresh) {
        await refresh();
        transactions = await getAll();
      } else {
        transactions = _transactions.value;
      }
      
      _transactions.add(transactions);
      
      _isUpdating = false;

      if (!_needToCheckForRefresh) { 
        _needToCheckForRefresh = true;
      }
    } catch (e) {
      _isUpdating = false;
      print(e);
      throw e;
    }
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

  Future<bool> isNeedToRefresh() async {
    try {
      return await _platform.invokeMethod('isNeedToRefresh');
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> refresh() async {
    if (_isRefreshing) { return; }

    try {
      _isRefreshing = true;
      await _platform.invokeMethod('refreshTransactionHistory');
      _isRefreshing = false;
    } on PlatformException catch (e) {
      _isRefreshing = false;
      print(e);
      throw e;
    }
  }
}
