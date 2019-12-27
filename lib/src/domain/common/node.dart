import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cake_wallet/src/domain/common/digest_request.dart';

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
    var resBody;

    if (login != null && password != null) {
      final digestRequest = DigestRequest();
      var response = await digestRequest.request(uri: uri, login: login, password: password);
      resBody = response.data;
    } else {
      final url = Uri.http(uri, '/json_rpc');
      Map<String, String> headers = {'Content-type' : 'application/json'};
      String body = json.encode({"jsonrpc":"2.0","id":"0","method":"get_info"});
      var response = await http.post(url.toString(), headers: headers, body: body);
      resBody = json.decode(response.body);
    }

    return !resBody["result"]["offline"];
  }

}