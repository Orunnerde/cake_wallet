import 'package:cake_wallet/src/domain/common/contact.dart';
import 'package:sqflite/sqflite.dart';

class AddressBookService {
  Database _db;

  AddressBookService({Database db}) {
    _db = db;
  }

  Future add({Contact contact}) async {
    await _db.insert(Contact.tableName, contact.toMap());
  }

  Future<List<Contact>> getAll() async {
    final result = await _db.query(Contact.tableName);
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  Future change({Contact contact}) async {
    await _db.update(Contact.tableName, contact.toMap(), where: '${Contact.primaryKey} = ?', whereArgs: [contact.id]);
  }

  Future delete({Contact contact}) async {
    await _db.delete(Contact.tableName, where: '${Contact.primaryKey} = ?', whereArgs: [contact.id]);
  }
}