import 'package:flutter/services.dart';
import "package:yaml/yaml.dart";
import 'package:cake_wallet/src/domain/common/node.dart';
import 'package:sqflite/sqlite_api.dart';

class NodeList {
  static const tableName = 'nodes';
  static const idColumn = 'id';
  static const uriColumn = 'uri';
  static const loginColumn = 'login';
  static const passwordColumn = 'password';
  static const isDefault = 'is_default';

  get nodes => _nodes;

  Database _db;
  List<Node> _nodes;

  static Future<NodeList> load() async {
    String nodesRaw = await rootBundle.loadString('assets/node_list.yml');
    List nodesMapList = loadYaml(nodesRaw);
    List<Node> nodes = nodesMapList.map((raw) => Node.fromMap(raw)).toList();
    return NodeList(nodes: nodes);
  }

  NodeList({List<Node> nodes, Database db}) {
    _nodes = nodes;
    _db = db;
  }

  Future<void> add({Node node}) async {
    await _db.insert(tableName, {
      uriColumn: node.uri,
      loginColumn: node.login,
      passwordColumn: node.password,
      isDefault: node.isDefault
    });
  }

  Future<void> updateList() async {
    _nodes = await _selectAllNodes();
  }

  Future<List<Node>> _selectAllNodes() async {
    final results = await _db
        .query(tableName, columns: [uriColumn, loginColumn, passwordColumn]);
    return results.map((result) => Node.fromMap(result)).toList();
  }
}
