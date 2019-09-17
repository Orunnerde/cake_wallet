import 'dart:async';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/common/wallet_description.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cake_wallet/src/domain/common/wallets_manager.dart';
import 'package:cake_wallet/src/domain/common/secret_store_key.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallets_manager.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  static const dbName = 'cw';
  static DbHelper _instance;

  static Future<DbHelper> getInstance() async {
    if (_instance == null) {
      final dbPath = await getDatabasesPath();
      final path = dbPath + dbName;
      _instance = DbHelper(path: path);
    }

    return _instance;
  }

  final String path;

  DbHelper({this.path});

  Database _db;

  Future<Database> getDb() async {
    if (_db == null) {
      _db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Wallets (id TEXT PRIMARY KEY, name TEXT, is_recovery NUMERIC, restore_height INTEGER);' +
                'CREATE TABLE ${NodeList.tableName}' +
                '(${NodeList.tableName} INTEGER PRIMARY KEY,' +
                '${NodeList.uriColumn} TEXT PRIMARY KEY,' +
                '${NodeList.loginColumn} TEXT,' +
                '${NodeList.passwordColumn} TEXT,' +
                '${NodeList.isDefault} NUMERIC);');
      });
    }
    return _db;
  }
}

class WalletIsExistException implements Exception {
  String name;

  WalletIsExistException(this.name);

  @override
  String toString() {
    return "Wallet with name $name is already exist!";
  }
}

class WalletListService {
  final FlutterSecureStorage secureStorage;
  final WalletService walletService;
  final Database db;
  final SharedPreferences sharedPreferences;
  WalletsManager walletsManager;

  WalletListService(
      {this.secureStorage,
      this.db,
      this.walletsManager,
      @required this.walletService,
      @required this.sharedPreferences});

  Future<List<WalletDescription>> getAll() async {
    List<Map> result = await db.query('wallets', columns: ['name']);
    List<WalletDescription> wallets = result
        .map((res) =>
            WalletDescription(name: res['name'], type: WalletType.MONERO))
        .toList();

    return wallets;
  }

  Future<void> create(String name) async {
    if (await walletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    if (walletService.currentWallet != null) {
      await walletService.close();
    }

    final password = Uuid().v4();
    final key = generateStoreKeyFor(
        key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    await secureStorage.write(key: key, value: password);

    final wallet = await walletsManager.create(name, password);

    await onWalletChange(wallet);
  }

  Future<void> restoreFromSeed(
      String name, String seed, int restoreHeight) async {
    if (await walletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    if (walletService.currentWallet != null) {
      await walletService.close();
    }

    final password = Uuid().v4();
    final key = generateStoreKeyFor(
        key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    await secureStorage.write(key: key, value: password);

    final wallet = await walletsManager.restoreFromSeed(
        name, password, seed, restoreHeight);

    await onWalletChange(wallet);
  }

  Future<void> restoreFromKeys(String name, int restoreHeight, String address,
      String viewKey, String spendKey) async {
    if (await walletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    if (walletService.currentWallet != null) {
      await walletService.close();
    }

    final password = Uuid().v4();
    final key = generateStoreKeyFor(
        key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    await secureStorage.write(key: key, value: password);

    final wallet = await walletsManager.restoreFromKeys(
        name, password, restoreHeight, address, viewKey, spendKey);

    await onWalletChange(wallet);
  }

  Future<void> openWallet(String name) async {
    if (walletService.currentWallet != null) {
      await walletService.close();
    }

    final key = generateStoreKeyFor(
        key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    final password = await secureStorage.read(key: key);
    final wallet = await walletsManager.openWallet(name, password);

    await onWalletChange(wallet);
  }

  Future<void> changeWalletManger({WalletType walletType}) async {
    switch (walletType) {
      case WalletType.MONERO:
        final dbHelper = await DbHelper.getInstance();
        final db = await dbHelper.getDb();
        walletsManager = MoneroWalletsManager(db: db);
        break;
      case WalletType.NONE:
        walletsManager = null;
        break;
    }
  }

  Future<void> onWalletChange(Wallet wallet) async {
    walletService.currentWallet = wallet;
    final walletName = await wallet.getName();
    await sharedPreferences.setString('current_wallet_name', walletName);
    await walletService.connectToNode(
        uri: 'node.moneroworld.com:18089', login: '', password: '');
    await walletService.startSync();
  }

  Future<void> remove(WalletDescription wallet) async {
    await walletsManager.remove(wallet);
  }
}
