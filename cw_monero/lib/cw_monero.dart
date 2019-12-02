import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:cw_monero/monero_api.dart';

class CwMonero {
  static const MethodChannel _channel = const MethodChannel('cw_monero');
  // static Isolate isolate;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');

    // var ourFirstReceivePort = ReceivePort();
    // isolate = await Isolate.spawn(setListener, ourFirstReceivePort.sendPort);
    // var setListenerPort = await ourFirstReceivePort.first;
    // setListenerPort

    // final walletName = 'test50';
    // await loadWallet(name: walletName, password: 'test');
    // final isExist = await isWalletExist(name: walletName);
    // print('isExist $isExist');
    // final filename = getFilename();
    // print('filename $filename');
    // final seed = getSeed();
    // print('seed $seed');
    // final address = getAddress();
    // print('address $address');
    // final fullBalance = getFullBalance();
    // print('fullBalance $fullBalance');
    // final unlockedBalance = getUnlockedBalance();
    // print('unlockedBalance $unlockedBalance');
    // final currentHeight = getCurrentHeight();
    // print('currentHeight $currentHeight');
    // final nodeHeight = getNodeHeight();
    // print('nodeHeight $nodeHeight');
    // // final isConnected0 = isConnected();
    // // print('isConnected0 $isConnected0');

    // print('Before setListener');

    // setListener();

    // print('Aftere setListener');

    // final isAddressSetted = setupNode(address: 'eu-node.cakewallet.io:18081', login: 'cake', password: 'public_node');
    // print('isAddressSetted $isAddressSetted');
    // final isConnected00 = connectToNode();
    // print('isConnected00 $isConnected00');
    // startRefresh();

    // final isConnected1 = isConnected();
    // print('isConnected1 $isConnected1');
    // // addSubaddress(accountIndex: 0, label: 'Test');
    // setLabelForSubaddress(accountIndex: 0, addressIndex: 0, label: 'AWESOME');
    // getAllSubaddresses();

    // refreshAccounts();
    // addAccount(label: 'Test account');
    // refreshAccounts();
    // getAllAccount();

    // addAccount(label: 'xxxx');

    // setLabelForAccount(label: 'zzzz', accountIndex: 1);

    // refreshAccounts();
    // getAllAccount();

    // refreshTransactions();
    // final transactionsCount = countOfTransactions();
    // print('transactionsCount $transactionsCount');
    // getAllTransations();

    return version;
  }
}
