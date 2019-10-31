import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import "package:yaml/yaml.dart";
import 'package:sqflite/sqlite_api.dart';
import 'package:cake_wallet/src/domain/common/node.dart';

class NodeList {
  static const tableName = 'Nodes';
  static const idColumn = 'id';
  static const uriColumn = 'uri';
  static const loginColumn = 'login';
  static const passwordColumn = 'password';
  static const isDefault = 'is_default';

  get nodes => _nodes;

  Database _db;
  List<Node> _nodes;

  static Future<List<Node>> loadDefaultNodes() async {
    String nodesRaw = await rootBundle.loadString('assets/node_list.yml');
    List nodesMapList = loadYaml(nodesRaw);
    
    return nodesMapList.map((raw) => Node.fromMap(raw)).toList();
  }

  NodeList({@required Database db}) {
    _nodes = [];
    _db = db;
  }

  Future<Node> add({Node node}) async {
    final id = await _db.insert(tableName, node.toMap());

    return Node(id: id, uri: node.uri, login: node.login, password: node.password);
  }

  Future<Node> findBy({@required int id}) async {
    try {
      final results =
          await _db.query(tableName, where: '$idColumn = ?', whereArgs: [id]);
      final result = results[0];
      
      return Node.fromMap(result);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future updateList() async {
    _nodes = await _selectAllNodes();
  }

  Future remove({Node node}) async {
    await _db.delete(tableName, where: '$idColumn = ?', whereArgs: [node.id]);
  }

  Future resetToDefault() async {
    final batch = _db.batch();
    batch.delete(tableName);

    final nodes = await loadDefaultNodes();
    
    for (final node in nodes) {
      batch.insert(tableName, node.toMap());
    }

    await batch.commit();
  }

  Future<List<Node>> _selectAllNodes() async {
    final results = await _db.query(tableName);
    return results.map((result) => Node.fromMap(result)).toList();
  }
}
