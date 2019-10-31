import 'package:flutter/foundation.dart';

class Node {
  final int id;
  final String uri;
  final String login;
  final String password;

  Node({this.id, @required this.uri, this.login, this.password});

  Node.fromMap(Map map)
      : id = map['id'],
        uri = map['uri'] ?? '',
        login = map['login'],
        password = map['password'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uri': uri,
      'login': login,
      'password': password
    };
  }
}