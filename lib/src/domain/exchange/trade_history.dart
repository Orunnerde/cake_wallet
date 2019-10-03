import 'package:sqflite/sqflite.dart';
import 'package:cake_wallet/src/domain/exchange/trade.dart';

class TradeHistory {
  static const tableName = 'trades';
  static const idColumn = 'id';
  static const providerColumn = 'provider';
  static const fromColumn = 'input';
  static const toColumn = 'output';
  static const dateColumn = 'date';
  static const transactionIdColumn = 'transactioin_id';

  Database _db;

  TradeHistory({Database db}) : _db = db;

  Future<List<Trade>> all() async {
    final result = await _db.query(tableName);
    return result.map((map) => Trade.fromMap(map)).toList();
  }

  Future add({Trade trade}) async {
    await _db.insert(tableName, trade.toMap());
  }
}
