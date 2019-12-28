import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import "package:yaml/yaml.dart";
import 'package:cake_wallet/src/domain/common/node.dart';

Future<List<Node>> loadDefaultNodes() async {
  String nodesRaw = await rootBundle.loadString('assets/node_list.yml');
  List nodes = loadYaml(nodesRaw);
  return nodes.map((raw) => Node.fromMap(raw)).toList();
}

Future resetToDefault(Box<Node> nodeSource) async {
  final nodes = await loadDefaultNodes();
  await nodeSource.clear();
  await nodeSource.addAll(nodes);
}