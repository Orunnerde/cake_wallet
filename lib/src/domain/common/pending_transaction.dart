import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PendingTransaction {
  final int id;
  final MethodChannel platform;

  PendingTransaction({@required this.id, @required this.platform});

  Future<void> commit() async {
    final arguments = {'id': id};
    await platform.invokeMethod('commitTransaction', arguments);
  }
}