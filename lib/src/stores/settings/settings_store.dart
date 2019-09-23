import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/transaction_priority.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/src/domain/common/node.dart';

part 'settings_store.g.dart';

class SettingsStore = SettingsStoreBase with _$SettingsStore;

abstract class SettingsStoreBase with Store {
  static final currentNodeIdKey = 'current_node_id';
  static final currentFiatCurrencyKey = 'current_fiat_currency';
  static final currentTransactionPriorityKey = 'current_fee_priority';
  static final currentBalanceDisplayModeKey = 'current_balance_display_mode';

  static Future<SettingsStore> load(
      {@required SharedPreferences sharedPreferences,
      @required NodeList nodeList,
      @required FiatCurrency initialFiatCurrency,
      @required TransactionPriority initialTransactionPriority,
      @required BalanceDisplayMode initialBalanceDisplayMode}) async {
    final store = SettingsStore(
        sharedPreferences: sharedPreferences,
        nodeList: nodeList,
        initialFiatCurrency: initialFiatCurrency,
        initialTransactionPriority: initialTransactionPriority,
        initialBalanceDisplayMode: initialBalanceDisplayMode);
    await store.loadSettings();

    return store;
  }

  @observable
  Node node;

  @observable
  FiatCurrency fiatCurrency;

  @observable
  TransactionPriority transactionPriority;

  @observable
  BalanceDisplayMode balanceDisplayMode;

  SharedPreferences _sharedPreferences;
  NodeList _nodeList;

  SettingsStoreBase(
      {@required SharedPreferences sharedPreferences,
      @required NodeList nodeList,
      @required FiatCurrency initialFiatCurrency,
      @required TransactionPriority initialTransactionPriority,
      @required BalanceDisplayMode initialBalanceDisplayMode}) {
    fiatCurrency = initialFiatCurrency;
    transactionPriority = initialTransactionPriority;
    balanceDisplayMode = initialBalanceDisplayMode;
    _sharedPreferences = sharedPreferences;
    _nodeList = nodeList;
  }

  @action
  Future setCurrentNode({@required Node node}) async {
    this.node = node;
    await _sharedPreferences.setInt(currentNodeIdKey, node.id);
  }

  @action
  Future setCurrentFiatCurrency({@required FiatCurrency currency}) async {
    this.fiatCurrency = currency;
    await _sharedPreferences.setString(
        currentFiatCurrencyKey, fiatCurrency.serialize());
  }

  @action
  Future setCurrentTransactionPriority({@required TransactionPriority priority}) async {
    this.transactionPriority = priority;
    await _sharedPreferences.setInt(
        currentTransactionPriorityKey, priority.serialize());
  }

  @action
  Future setCurrentBalanceDisplayMode(
      {@required BalanceDisplayMode balanceDisplayMode}) async {
    this.balanceDisplayMode = balanceDisplayMode;
    await _sharedPreferences.setInt(
        currentBalanceDisplayModeKey, balanceDisplayMode.serialize());
  }

  Future loadSettings() async {
    node = await _fetchCurrentNode();
  }

  Future<Node> _fetchCurrentNode() async {
    final id = _sharedPreferences.getInt(currentNodeIdKey);
    return await _nodeList.findBy(id: id);
  }
}
