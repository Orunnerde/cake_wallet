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

  Future update({int accountIndex}) async {
    if (_isUpdating) {
      return;
    }

    try {
      _isUpdating = true;
      await refresh(accountIndex: accountIndex);
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
      return subaddresses.map((sub) {
        // Replace label of first subaddress from Primary account to Primary
        if (sub['id'] == "0" && sub['label'] == "Primary account") {
          sub['label'] = 'Primary';
        }
        return Subaddress.fromMap(sub);
      }).toList();
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future addSubaddress({int accountIndex, String label}) async {
    try {
      final arguments = {'accountIndex': accountIndex, 'label': label};
      await _platform.invokeMethod('addSubaddress', arguments);
      update(accountIndex: accountIndex);
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future setLabelSubaddress(
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

  Future refresh({int accountIndex}) async {
    if (_isRefreshing) {
      return;
    }

    try {
      _isRefreshing = true;
      final arguments = {'accountIndex': accountIndex};
      await _platform.invokeMethod('refreshSubaddresses', arguments);
      _isRefreshing = false;
    } on PlatformException catch (e) {
      _isRefreshing = false;
      print(e);
      throw e;
    }
  }
}
