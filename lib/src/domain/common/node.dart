import 'dart:io';

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
/*import 'package:http/http.dart' show BaseClient;
import 'dart:io'
    show HttpClient, HttpClientBasicCredentials, HttpClientCredentials;
import 'dart:async' show Future;

import 'package:http/io_client.dart';*/

import 'package:http_auth/http_auth.dart';

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
      /*String basicAuth = 'Basic ' + base64Encode(utf8.encode('$login:$password'));
      headers.addAll({HttpHeaders.authorizationHeader: basicAuth});
      print("HEADERS = ${headers.toString()}");*/
      /*final httpAuth = createBasicAuthenticationIoHttpClient(login, password);
      response = await httpAuth.post(url.toString(), headers: headers, body: body);*/

      /*HttpClient client = new HttpClient();
      client.addCredentials(
          Uri.parse(url.toString()),
          'realm',
          new HttpClientBasicCredentials(login, password)
      );

      client.getUrl(Uri.parse(url.toString()))
          .then((HttpClientRequest req) {
        req.headers
          ..add(HttpHeaders.ACCEPT, 'application/json')
          ..add(HttpHeaders.CONTENT_TYPE, 'application/json');

        return req.close();
      })
          .then((HttpClientResponse res) {
        print("AUTHORIZATION: ${res.statusCode}");
        client.close();
        return true;
      });*/

      var client = new DigestAuthClient(login, password);
      var res = await client.post(url.toString(), headers: headers, body: body);
      var resBody = json.decode(res.body);
      var isOffline = resBody["result"]["offline"];
      print("URL = $url");
      print("Is offline $uri: $isOffline");
      print(resBody);
      return isOffline;
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

  /*HttpAuthenticationCallback _basicAuthenticationCallback(
      HttpClient client, HttpClientCredentials credentials) =>
          (Uri uri, String scheme, String realm) {
        client.addCredentials(uri, realm, credentials);
        return new Future.value(true);
      };

  BaseClient createBasicAuthenticationIoHttpClient(
      String userName, String password) {
    final credentials = new HttpClientBasicCredentials(userName, password);

    final client = new HttpClient();
    client.authenticate = _basicAuthenticationCallback(client, credentials);
    return new IOClient(client);
  }*/


/*typedef Future<bool> HttpAuthenticationCallback(
    Uri uri, String scheme, String realm);*/