import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/monero/account.dart';

class AccountList {
  get subaddresses => _subaddress.stream;
  BehaviorSubject<List<Account>> _subaddress;

  MethodChannel _platform;
  bool _isRefreshing;
  bool _isUpdating;

  AccountList({MethodChannel platform}) {
    this._platform = platform;
    _isRefreshing = false;
    _isUpdating = false;
    _subaddress = BehaviorSubject<List<Account>>();
  }

  Future update() async {
    if (_isUpdating) {
      return;
    }

    try {
      _isUpdating = true;
      await refresh(accountIndex: 0);
      final transactions = await getAll();
      _subaddress.add(transactions);
      _isUpdating = false;
    } catch (e) {
      _isUpdating = false;
      throw e;
    }
  }

  Future<List<Account>> getAll() async {
    List subaddresses = await _platform.invokeMethod('getAllAccounts');
    return subaddresses.map((tx) => Account.fromMap(tx)).toList();
  }

  Future addAccount({String label}) async {
    final arguments = {'label': label};
    await _platform.invokeMethod('addAccount', arguments);
  }

  Future setLabelSubaddress({int accountIndex, String label}) async {
    final arguments = {'accountIndex': accountIndex, 'label': label};
    await _platform.invokeMethod('setLabelAccount', arguments);
    update();
  }

  Future refresh({int accountIndex}) async {
    if (_isRefreshing) {
      return;
    }

    try {
      _isRefreshing = true;
      await _platform.invokeMethod('refreshAccounts');
      _isRefreshing = false;
    } on PlatformException catch (e) {
      _isRefreshing = false;
      print(e);
      throw e;
    }
  }
}
