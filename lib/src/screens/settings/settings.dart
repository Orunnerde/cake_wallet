import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/transaction_priority.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/disclaimer/disclaimer_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/stores/action_list/action_list_display_mode.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/screens/settings/attributes.dart';
import 'package:cake_wallet/src/screens/settings/items/settings_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cake_wallet/src/screens/settings/items/item_headers.dart';
import 'package:cake_wallet/generated/i18n.dart';
// Settings widgets
import 'package:cake_wallet/src/screens/settings/widgets/settings_arrow_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_header_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_link_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_switch_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_text_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_raw_widget_list_row.dart';

class SettingsPage extends BasePage {
  String get title => S.current.settings_title;
  bool get isModalBackButton => true;
  Color get backgroundColor => Palette.lightGrey2;

  @override
  Widget body(BuildContext context) {
    return SettingsForm();
  }
}

class SettingsForm extends StatefulWidget {
  @override
  createState() => SettingsFormState();
}

class SettingsFormState extends State<SettingsForm> {
  final _telegramImage = Image.asset('assets/images/Telegram.png');
  final _twitterImage = Image.asset('assets/images/Twitter.png');
  final _changeNowImage = Image.asset('assets/images/change_now.png');
  final _morphImage = Image.asset('assets/images/morph_icon.png');
  final _xmrBtcImage = Image.asset('assets/images/xmr_btc.png');
  
  final _emailUrl = 'mailto:support@cakewallet.io';
  final _telegramUrl = 'https:t.me/cake_wallet';
  final _twitterUrl = 'https:twitter.com/CakewalletXMR';
  final _changeNowUrl = 'mailto:support@changenow.io';
  final _morphUrl = 'mailto:contact@morphtoken.com';
  final _xmrToUrl = 'mailto:support@xmr.to';

  List<SettingsItem> _items = List<SettingsItem>();
  
  _launchUrl(String url) async {
    if (await canLaunch(url)) await launch(url);
  }

