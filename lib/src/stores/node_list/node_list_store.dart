import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/node.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/generated/i18n.dart';

part 'node_list_store.g.dart';

class NodeListStore = NodeListBase with _$NodeListStore;

abstract class NodeListBase with Store {
  @observable
  ObservableList<Node> nodes;

  NodeList _nodeList;

  @observable
  bool isValid;

  @observable
  String errorMessage;

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

  Future<bool> isNodeOnline(Node node) async {
    try {
      return await node.requestNode(node.uri, login: node.login, password: node.password);
    } catch (e) {
      return false;
    }
  }

  void validateNodeAddress(String value) {
    String p = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\$';
    RegExp regExp = new RegExp(p);
    isValid = regExp.hasMatch(value);
    errorMessage = isValid ? null : S.current.error_text_node_address;
  }

  void validateNodePort(String value) {
    String p = '^[0-9]{1,5}';
    RegExp regExp = new RegExp(p);
    if (regExp.hasMatch(value)) {
      try {
        int intValue = int.parse(value);
        isValid = (intValue >= 0 && intValue <= 65535);
      } catch (e) {
        isValid = false;
      }
    } else isValid = false;
    errorMessage = isValid ? null : S.current.error_text_node_port;
  }
}
