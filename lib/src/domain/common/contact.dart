import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';

class Contact {
  static final String tableName = 'AddressBook';
  static final String primaryKey = 'id';
  static final String nameColumn = 'name';
  static final String typeColumn = 'type';

  static Contact fromMap(Map map) {
    return Contact(
        name: map['name'], type: CryptoCurrency.deserialize(raw: map['type']));
  }

  final String name;
  final CryptoCurrency type;

  Contact({@required this.name, @required this.type});

  Map<String, dynamic> toMap() {
    return {nameColumn: name, typeColumn: type.serialize()};
  }
}
