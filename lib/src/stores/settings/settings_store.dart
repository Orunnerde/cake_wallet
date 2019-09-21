import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/src/domain/common/node.dart';

part 'settings_store.g.dart';

class SettingsStore = SettingsStoreBase with _$SettingsStore;

abstract class SettingsStoreBase with Store {
  static final currentNodeIdKey = 'current_node_id';

  static Future<SettingsStore> load({@required SharedPreferences sharedPreferences, @required NodeList nodeList}) async {
    final store = SettingsStore(sharedPreferences: sharedPreferences, nodeList: nodeList);
    await store.loadSettings();

    return store;
  }

  @observable
  Node node;

  SharedPreferences _sharedPreferences;
  NodeList _nodeList;

  SettingsStoreBase({@required SharedPreferences sharedPreferences, @required NodeList nodeList}) {
    _sharedPreferences = sharedPreferences;
    _nodeList = nodeList;
  }

  @action
  Future setCurrent({@required Node node}) async {
    this.node = node;
    await _sharedPreferences.setInt(currentNodeIdKey, node.id);
  }

  Future loadSettings() async {
    node = await _fetchCurrentNode();
  }

  Future<Node> _fetchCurrentNode() async {
    final id = _sharedPreferences.getInt(currentNodeIdKey);
    return await _nodeList.findBy(id: id);
  }
}