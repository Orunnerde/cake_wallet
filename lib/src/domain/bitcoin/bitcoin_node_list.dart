import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import "package:yaml/yaml.dart";
import 'package:cake_wallet/src/domain/bitcoin/bitcoin_node.dart';

Future<List<BitcoinNode>> loadDefaultBitcoinNodes() async {
  final nodesRaw = await rootBundle.loadString('assets/btc_node_list.yml');
  final nodes = loadYaml(nodesRaw) as YamlList;

  return nodes.map((dynamic raw) {
    if (raw is Map) {
      return BitcoinNode.fromMap(raw);
    }

    return null;
  }).toList();
}

Future btcResetToDefault(Box<BitcoinNode> nodeSource) async {
  final nodes = await loadDefaultBitcoinNodes();
  final enteties = Map<int, BitcoinNode>();

  await nodeSource.clear();

  for (var i = 0; i < nodes.length; i++) {
    enteties[i] = nodes[i];
  }

  await nodeSource.putAll(enteties);
}