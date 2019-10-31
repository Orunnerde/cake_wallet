import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/node.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';

part 'node_list_store.g.dart';

class NodeListStore = NodeListBase with _$NodeListStore;

abstract class NodeListBase with Store {
  @observable
  ObservableList<Node> nodes;

  NodeList _nodeList;

  NodeListBase({NodeList nodeList}) {
    _nodeList = nodeList;
    nodes = ObservableList<Node>();
    update().then((_) => print('Updated nodes list'));
  }

  @action
  Future update() async {
    await _nodeList.updateList();

    nodes.replaceRange(0, nodes.length, _nodeList.nodes);
  }

  @action
  Future addNode(
      {String address, String port, String login, String password}) async {
    var uri = address;

    if (port != null && port.isNotEmpty) {
      uri += ':' + port;
    }

    final node = Node(uri: uri, login: login, password: password);
    await _nodeList.add(node: node);
  }

  @action
  Future remove({Node node}) async {
    await _nodeList.remove(node: node);
    await update();
  }

  @action
  Future reset() async {
    await _nodeList.resetToDefault();
    await update();
  }
}
