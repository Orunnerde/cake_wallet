import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cake_wallet/src/domain/common/wallet_info.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/common/wallets_manager.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/common/wallet_description.dart';
import 'package:cake_wallet/src/domain/common/path_for_wallet.dart';
import 'package:cake_wallet/src/domain/bitcoin/bitcoin_wallet.dart';

class BitcoinWalletsManager extends WalletsManager {
  BitcoinWalletsManager({@required this.walletInfoSource});

  static const type = WalletType.bitcoin;
  static const bitcoinWalletManagerChannel = MethodChannel('com.cakewallet.cake_wallet/bitcoin-wallet-manager');

  Box<WalletInfo> walletInfoSource;

  @override
  Future<Wallet> create(String name, String password, String language) async {
    try {
      const isRecovery = false;
      final path = await pathForWallet(name: name);
      
      final bool isCreated = await bitcoinWalletManagerChannel.invokeMethod<bool>('createWallet', <String, String> {
        'path' : path,
        'password' : password
      });

      if (isCreated) {
        final wallet = await BitcoinWallet.createdWallet(
            walletInfoSource: walletInfoSource,
            name: name,
            isRecovery: isRecovery);
        await wallet.updateInfo();

        return wallet;
      } else {
        return null;
      }
    } catch (e) {
      print('BitcoinWalletsManager Error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isWalletExit(String name) async {
    final id =
        walletTypeToString(type).toLowerCase() + '_' + name;
    final info = walletInfoSource.values
        .firstWhere((info) => info.id == id, orElse: () => null);
    return info != null;
  }

  @override
  Future<Wallet> openWallet(String name, String password) async {
    try {
      final path = await pathForWallet(name: name);

      final isOpened = await bitcoinWalletManagerChannel.invokeMethod<bool>('openWallet', <String, String> {
        'path' : path,
        'password' : password
      });

      if (isOpened) {
        final wallet = await BitcoinWallet.load(walletInfoSource, name, type);
        await wallet.updateInfo();

        return wallet;
      } else {
        return null;
      }
    } catch (e) {
      print('BitcoinWalletsManager Error: $e');
      rethrow;
    }
  }

  @override
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
    final info = walletInfoSource.values
        .firstWhere((info) => info.id == id, orElse: () => null);

    await info?.delete();
  }

  @override
  Future<Wallet> restoreFromKeys(
      String name,
      String password,
      String language,
      int restoreHeight,
      String address,
      String viewKey,
      String spendKey) async {
    try {
      const isRecovery = true;
      final path = await pathForWallet(name: name);

      final isRestored = await bitcoinWalletManagerChannel.invokeMethod<bool>('restoreWalletFromKey', <String, String> {
        'path' : path,
        'password' : password,
        'privateKey' : viewKey
      });

      if (isRestored) {
        final wallet = await BitcoinWallet.createdWallet(
            walletInfoSource: walletInfoSource,
            name: name,
            isRecovery: isRecovery);
        await wallet.updateInfo();

        return wallet;
      } else {
        return null;
      }
    } catch (e) {
      print('BitcoinWalletsManager Error: $e');
      rethrow;
    }
  }

  @override
  Future<Wallet> restoreFromSeed(
      String name,
      String password,
      String seed,
      int restoreHeight) async {
    try {
      const isRecovery = true;
      final path = await pathForWallet(name: name);
      final List spitedSeed = seed.split(' ');

      final bool isRestored = await bitcoinWalletManagerChannel.invokeMethod<bool>('restoreWalletFromSeed', <String, dynamic> {
        'path' : path,
        'password' : password,
        'seed' : spitedSeed,
        'passphrase' : ''
      });

      if (isRestored) {
        final wallet = await BitcoinWallet.createdWallet(
            walletInfoSource: walletInfoSource,
            name: name,
            isRecovery: isRecovery);
        await wallet.updateInfo();

        return wallet;
      } else {
        return null;
      }
    } catch (e) {
      print('BitcoinWalletsManager Error: $e');
      rethrow;
    }
  }
}