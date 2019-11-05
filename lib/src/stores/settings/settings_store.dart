import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/src/domain/common/node.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/transaction_priority.dart';
import 'package:cake_wallet/src/stores/action_list/action_list_display_mode.dart';

part 'settings_store.g.dart';

class SettingsStore = SettingsStoreBase with _$SettingsStore;

abstract class SettingsStoreBase with Store {
  static const currentNodeIdKey = 'current_node_id';
  static const currentFiatCurrencyKey = 'current_fiat_currency';
  static const currentTransactionPriorityKey = 'current_fee_priority';
  static const currentBalanceDisplayModeKey = 'current_balance_display_mode';
  static const shouldSaveRecipientAddressKey = 'save_recipient_address';
  static const shouldAllowBiometricalAuthenticationKey = 'allow_biometrical_authentication';
  static const currentDarkTheme = 'dark_theme';
  static const displayActionListModeKey = 'display_list_mode';

  static Future<SettingsStore> load(
      {@required SharedPreferences sharedPreferences,
      @required NodeList nodeList,
      @required FiatCurrency initialFiatCurrency,
      @required TransactionPriority initialTransactionPriority,
      @required BalanceDisplayMode initialBalanceDisplayMode}) async {
    final currentFiatCurrency = FiatCurrency(
        symbol: sharedPreferences.getString(currentFiatCurrencyKey));
    final currentTransactionPriority = TransactionPriority.deserialize(
        raw: sharedPreferences.getInt(currentTransactionPriorityKey));
    final currentBalanceDisplayMode = BalanceDisplayMode.deserialize(
        raw: sharedPreferences.getInt(currentBalanceDisplayModeKey));
    final shouldSaveRecipientAddress =
        sharedPreferences.getBool(shouldSaveRecipientAddressKey);
    final shouldAllowBiometricalAuthentication =
    sharedPreferences.getBool(shouldAllowBiometricalAuthenticationKey) == null ? false
        : sharedPreferences.getBool(shouldAllowBiometricalAuthenticationKey);
    final savedDarkTheme =
    sharedPreferences.getBool(currentDarkTheme) == null ? false
        : sharedPreferences.getBool(currentDarkTheme);
    final actionlistDisplayMode = ObservableList();
    actionlistDisplayMode.addAll(deserializeActionlistDisplayModes(
        sharedPreferences.getInt(displayActionListModeKey) ?? 11));

    final store = SettingsStore(
        sharedPreferences: sharedPreferences,
        nodeList: nodeList,
        initialFiatCurrency: currentFiatCurrency,
        initialTransactionPriority: currentTransactionPriority,
        initialBalanceDisplayMode: currentBalanceDisplayMode,
        initialSaveRecipientAddress: shouldSaveRecipientAddress,
        initialAllowBiometricalAuthentication : shouldAllowBiometricalAuthentication,
        initialDarkTheme: savedDarkTheme,
        actionlistDisplayMode: actionlistDisplayMode);
    await store.loadSettings();

    return store;
  }

  @observable
  Node node;

  @observable
  FiatCurrency fiatCurrency;

  @observable
  ObservableList<ActionListDisplayMode> actionlistDisplayMode;

  @observable
  TransactionPriority transactionPriority;

  @observable
  BalanceDisplayMode balanceDisplayMode;

  @observable
  bool shouldSaveRecipientAddress;

  @observable
  bool shouldAllowBiometricalAuthentication;

  @observable
  bool isDarkTheme;

  SharedPreferences _sharedPreferences;
  NodeList _nodeList;

  SettingsStoreBase(
      {@required SharedPreferences sharedPreferences,
      @required NodeList nodeList,
      @required FiatCurrency initialFiatCurrency,
      @required TransactionPriority initialTransactionPriority,
      @required BalanceDisplayMode initialBalanceDisplayMode,
      @required bool initialSaveRecipientAddress,
      @required bool initialAllowBiometricalAuthentication,
      @required bool initialDarkTheme,
      this.actionlistDisplayMode}) {
    fiatCurrency = initialFiatCurrency;
    transactionPriority = initialTransactionPriority;
    balanceDisplayMode = initialBalanceDisplayMode;
    shouldSaveRecipientAddress = initialSaveRecipientAddress;
    _sharedPreferences = sharedPreferences;
    _nodeList = nodeList;
    shouldAllowBiometricalAuthentication = initialAllowBiometricalAuthentication;
    isDarkTheme = initialDarkTheme;

    actionlistDisplayMode.observe(
            (dynamic _) => _sharedPreferences.setInt(displayActionListModeKey,
            serializeActionlistDisplayModes(actionlistDisplayMode)),
        fireImmediately: false);
  }

  @action
  Future setAllowBiometricalAuthentication(
      {@required bool shouldAllowBiometricalAuthentication}) async {
    this.shouldAllowBiometricalAuthentication = shouldAllowBiometricalAuthentication;
    await _sharedPreferences.setBool(shouldAllowBiometricalAuthenticationKey,
        shouldAllowBiometricalAuthentication);
  }

  @action
  Future saveDarkTheme({@required bool isDarkTheme}) async {
    this.isDarkTheme = isDarkTheme;
    await _sharedPreferences.setBool(currentDarkTheme, isDarkTheme);
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
  Future setCurrentTransactionPriority(
      {@required TransactionPriority priority}) async {
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

  @action
  Future setSaveRecipientAddress(
      {@required bool shouldSaveRecipientAddress}) async {
    this.shouldSaveRecipientAddress = shouldSaveRecipientAddress;
    await _sharedPreferences.setBool(
        shouldSaveRecipientAddressKey, shouldSaveRecipientAddress);
  }

  Future loadSettings() async {
    node = await _fetchCurrentNode();
  }

  @action
  void toggleTransactionsDisplay() =>
      actionlistDisplayMode.contains(ActionListDisplayMode.transactions)
          ? _hideTransaction()
          : _showTransaction();

  @action
  void toggleTradesDisplay() =>
      actionlistDisplayMode.contains(ActionListDisplayMode.trades)
          ? _hideTrades()
          : _showTrades();

  @action
  void _hideTransaction() =>
      actionlistDisplayMode.remove(ActionListDisplayMode.transactions);

  @action
  void _hideTrades() =>
      actionlistDisplayMode.remove(ActionListDisplayMode.trades);

  @action
  void _showTransaction() =>
      actionlistDisplayMode.add(ActionListDisplayMode.transactions);

  @action
  void _showTrades() => actionlistDisplayMode.add(ActionListDisplayMode.trades);

  Future<Node> _fetchCurrentNode() async {
    final id = _sharedPreferences.getInt(currentNodeIdKey);
    return await _nodeList.findBy(id: id);
  }
}
