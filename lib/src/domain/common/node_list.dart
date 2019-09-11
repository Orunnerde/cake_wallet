import 'package:flutter/services.dart';
import "package:yaml/yaml.dart";

class Node {
  final String uri;
  final String login;
  final String password;
  final bool isDefault;

  Node({this.uri, this.login, this.password, this.isDefault});

  Node.fromMap(Map map)
      : uri = map['uri'] ?? '',
        login = map['login'],
        password = map['password'],
        isDefault = map['is_default'] ?? false;
}

class NodeList {
  List<Node> _nodes;

  static Future<NodeList> load() async {
    String nodesRaw = await rootBundle.loadString('assets/node_list.yml');
    List nodesMapList = loadYaml(nodesRaw);
    List<Node> nodes = nodesMapList.map((raw) => Node.fromMap(raw)).toList();
    return NodeList(nodes: nodes);
  }

  NodeList({List<Node> nodes}) {
    _nodes = nodes;
    print('nodes $nodes');
  }
}
