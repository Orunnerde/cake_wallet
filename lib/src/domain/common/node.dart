import 'package:flutter/foundation.dart';
import 'package:jsonrpc2/jsonrpc_io_client.dart';
import 'dart:convert';
import 'package:http/http.dart';

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

  Future <bool> isNodeOnline() async {
    final uri = Uri.http(this.uri, '');
    final response = await get(uri.toString());

    if (response.statusCode != 200) {
      print('ERROR');
      print('${response.statusCode}');
      return false;
    } else {
      //final responseJSON = json.decode(response.body);
      print('OK');
      return true;
    }

    /*final proxy = ServerProxy('http://opennode.xmr-tw.org:18089');
  proxy.call('get_info', [])
      .then((returned)=>proxy.checkError(returned))
      .then((result){print('RESULT = $result');})
      .catchError((error){print(error);});*/

  }
}