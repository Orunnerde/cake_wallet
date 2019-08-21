import 'dart:async';
import 'package:flutter/services.dart';

class MoneroWalletsManager {
  static const platform =
      const MethodChannel('com.cakewallet.wallet/monero-wallet-manager');

  Future<void> create(String name, String password) async {
    try {
      final arguments = {'name': name, 'password': password};
      final int walletID =
          await platform.invokeMethod('createWallet', arguments);
      print('Created monero wallet with ID: $walletID, name: $name');
    } on PlatformException catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<void> restoreFromSeed(
      String name, String password, String seed, int restoreHeight) async {
    try {
      final arguments = {
        'name': name,
        'password': password,
        'seed': seed,
        'restoreHeight': restoreHeight
      };

      final int walletID =
          await platform.invokeMethod('restoreFromSeed', arguments);
      print('Restored monero wallet with ID: $walletID, name: $name');
    } on PlatformException catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<void> restoreFromKeys(
      String name, String password, int restoreHeight, String address, String viewKey, String spendKey) async {
    try {
      final arguments = {
        'name': name,
        'password': password,
        'restoreHeight': restoreHeight,
        'address': address,
        'viewKey': viewKey,
        'spendKey': spendKey
      };

      final int walletID =
          await platform.invokeMethod('restoreFromKeys', arguments);
      print('Restored monero wallet with ID: $walletID, name: $name');
    } on PlatformException catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<void> openWallet(String name, String password) async {
    try {
      final arguments = {'name': name, 'password': password};
      final int walletID = await platform.invokeMethod('openWallet', arguments);
      print('Opened monero wallet with ID: $walletID, name: $name');
    } on PlatformException catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<bool> isWalletExit(String name) async {
    try {
      final arguments = {'name': name};
      return await platform.invokeMethod('isWalletExist', arguments);
    } on PlatformException catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }
}

class MoneroWallet {
  static const platform =
      const MethodChannel('com.cakewallet.wallet/monero-wallet');
  static Future<T> getValue<T>(String key) async {
    try {
      return await platform.invokeMethod(key);
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<String> getFilename() async {
    return getValue('getFilename');
  }

  Future<String> getAddress() async {
    return getValue('getAddress');
  }

  Future<String> getSeed() async {
    return getValue('getSeed');
  }
}
