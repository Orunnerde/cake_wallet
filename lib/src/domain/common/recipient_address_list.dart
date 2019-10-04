import 'package:sqflite/sqlite_api.dart';

class RecipientAddressList {
  static const tableName = 'recipient_addresses';
  static const idColumn = 'id';
  static const recipientAddressColumn = 'recipient_address';
  static const transactionIdColumn = 'transactioin_id';

  Database _db;

  RecipientAddressList({Database db}) : _db = db;

  Future<List<Map<String, String>>> all() async {
    final result = await _db.query(tableName);
    return result.toList();
  }

  Future add({String recipientAddress, String transactionId}) async {
    await _db.insert(tableName, {
      recipientAddressColumn: recipientAddress,
      transactionIdColumn: transactionId
    });
  }

  Future findRecipientAddress({String transactionsId}) async {
    final result = await _db.query(tableName,
        where: '$transactionIdColumn = ?', whereArgs: [transactionsId]);

    if (result.length <= 0) {
      return null;
    }

    return result.toList().first[recipientAddressColumn];
  }
}
