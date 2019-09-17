import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/node.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';

part 'node_list_store.g.dart';

class NodeListStore = NodeListBase with _$NodeListStore;

abstract class NodeListBase with Store {
  @observable
  List<Node> nodes;

  NodeList _nodeList;

  NodesListBase({NodeList nodeList}) {
    this._nodeList = nodeList;
    nodes = nodeList.nodes;
    update().then((_) => print('Updated nodes list'));
  }

  @action
  Future update() async {
      await _nodeList.updateList();
      nodes = _nodeList.nodes;
  }
}