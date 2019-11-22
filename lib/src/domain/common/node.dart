import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  isNodeOnline(String uri) async {

    final url = Uri.http(uri, '/json_rpc');
    var response = await http.post(url.toString(), headers: {"Content-Type": "application/json"}, body: {"jsonrpc":"2.0","id":"0","method":"get_info"});
    var resBody = json.decode(response.body);
    var isOffline = resBody["offline"];
    print("URL = $url");
    print("Is offline $uri: $isOffline");

  }
}