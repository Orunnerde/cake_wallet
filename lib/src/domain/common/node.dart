import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

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

  Future<bool> requestNode(String uri, {String login, String password}) async {

    final url = Uri.http(uri, '/json_rpc');
    Map<String, String> headers = {'Content-type' : 'application/json'};
    String body = json.encode({"jsonrpc":"2.0","id":"0","method":"get_info"});

    if (login != null && password != null) {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$login:$password'));
      print("AUTH = $basicAuth");
      headers.addAll({HttpHeaders.authorizationHeader: basicAuth});
      print("HEADERS = ${headers.toString()}");
    }

    var response = await http.post(url.toString(), headers: headers, body: body);
    var resBody = json.decode(response.body);
    var isOffline = resBody["result"]["offline"];
    print("URL = $url");
    print("Is offline $uri: $isOffline");
    print(resBody);
    return isOffline;

  }
}