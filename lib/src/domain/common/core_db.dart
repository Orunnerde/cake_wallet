import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:cake_wallet/src/domain/common/contact.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/src/domain/common/recipient_address_list.dart';
import 'package:cake_wallet/src/domain/exchange/trade_history.dart';

class CoreDB {
  static const dbName = 'cw';
  static CoreDB _instance;

  static Future<CoreDB> getInstance() async {
    if (_instance == null) {
      final dbPath = await getDatabasesPath();
      final path = dbPath + dbName;
      _instance = CoreDB(path: path);
    }

    return _instance;
  }

  final String path;

  CoreDB({this.path});

  Database _db;

  Future<Database> getDb() async {
    if (_db == null) {
      _db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Wallets (id TEXT PRIMARY KEY, name TEXT, is_recovery NUMERIC, restore_height INTEGER)');
        await db.execute('CREATE TABLE ${NodeList.tableName}' +
            '(${NodeList.idColumn} INTEGER PRIMARY KEY,' +
            '${NodeList.uriColumn} TEXT KEY,' +
            '${NodeList.loginColumn} TEXT,' +
            '${NodeList.passwordColumn} TEXT,' +
            '${NodeList.isDefault} NUMERIC);');
        await db.execute('CREATE TABLE ${Contact.tableName}' +
            '(${Contact.primaryKey} INTEGER PRIMARY KEY,' +
            '${Contact.nameColumn} TEXT,' +
            '${Contact.addressColumn} TEXT,' +
            '${Contact.typeColumn} NUMERIC);');
        await db.execute('CREATE TABLE ${TradeHistory.tableName} ' +
            '(${TradeHistory.idColumn} TEXT PRIMARY KEY,' +
            '${TradeHistory.providerColumn} NUMERIC,' +
            '${TradeHistory.fromColumn} NUMERIC,' +
            '${TradeHistory.toColumn} NUMERIC,' +
            '${TradeHistory.dateColumn} INTEGER);');
        await db.execute('CREATE TABLE ${RecipientAddressList.tableName}' +
            '(${RecipientAddressList.idColumn} INTEGER PRIMARY KEY,' +
            '${RecipientAddressList.recipientAddressColumn} TEXT,' +
            '${RecipientAddressList.transactionIdColumn} TEXT KEY);');
      });
    }
    return _db;
  }
}
