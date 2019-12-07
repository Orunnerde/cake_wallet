import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:cw_monero/wallet_manager.dart' as moneroWalletManager;
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/common/wallets_manager.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallet.dart';
import 'package:cake_wallet/src/domain/common/wallet_description.dart';

Future<String> pathForWallet({String name}) async {
  final directory = await getApplicationDocumentsDirectory();
  final pathDir = directory.path + '/$name';
  final dir = Directory(pathDir);

  if (!await dir.exists()) {
    await dir.create();
  }

  return pathDir + '/$name';
}

_openWallet(args) => moneroWalletManager.loadWallet(
    path: args['path'], password: args['password']);

_createWallet(args) => moneroWalletManager.createWallet(
    path: args['path'], password: args['password']);

_restoreFromSeed(args) => moneroWalletManager.restoreWalletFromSeed(
    path: args['path'],
    password: args['password'],
    seed: args['seed'],
    restoreHeight: args['restoreHeight']);

_restoreFromKeys(args) => moneroWalletManager.restoreWalletFromKeys(
    path: args['path'],
    password: args['password'],
    restoreHeight: args['restoreHeight'],
    address: args['address'],
    viewKey: args['viewKey'],
    spendKey: args['spendKey']);

class MoneroWalletsManager extends WalletsManager {
  static const type = WalletType.monero;

  Database db;

  MoneroWalletsManager({@required this.db});

  Future<Wallet> create(String name, String password) async {
    try {
      const isRecovery = false;
      final path = await pathForWallet(name: name);

      await compute(_createWallet, {'path': path, 'password': password});

      final wallet = await MoneroWallet.createdWallet(
          db: db, name: name, isRecovery: isRecovery)
        ..updateInfo();
      return wallet;
    } catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<Wallet> restoreFromSeed(
      String name, String password, String seed, int restoreHeight) async {
    try {
      const isRecovery = true;
      final path = await pathForWallet(name: name);

      await compute(_restoreFromSeed, {
        'path': path,
        'password': password,
        'seed': seed,
        'restoreHeight': restoreHeight
      });

      return await MoneroWallet.createdWallet(
          db: db,
          name: name,
          isRecovery: isRecovery,
          restoreHeight: restoreHeight)
        ..updateInfo();
    } catch (e) {
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
      final path = await pathForWallet(name: name);

      await compute(_restoreFromKeys, {
        'path': path,
        'password': password,
        'restoreHeight': restoreHeight,
        'address': address,
        'viewKey': viewKey,
        'spendKey': spendKey
      });

      final wallet = await MoneroWallet.createdWallet(
          db: db,
          name: name,
          isRecovery: isRecovery,
          restoreHeight: restoreHeight)
        ..updateInfo();
      return wallet;
    } catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<Wallet> openWallet(String name, String password) async {
    try {
      final start = DateTime.now().millisecondsSinceEpoch;
      final path = await pathForWallet(name: name);

      await compute(_openWallet, {'path': path, 'password': password});
      final loadWallet = DateTime.now().millisecondsSinceEpoch;
      print('Loaded wallet ${loadWallet - start}');
      final wallet = await MoneroWallet.load(db, name, type)
        ..updateInfo();
      final preReturn = DateTime.now().millisecondsSinceEpoch;
      print('Pre return ${preReturn - start}');
      return wallet;
    } catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future<bool> isWalletExit(String name) async {
    try {
      final path = await pathForWallet(name: name);
      return moneroWalletManager.isWalletExist(path: path);
    } catch (e) {
      print('MoneroWalletsManager Error: $e');
      throw e;
    }
  }

  Future remove(WalletDescription wallet) async {
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
