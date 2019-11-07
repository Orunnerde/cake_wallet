import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/common/wallets_manager.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/domain/common/wallet_description.dart';

class MoneroWalletsManager extends WalletsManager {
  static const type = WalletType.monero;
  static const platform =
      const MethodChannel('com.cakewallet.wallet/monero-wallet-manager');

  Database db;

  MoneroWalletsManager({@required this.db});

  Future<Wallet> create(String name, String password) async {
    try {
      const isRecovery = false;
      final arguments = {'name': name, 'password': password};
      final int walletID =
          await platform.invokeMethod('createWallet', arguments);

      print('Created monero wallet with ID: $walletID, name: $name');

      final wallet = await MoneroWallet.createdWallet(
          db: db, name: name, isRecovery: isRecovery);
      await wallet.updateInfo();
      return wallet;
    } on PlatformException catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<Wallet> restoreFromSeed(
      String name, String password, String seed, int restoreHeight) async {
    try {
      const isRecovery = true;
      final arguments = {
        'name': name,
        'password': password,
        'seed': seed,
        'restoreHeight': restoreHeight
      };

      final int walletID =
          await platform.invokeMethod('recoveryWalletFromSeed', arguments);

      print('Restored monero wallet with ID: $walletID, name: $name');

      return await MoneroWallet.createdWallet(
          db: db,
          name: name,
          isRecovery: isRecovery,
          restoreHeight: restoreHeight)
        ..updateInfo();
    } on PlatformException catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<Wallet> restoreFromKeys(
      String name,
      String password,
      int restoreHeight,
      String address,
      String viewKey,
      String spendKey) async {
    try {
      const isRecovery = true;
      final arguments = {
        'name': name,
        'password': password,
        'restoreHeight': restoreHeight,
        'address': address,
        'viewKey': viewKey,
        'spendKey': spendKey
      };

      final int walletID =
          await platform.invokeMethod('recoveryWalletFromKeys', arguments);

      print('Restored monero wallet with ID: $walletID, name: $name');

      return await MoneroWallet.createdWallet(
          db: db,
          name: name,
          isRecovery: isRecovery,
          restoreHeight: restoreHeight)
        ..updateInfo();
    } on PlatformException catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<Wallet> openWallet(String name, String password) async {
    try {
      final arguments = {'name': name, 'password': password};
      final int walletID = await platform.invokeMethod('openWallet', arguments);

      print('Start opening wallet');

      final wallet = await MoneroWallet.load(db, name, type);

      print('Opened monero wallet with ID: $walletID, name: $name');

      await wallet.updateInfo();
      return wallet;
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

  Future<void> remove(WalletDescription wallet) async {
    final dir = await getApplicationDocumentsDirectory();
    final root = dir.path.replaceAll('app_flutter', 'files');
    final walletFilePath = root + '/cw_monero/' + wallet.name;
    final keyPath = walletFilePath + '.keys';
    final addressFilePath = walletFilePath + '.address.txt';
    final walletFile = File(walletFilePath);
    final keyFile = File(keyPath);
    final addressFile = File(addressFilePath);

    if (await walletFile.exists()) {
      await walletFile.delete();
    }

    if (await keyFile.exists()) {
      await keyFile.delete();
    }

    if (await addressFile.exists()) {
      await addressFile.delete();
    }

    final id =
        walletTypeToString(wallet.type).toLowerCase() + '_' + wallet.name;
    await db.delete(Wallet.walletsTable,
        where: '${Wallet.idColumn} = ?', whereArgs: [id]);
  }
}
