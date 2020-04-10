import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'bitcoin_node.g.dart';

@HiveType()
class BitcoinNode extends HiveObject {
  BitcoinNode({@required this.uri, this.login, this.password});

  BitcoinNode.fromMap(Map map)
      : uri = (map['uri'] ?? '') as String,
        login = map['login'] as String,
        password = map['password'] as String;

  static const boxName = 'BitcoinNodes';

  @HiveField(0)
  String uri;

  @HiveField(1)
  String login;

  @HiveField(2)
  String password;
}
