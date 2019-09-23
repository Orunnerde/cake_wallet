import 'package:cake_wallet/src/domain/common/transaction_direction.dart';

String formatAmount(String originAmount) {
  int lastIndex = 0;

  for (int i = originAmount.length - 1; i >= 0; i--) {
    if (originAmount[i] == "0") {
      lastIndex = i;
    } else {
      break;
    }
  }

  if (lastIndex < 3) {
    lastIndex = 3;
  }

  return originAmount.substring(0, lastIndex);
}

class TransactionInfo {
  final String id;
  final String height;
  final TransactionDirection direction;
  final DateTime date;
  final int accountIndex;
  final String _amount;

  TransactionInfo.fromMap(Map map)
      : id = map['hash'] ?? '',
        height = map['height'] ?? '',
        direction = parseTransactionDirectionFromNumber(map['direction']) ??
            TransactionDirection.incoming,
        date = DateTime.fromMillisecondsSinceEpoch(
            (int.parse(map['timestamp']) ?? 0) * 1000),
        _amount = map['amount'],
        accountIndex = int.parse(map['accountIndex']);

  TransactionInfo(this.id, this.height, this.direction, this.date, this._amount,
      this.accountIndex);

  String amount() {
    return '${formatAmount(_amount)} XMR';
  }

  String fiatAmount() {
    return '0 USD';
  }
}
