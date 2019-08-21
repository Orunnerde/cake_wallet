import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cake_wallet/src/monero_wallets_manager.dart';
import 'package:cake_wallet/src/secret_store_key.dart';


class WalletIsExistException implements Exception {
  String name;
  WalletIsExistException(this.name);

  @override
  String toString() {
    return "Wallet with name $name is already exist!";
  }
}

class WalletsService {
  static final _moneroWalletsManager = MoneroWalletsManager();

  final FlutterSecureStorage secureStorage;

  WalletsService({this.secureStorage});

  Future<void> create(String name) async {
    if (await _moneroWalletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    final password = Uuid().v4();
    final key =
        generateStoreKeyFor(key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    await secureStorage.write(key: key, value: password);
    _moneroWalletsManager.create(name, password);
  }

  Future<void> restoreFromSeed(
      String name, String seed, int restoreHeight) async {
    if (await _moneroWalletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    final password = Uuid().v4();
    final key =
        generateStoreKeyFor(key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    await secureStorage.write(key: key, value: password);
    _moneroWalletsManager.restoreFromSeed(name, password, seed, restoreHeight);
  }

  Future<void> restoreFromKeys(String name, int restoreHeight, String address,
      String viewKey, String spendKey) async {
    if (await _moneroWalletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    final password = Uuid().v4();
    final key =
        generateStoreKeyFor(key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    await secureStorage.write(key: key, value: password);
    _moneroWalletsManager.restoreFromKeys(
        name, password, restoreHeight, address, viewKey, spendKey);
  }

  Future<void> openWallet(String name) async {
    final key =
        generateStoreKeyFor(key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    final password = await secureStorage.read(key: key);
    _moneroWalletsManager.openWallet(name, password);
  }
}
