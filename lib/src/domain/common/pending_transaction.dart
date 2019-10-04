import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PendingTransaction {
  final int id;
  final String amount;
  final String fee;
  final String hash;
  final MethodChannel platform;

  PendingTransaction(
      {@required this.id,
      @required this.amount,
      @required this.fee,
      @required this.hash,
      @required this.platform});

  PendingTransaction.fromMap(Map map, MethodChannel platform):
    id = int.parse(map['id']),
    amount = map['amount'] ?? '',
    fee = map['fee'] ?? '',
    hash = map['hash'] ?? '',
    platform = platform;

  Future<void> commit() async {
    final arguments = {'id': id};
    await platform.invokeMethod('commitTransaction', arguments);
  }
}
