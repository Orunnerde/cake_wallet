import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cake_wallet/src/monero_wallet_manager.dart';

enum WalletStoreKey { MONERO_WALLET_PASSWORD, PIN_CODE_PASSWORD }

const MONERO_WALLET_PASSWORD = "MONERO_WALLET_PASSWORD";
const PIN_CODE_PASSWORD = "PIN_CODE_PASSWORD";

String generateStoreKeyFor(String walletName, WalletStoreKey key) {
  var _key = "";

  switch (key) {
   
    case WalletStoreKey.MONERO_WALLET_PASSWORD: {
      _key = MONERO_WALLET_PASSWORD + "_" + walletName.toUpperCase();
    }
    break;

    case WalletStoreKey.PIN_CODE_PASSWORD: {
      _key = PIN_CODE_PASSWORD;
    }
    break;

    default: {}
  }

  return _key;
}

class WalletsService {
  static final _moneroWalletManager = MoneroWalletManager();
  static final _storage = new FlutterSecureStorage();
 
  Future<void> createWallet(String name) async {
    final password = Uuid().v4();
    final key = generateStoreKeyFor(name, WalletStoreKey.MONERO_WALLET_PASSWORD);
    await _storage.write(key: key, value: password);
    _moneroWalletManager.createWallet(name, password);
  }

  Future<void> openWallet(String name) async {
    final key = generateStoreKeyFor(name, WalletStoreKey.MONERO_WALLET_PASSWORD);
    final password = await _storage.read(key: key);
    _moneroWalletManager.openWallet(name, password);
  }
}