  _setSettingsList() {
    final settingsStore = Provider.of<SettingsStore>(context);
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    settingsStore.setItemHeaders();

    _items.addAll([
      SettingsItem(title: ItemHeaders.nodes, attribute: Attributes.header),
      SettingsItem(
          onTaped: () => Navigator.of(context).pushNamed(Routes.nodeList),
          title: ItemHeaders.currentNode,
          widget: Observer(
              builder: (_) => Text(
                    settingsStore.node == null ? '' : settingsStore.node.uri,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: _isDarkTheme
                            ? PaletteDark.darkThemeGrey
                            : Palette.wildDarkBlue),
                  )),
          attribute: Attributes.widget),
      SettingsItem(title: ItemHeaders.wallets, attribute: Attributes.header),
      SettingsItem(
          onTaped: () => _setBalance(context),
          title: ItemHeaders.displayBalanceAs,
          widget: Observer(
              builder: (_) => Text(
                    _getCurrentBalanceMode(settingsStore.balanceDisplayMode.toString()),
                    style: TextStyle(
                        fontSize: 16.0,
                        color: _isDarkTheme
                            ? PaletteDark.darkThemeGrey
                            : Palette.wildDarkBlue),
                  )),
          attribute: Attributes.widget),
      SettingsItem(
          onTaped: () => _setCurrency(context),
          title: ItemHeaders.currency,
          widget: Observer(
              builder: (_) => Text(
                    settingsStore.fiatCurrency.toString(),
                    style: TextStyle(
                        fontSize: 16.0,
                        color: _isDarkTheme
                            ? PaletteDark.darkThemeGrey
                            : Palette.wildDarkBlue),
                  )),
          attribute: Attributes.widget),
      SettingsItem(
          onTaped: () => _setTransactionPriority(context),
          title: ItemHeaders.feePriority,
          widget: Observer(
              builder: (_) => Text(
                    _getCurrentTransactionPriority(settingsStore.transactionPriority.toString()),
                    style: TextStyle(
                        fontSize: 16.0,
                        color: _isDarkTheme
                            ? PaletteDark.darkThemeGrey
                            : Palette.wildDarkBlue),
                  )),
          attribute: Attributes.widget),
      SettingsItem(
          title: ItemHeaders.saveRecipientAddress, attribute: Attributes.switcher),
      SettingsItem(title: ItemHeaders.personal, attribute: Attributes.header),
      SettingsItem(
          onTaped: () {
            Navigator.of(context).pushNamed(Routes.auth,
                arguments: (isAuthenticatedSuccessfully, auth) =>
                    isAuthenticatedSuccessfully
                        ? Navigator.of(context).popAndPushNamed(Routes.setupPin,
                            arguments: (setupPinContext, _) =>
                                Navigator.of(context).pop())
                        : null);
          },
          title: ItemHeaders.changePIN,
          attribute: Attributes.arrow),
      SettingsItem(
          onTaped: () => Navigator.pushNamed(context, Routes.changeLanguage),
          title: ItemHeaders.changeLanguage,
          attribute: Attributes.arrow),
      SettingsItem(
          title: ItemHeaders.allowBiometricalAuthentication,
          attribute: Attributes.switcher),
      SettingsItem(title: ItemHeaders.darkMode, attribute: Attributes.switcher),
      SettingsItem(
          widgetBuilder: (context) {
            final _themeChanger = Provider.of<ThemeChanger>(context);
            final _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

            return PopupMenuButton<ActionListDisplayMode>(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          value: ActionListDisplayMode.transactions,
                          child: Observer(
                              builder: (_) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(S.of(context).settings_transactions),
                                        Checkbox(
                                          value: settingsStore
                                              .actionlistDisplayMode
                                              .contains(ActionListDisplayMode
                                                  .transactions),
                                          onChanged: (value) => settingsStore
                                              .toggleTransactionsDisplay(),
                                        )
                                      ]))),
                      PopupMenuItem(
                          value: ActionListDisplayMode.trades,
                          child: Observer(
                              builder: (_) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(S.of(context).settings_trades),
                                        Checkbox(
                                          value: settingsStore
                                              .actionlistDisplayMode
                                              .contains(
                                                  ActionListDisplayMode.trades),
                                          onChanged: (value) => settingsStore
                                              .toggleTradesDisplay(),
                                        )
                                      ])))
                    ],
                child: Container(
                  height: 56,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(S.of(context).settings_display_on_dashboard_list,
                            style: TextStyle(
                                fontSize: 16,
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeTitle
                                    : Colors.black)),
                        Observer(builder: (_) {
                          var title = '';

                          if (settingsStore.actionlistDisplayMode.length ==
                              ActionListDisplayMode.values.length) {
                            title = S.of(context).settings_all;
                          }

                          if (title.isEmpty &&
                              settingsStore.actionlistDisplayMode
                                  .contains(ActionListDisplayMode.trades)) {
                            title = S.of(context).settings_only_trades;
                          }

                          if (title.isEmpty &&
                              settingsStore.actionlistDisplayMode.contains(
                                  ActionListDisplayMode.transactions)) {
                            title = S.of(context).settings_only_transactions;
                          }

                          if (title.isEmpty) {
                            title = S.of(context).settings_none;
                          }

                          return Text(title,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: _isDarkTheme
                                      ? PaletteDark.darkThemeGrey
                                      : Palette.wildDarkBlue));
                        })
                      ]),
                ));
          },
          attribute: Attributes.rawWidget),
      SettingsItem(title: ItemHeaders.support, attribute: Attributes.header),
      SettingsItem(
          onTaped: () => _launchUrl(_emailUrl),
          title: 'Email',
          link: 'support@cakewallet.io',
          image: null,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () => _launchUrl(_telegramUrl),
          title: 'Telegram',
          link: 't.me/cake_wallet',
          image: _telegramImage,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () => _launchUrl(_twitterUrl),
          title: 'Twitter',
          link: 'twitter.com/CakewalletXMR',
          image: _twitterImage,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () => _launchUrl(_changeNowUrl),
          title: 'ChangeNow',
          link: 'support@changenow.io',
          image: _changeNowImage,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () => _launchUrl(_morphUrl),
          title: 'Morph',
          link: 'contact@morphtoken.com',
          image: _morphImage,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () => _launchUrl(_xmrToUrl),
          title: 'XMR.to',
          link: 'support@xmr.to',
          image: _xmrBtcImage,
          attribute: Attributes.link),
      SettingsItem(
          onTaped: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => DisclaimerPage()));
          },
          title: ItemHeaders.termsAndConditions,
          attribute: Attributes.arrow),
      SettingsItem(
          onTaped: () => Navigator.pushNamed(context, Routes.faq),
          title: ItemHeaders.faq,
          attribute: Attributes.arrow)
    ]);
    setState(() {});
  }

  _afterLayout(_) {
    _setSettingsList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  Widget _getWidget(SettingsItem item) {
    switch (item.attribute) {
      case Attributes.arrow:
        return SettingsArrowListRow(
          onTaped: item.onTaped,
          title: item.title,
        );
      case Attributes.header:
        return SettingsHeaderListRow(
          title: item.title,
        );
      case Attributes.link:
        return SettingsLinktListRow(
          onTaped: item.onTaped,
          title: item.title,
          link: item.link,
          image: item.image,
        );
      case Attributes.switcher:
        return SettingsSwitchListRow(
          title: item.title,
        );
      case Attributes.widget:
        return SettingsTextListRow(
          onTaped: item.onTaped,
          title: item.title,
          widget: item.widget,
        );
      case Attributes.rawWidget:
        return SettingRawWidgetListRow(widgetBuilder: item.widgetBuilder);
      default:
        return Offstage();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    final settingsStore = Provider.of<SettingsStore>(context);
    settingsStore.setItemHeaders();

    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              bool _isDrawDivider = true;

              if (item.attribute == Attributes.header)
                _isDrawDivider = false;
              else if (index < _items.length - 1) {
                if (_items[index + 1].attribute == Attributes.header)
                  _isDrawDivider = false;
              }

              return Column(
                children: <Widget>[
                  _getWidget(item),
                  _isDrawDivider
                      ? Container(
                          color: _isDarkTheme
                              ? PaletteDark.darkThemeMidGrey
                              : Colors.white,
                          padding: EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Divider(
                            color: _isDarkTheme
                                ? PaletteDark.darkThemeDarkGrey
                                : Palette.lightGrey,
                            height: 1.0,
                          ),
                        )
                      : Offstage()
                ],
              );
            }),
        Container(
          height: 20.0,
          color: _isDarkTheme ? PaletteDark.darkThemeMidGrey : Colors.white,
        )
      ],
    ));
  }

  Future<T> _presentPicker<T extends Object>(
      BuildContext context, List<T> list) async {
    T _value = list[0];
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).please_select),
            backgroundColor: Theme.of(context).backgroundColor,
            content: Container(
              height: 150.0,
              child: CupertinoPicker(
                  backgroundColor: Theme.of(context).backgroundColor,
                  itemExtent: 45.0,
                  onSelectedItemChanged: (int index) => _value = list[index],
                  children: List.generate(
                      list.length,
                      (index) => Center(
                            child: Text(
                              list[index].toString(),
                              style: TextStyle(
                                color: _isDarkTheme ? Colors.white : Colors.black
                              ),
                            ),
                          ))),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(S.of(context).cancel)),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(_value),
                  child: Text(S.of(context).ok))
            ],
          );
        });
  }

  void _setBalance(BuildContext context) async {
    final settingsStore = Provider.of<SettingsStore>(context);
    final balanceList = _getBalanceModeList(BalanceDisplayMode.all);
    final selectedDisplayMode =
    await _presentPicker(context, balanceList);

    if (selectedDisplayMode != null) {
      settingsStore.setCurrentBalanceDisplayMode(
          balanceDisplayMode: _getSelectedItem(selectedDisplayMode, balanceList, BalanceDisplayMode.all));
    }
  }

  void _setCurrency(BuildContext context) async {
    final settingsStore = Provider.of<SettingsStore>(context);
    final selectedCurrency = await _presentPicker(context, FiatCurrency.all);

    if (selectedCurrency != null) {
      settingsStore.setCurrentFiatCurrency(currency: selectedCurrency);
    }
  }

  void _setTransactionPriority(BuildContext context) async {
    final settingsStore = Provider.of<SettingsStore>(context);
    final transactionPriorityList = _getTransactionPriorityList(TransactionPriority.all);
    final selectedPriority =
    await _presentPicker(context, transactionPriorityList);

    if (selectedPriority != null) {
      settingsStore.setCurrentTransactionPriority(priority: _getSelectedItem(selectedPriority,
          transactionPriorityList, TransactionPriority.all));
    }
  }

  List<String> _getBalanceModeList(List<BalanceDisplayMode> list) {
    List<String> balanceModeList = new List();
    for(int i = 0; i < list.length; i++) {
      switch(list[ i ].title) {
        case 'Full Balance':
          balanceModeList.add(S.of(context).full_balance);
          break;
        case 'Available Balance':
          balanceModeList.add(S.of(context).available_balance);
          break;
        case 'Hidden Balance':
          balanceModeList.add(S.of(context).hidden_balance);
          break;
        default:
          break;
      }
    }
    return balanceModeList;
  }

  List<String> _getTransactionPriorityList(List<TransactionPriority> list) {
    List<String> transactionPriorityList = new List();
    for(int i = 0; i < list.length; i++) {
      switch(list[ i ].title) {
        case 'Slow':
          transactionPriorityList.add(S.of(context).transaction_priority_slow);
          break;
        case 'Regular':
          transactionPriorityList.add(S.of(context).transaction_priority_regular);
          break;
        case 'Medium':
          transactionPriorityList.add(S.of(context).transaction_priority_medium);
          break;
        case 'Fast':
          transactionPriorityList.add(S.of(context).transaction_priority_fast);
          break;
        case 'Fastest':
          transactionPriorityList.add(S.of(context).transaction_priority_fastest);
          break;
        default:
          break;
      }
    }
    return transactionPriorityList;
  }

  _getSelectedItem<T extends Object> (String selectedItem, List<String> list, List<T> itemsList) {
    return itemsList[list.indexOf(selectedItem)];
  }

  String _getCurrentBalanceMode(String balanceMode) {
    String currentBalanceMode;
    switch(balanceMode) {
      case 'Full Balance':
        currentBalanceMode = S.of(context).full_balance;
        break;
      case 'Available Balance':
        currentBalanceMode = S.of(context).available_balance;
        break;
      case 'Hidden Balance':
        currentBalanceMode = S.of(context).hidden_balance;
        break;
      default:
        break;
    }
    return currentBalanceMode;
  }

  String _getCurrentTransactionPriority(String transactionPriority) {
    String currentTransactionPriority;
    switch(transactionPriority) {
      case 'Slow':
        currentTransactionPriority = S.of(context).transaction_priority_slow;
        break;
      case 'Regular':
        currentTransactionPriority = S.of(context).transaction_priority_regular;
        break;
      case 'Medium':
        currentTransactionPriority = S.of(context).transaction_priority_medium;
        break;
      case 'Fast':
        currentTransactionPriority = S.of(context).transaction_priority_fast;
        break;
      case 'Fastest':
        currentTransactionPriority = S.of(context).transaction_priority_fastest;
        break;
      default:
        break;
    }
    return currentTransactionPriority;
  }
}
