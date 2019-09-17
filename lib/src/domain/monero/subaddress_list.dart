import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cake_wallet/src/domain/monero/subaddress.dart';

class SubaddressList {
  get subaddresses => _subaddress.stream;
  BehaviorSubject<List<Subaddress>> _subaddress;

  MethodChannel _platform;
  bool _isRefreshing;
  bool _isUpdating;

  SubaddressList({MethodChannel platform}) {
    this._platform = platform;
    _isRefreshing = false;
    _isUpdating = false;
    _subaddress = BehaviorSubject<List<Subaddress>>();
  }

  Future<void> update() async {
    if (_isUpdating) { return; }
    
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

  Future<List<Subaddress>> getAll() async {
    try {
      List subaddresses = await _platform.invokeMethod('getAllSubaddresses');
      return subaddresses.map((tx) => Subaddress.fromMap(tx)).toList();
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addSubaddress({int accountIndex, String label}) async {
    try {
      final arguments = {'accountIndex': accountIndex, 'label': label};
      await _platform.invokeMethod('addSubaddress', arguments);
      update();
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> setLabelSubaddress(
      {int accountIndex, int addressIndex, String label}) async {
    try {
      final arguments = {
        'accountIndex': accountIndex,
        'addressIndex': addressIndex,
        'label': label
      };
      await _platform.invokeMethod('setSubaddressLabel', arguments);
      update();
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> refresh({int accountIndex}) async {
    if (_isRefreshing) { return; }

    try {
      _isRefreshing = true;
      final arguments = {
        'accountIndex': accountIndex
      };
      await _platform.invokeMethod('refreshSubaddresses', arguments);
      _isRefreshing = false;
    } on PlatformException catch (e) {
      _isRefreshing = false;
      print(e);
      throw e;
    }
  }
}