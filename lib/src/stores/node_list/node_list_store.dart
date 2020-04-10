import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:hive/hive.dart';
import 'package:cake_wallet/src/domain/common/node.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/src/domain/bitcoin/bitcoin_node.dart';
import 'package:cake_wallet/src/domain/bitcoin/bitcoin_node_list.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:rxdart/rxdart.dart';

part 'node_list_store.g.dart';

class NodeListStore = NodeListBase with _$NodeListStore;

abstract class NodeListBase with Store {
  NodeListBase({this.nodesSource, this.btcNodesSource}) {
    nodes = ObservableList<Node>();
    bitcoinNodes = ObservableList<BitcoinNode>();
    _onNodesChangeSubscription = nodesSource.watch().listen((e) => update());
    _onBTCNodesChangeSubscription = btcNodesSource.watch().listen((e) => btcUpdate());
    update();
    btcUpdate();
  }

  @observable
  ObservableList<Node> nodes;

  @observable
  ObservableList<BitcoinNode> bitcoinNodes;

  @observable
  bool isValid;

  @observable
  String errorMessage;

  Box<Node> nodesSource;
  Box<BitcoinNode> btcNodesSource;

  StreamSubscription<BoxEvent> _onNodesChangeSubscription;
  StreamSubscription<BoxEvent> _onBTCNodesChangeSubscription;

  @override
  void dispose() {
    super.dispose();

    if (_onNodesChangeSubscription != null) {
      _onNodesChangeSubscription.cancel();
    }

    if (_onBTCNodesChangeSubscription != null) {
      _onBTCNodesChangeSubscription.cancel();
    }
  }

  @action
  void update() =>
      nodes.replaceRange(0, nodes.length, nodesSource.values.toList());

  @action
  void btcUpdate() =>
      bitcoinNodes.replaceRange(0, bitcoinNodes.length, btcNodesSource.values.toList());

  @action
  Future addNode(
      {String address, String port, String login, String password}) async {
    var uri = address;

    if (port != null && port.isNotEmpty) {
      uri += ':' + port;
    }

    final node = Node(uri: uri, login: login, password: password);
    await nodesSource.add(node);
  }

  @action
  Future addBTCNode(
      {String address, String port, String login, String password}) async {
    var uri = address;

    if (port != null && port.isNotEmpty) {
      uri += ':' + port;
    }

    final node = BitcoinNode(uri: uri, login: login, password: password);
    await btcNodesSource.add(node);
  }

  @action
  Future remove({Node node}) async => await node.delete();

  @action
  Future btcRemove({BitcoinNode node}) async => await node.delete();

  @action
  Future reset() async => await resetToDefault(nodesSource);

  Future<bool> isNodeOnline(Node node) async {
    try {
      return await node.requestNode(node.uri,
          login: node.login, password: node.password);
    } catch (e) {
      return false;
    }
  }

  void validateNodeAddress(String value) {
    const pattern =
        '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\$|^[0-9a-zA-Z.]+\$';
    final regExp = RegExp(pattern);
    isValid = regExp.hasMatch(value);
    errorMessage = isValid ? null : S.current.error_text_node_address;
  }

  void validateNodePort(String value) {
    const pattern = '^[0-9]{1,5}';
    final regExp = RegExp(pattern);

    if (regExp.hasMatch(value)) {
      try {
        final intValue = int.parse(value);
        isValid = (intValue >= 0 && intValue <= 65535);
      } catch (e) {
        isValid = false;
      }
    } else {
      isValid = false;
    }

    errorMessage = isValid ? null : S.current.error_text_node_port;
  }
}
