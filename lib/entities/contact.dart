import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:cake_wallet/entities/crypto_currency.dart';
import 'package:cake_wallet/utils/mobx.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject with Keyable {
  Contact({@required this.name, @required this.address, CryptoCurrency type})
      : raw = type?.raw;

  static const boxName = 'Contacts';

  @HiveField(0)
  String name;

  @HiveField(1)
  String address;

  @HiveField(2)
  int raw;

  CryptoCurrency get type => CryptoCurrency.deserialize(raw: raw);

  @override
  dynamic get keyIndex => key;

  @override
  bool operator ==(Object o) => o is Contact && o.key == key;

  @override
  int get hashCode => key.hashCode;

  void updateCryptoCurrency({@required CryptoCurrency currency}) =>
      raw = currency.raw;
}
