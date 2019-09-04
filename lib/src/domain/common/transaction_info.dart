import 'package:cake_wallet/src/domain/common/transaction_direction.dart';

class TransactionInfo {
  final String id;
  final String height;
  final TransactionDirection direction;
  final DateTime date;
  final String _amount;

  TransactionInfo.fromMap(Map map) :
    id = map['hash'] ?? '',
    height = map['height'] ?? '',
    direction = parseTransactionDirectionFromNumber(map['direction']) ?? TransactionDirection.INCOMING,
    date = DateTime.fromMillisecondsSinceEpoch((int.parse(map['timestamp']) ?? 0) * 1000),
    _amount = map['amount'];

  TransactionInfo(this.id, this.height, this.direction, this.date, this._amount);

  String amount() {
    return '$_amount XMR';
  }

  String fiatAmount() {
    return '0 USD';
  }
}