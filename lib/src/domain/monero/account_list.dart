import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cw_monero/account_list.dart' as accountListAPI;
import 'package:cake_wallet/src/domain/monero/account.dart';

class AccountList {
  get subaddresses => _accounts.stream;
  BehaviorSubject<List<Account>> _accounts;

  bool _isRefreshing;
  bool _isUpdating;

  AccountList() {
    _isRefreshing = false;
    _isUpdating = false;
    _accounts = BehaviorSubject<List<Account>>();
  }

  Future update() async {
    if (_isUpdating) {
      return;
    }

    try {
      _isUpdating = true;
      await refresh();
      final accounts = getAll();
      _accounts.add(accounts);
      _isUpdating = false;
    } catch (e) {
      _isUpdating = false;
      throw e;
    }
  }

  List<Account> getAll() {
    return accountListAPI
        .getAllAccount()
        .map((accountRow) => Account.fromRow(accountRow))
        .toList();
  }

  addAccount({String label}) {
    accountListAPI.addAccount(label: label);
  }

  setLabelSubaddress({int accountIndex, String label}) {
    accountListAPI.setLabelForAccount(accountIndex: accountIndex, label: label);
    update();
  }

  refresh() {
    if (_isRefreshing) {
      return;
    }

    try {
      _isRefreshing = true;
      accountListAPI.refreshAccounts();
      _isRefreshing = false;
    } on PlatformException catch (e) {
      _isRefreshing = false;
      print(e);
      throw e;
    }
  }
}
