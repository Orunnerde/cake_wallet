import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/transaction_priority.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/settings/change_language.dart';
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
// Settings widgets
import 'package:cake_wallet/src/screens/settings/widgets/settings_arrow_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_header_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_link_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_switch_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_text_list_row.dart';
import 'package:cake_wallet/src/screens/settings/widgets/settings_raw_widget_list_row.dart';

class SettingsPage extends BasePage {
  String get title => 'Settings';
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
  final _xmrBtcImage = Image.asset('assets/images/xmr_btc.png');
  
  final _emailUrl = 'mailto:support@cakewallet.io';
  final _telegramUrl = 'https:t.me/cake_wallet';
  final _twitterUrl = 'https:twitter.com/CakewalletXMR';
  final _changeNowUrl = 'mailto:support@changenow.io';
  final _xmrToUrl = 'mailto:support@xmr.to';

  List<SettingsItem> _items = List<SettingsItem>();
  
  _launchUrl(String url) async {
    if (await canLaunch(url)) await launch(url);
  }

  _setSettingsList() {
    final settingsStore = Provider.of<SettingsStore>(context);
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = (_themeChanger.getTheme() == Themes.darkTheme);

    _items.addAll([
      SettingsItem(title: 'Nodes', attribute: Attributes.header),
      SettingsItem(
          onTaped: () => Navigator.of(context).pushNamed(Routes.nodeList),
          title: 'Current node',
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
      SettingsItem(title: 'Wallets', attribute: Attributes.header),
      SettingsItem(
          onTaped: () => _setBalance(context),
          title: 'Display balance as',
          widget: Observer(
              builder: (_) => Text(
                    settingsStore.balanceDisplayMode.toString(),
                    style: TextStyle(
                        fontSize: 16.0,
                        color: _isDarkTheme
                            ? PaletteDark.darkThemeGrey
                            : Palette.wildDarkBlue),
                  )),
          attribute: Attributes.widget),
      SettingsItem(
          onTaped: () => _setCurrency(context),
          title: 'Currency',
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
          title: 'Fee priority',
          widget: Observer(
              builder: (_) => Text(
                    settingsStore.transactionPriority.toString(),
                    style: TextStyle(
                        fontSize: 16.0,
                        color: _isDarkTheme
                            ? PaletteDark.darkThemeGrey
                            : Palette.wildDarkBlue),
                  )),
          attribute: Attributes.widget),
      SettingsItem(
          title: 'Save recipient address', attribute: Attributes.switcher),
      SettingsItem(title: 'Personal', attribute: Attributes.header),
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
          title: 'Change PIN',
          attribute: Attributes.arrow),
      SettingsItem(
          onTaped: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => ChangeLanguage()));
          },
          title: 'Change language',
          attribute: Attributes.arrow),
      SettingsItem(
          title: 'Allow biometrical authentication',
          attribute: Attributes.switcher),
      SettingsItem(title: 'Dark mode', attribute: Attributes.switcher),
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
                                        Text('Transactions'),
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
                                        Text('Trades'),
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
                        Text('Display on dashboard list',
                            style: TextStyle(
                                fontSize: 16,
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeTitle
                                    : Colors.black)),
                        Observer(builder: (_) {
                          var title = '';

                          if (settingsStore.actionlistDisplayMode.length ==
                              ActionListDisplayMode.values.length) {
                            title = 'ALL';
                          }

                          if (title.isEmpty &&
                              settingsStore.actionlistDisplayMode
                                  .contains(ActionListDisplayMode.trades)) {
                            title = 'Only trades';
                          }

                          if (title.isEmpty &&
                              settingsStore.actionlistDisplayMode.contains(
                                  ActionListDisplayMode.transactions)) {
                            title = 'Only transactions';
                          }

                          if (title.isEmpty) {
                            title = 'None';
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
      SettingsItem(title: 'Support', attribute: Attributes.header),
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
          title: 'Terms and conditions',
          attribute: Attributes.arrow),
      SettingsItem(
          onTaped: () => Navigator.pushNamed(context, Routes.faq),
          title: 'FAQ',
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

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please select:'),
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
                            child: Text(list[index].toString()),
                          ))),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(_value),
                  child: Text('OK'))
            ],
          );
        });
  }

  void _setBalance(BuildContext context) async {
    final settingsStore = Provider.of<SettingsStore>(context);
    final selectedDisplayMode =
        await _presentPicker(context, BalanceDisplayMode.all);

    if (selectedDisplayMode != null) {
      settingsStore.setCurrentBalanceDisplayMode(
          balanceDisplayMode: selectedDisplayMode);
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
    final selectedPriority =
        await _presentPicker(context, TransactionPriority.all);

    if (selectedPriority != null) {
      settingsStore.setCurrentTransactionPriority(priority: selectedPriority);
    }
  }
}
