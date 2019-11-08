import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_provider_description.dart';
import 'package:cake_wallet/src/stores/action_list/action_list_store.dart';
import 'package:cake_wallet/src/stores/balance/balance_store.dart';
import 'package:cake_wallet/src/stores/sync/sync_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/stores/action_list/date_section_item.dart';
import 'package:cake_wallet/src/stores/action_list/trade_list_item.dart';
import 'package:cake_wallet/src/stores/action_list/transaction_list_item.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/screens/dashboard/date_section_raw.dart';
import 'package:cake_wallet/src/screens/dashboard/trade_row.dart';
import 'package:cake_wallet/src/screens/dashboard/transaction_raw.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/theme_changer.dart';

class DashboardPage extends BasePage {
  final _bodyKey = GlobalKey();

  @override
  Widget leading(BuildContext context) {
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    return SizedBox(
        width: 30,
        child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () => _presentWalletMenu(context),
            child: Image.asset('assets/images/more.png',
                color: _isDarkTheme ? Colors.white : Colors.black, width: 30)));
  }

  @override
  Widget middle(BuildContext context) {
    final walletStore = Provider.of<WalletStore>(context);

    return Observer(builder: (_) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(walletStore.name),
            SizedBox(height: 5),
            Text(
              walletStore.account != null ? walletStore.account.label : '',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
            ),
          ]);
    });
  }

  @override
  Widget trailing(BuildContext context) {
    return SizedBox(
      width: 20,
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
          child: Image.asset('assets/images/settings_icon.png',
              color: Colors.grey, height: 20)),
    );
  }

  @override
  Widget body(BuildContext context) => DashboardPageBody(key: _bodyKey);

  @override
  Widget floatingActionButton(BuildContext context) => FloatingActionButton(
      child: Image.asset('assets/images/exchange_icon.png',
          color: Colors.white, height: 26, width: 22),
      backgroundColor: Color.fromRGBO(213, 56, 99, 1),
      onPressed: () => Navigator.of(context, rootNavigator: true)
          .pushNamed(Routes.exchange));

  Future _presentReconnectAlert(BuildContext context) async {
    final walletStore = Provider.of<WalletStore>(context);

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Reconnection',
              textAlign: TextAlign.center,
            ),
            content: Text('Are you sure to reconnect ?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    walletStore.reconnect();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  void _presentWalletMenu(BuildContext bodyContext) {
    showDialog(
        context: bodyContext,
        builder: (context) {
          return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                    child: const Text('Rescan'),
                    onPressed: () =>
                        Navigator.of(context).popAndPushNamed(Routes.rescan)),
                CupertinoActionSheetAction(
                    child: const Text('Reconnect'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _presentReconnectAlert(bodyContext);
                    }),
                CupertinoActionSheetAction(
                    child: const Text('Accounts'),
                    onPressed: () => Navigator.of(context)
                        .popAndPushNamed(Routes.accountList)),
                CupertinoActionSheetAction(
                    child: const Text('Wallets'),
                    onPressed: () => Navigator.of(context)
                        .popAndPushNamed(Routes.walletList)),
                CupertinoActionSheetAction(
                    child: const Text('Show seed'),
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed(Routes.auth,
                          arguments: (isAuthenticatedSuccessfully, auth) =>
                              isAuthenticatedSuccessfully
                                  ? Navigator.of(auth.context)
                                      .popAndPushNamed(Routes.seed)
                                  : null);
                    }),
                CupertinoActionSheetAction(
                    child: const Text('Show keys'),
                    onPressed: () {
                      Navigator.of(context).pop();

                      Navigator.of(context).pushNamed(Routes.auth,
                          arguments: (isAuthenticatedSuccessfully, auth) =>
                              isAuthenticatedSuccessfully
                                  ? Navigator.of(auth.context)
                                      .popAndPushNamed(Routes.showKeys)
                                  : null);
                    }),
                CupertinoActionSheetAction(
                    child: const Text('Address book'),
                    onPressed: () => Navigator.of(context)
                        .popAndPushNamed(Routes.addressBook)),
              ],
              cancelButton: CupertinoActionSheetAction(
                  child: const Text('Cancel'),
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(context).pop()),
            )
          ]);
        });
  }
}

class DashboardPageBody extends StatefulWidget {
  DashboardPageBody({Key key}) : super(key: key);

  @override
  DashboardPageBodyState createState() => DashboardPageBodyState();
}

class DashboardPageBodyState extends State<DashboardPageBody> {
  static final transactionDateFormat = DateFormat("MMM d, yyyy HH:mm");

  final _connectionStatusObserverKey = GlobalKey();
  final _balanceObserverKey = GlobalKey();
  final _balanceTitleObserverKey = GlobalKey();
  final _syncingObserverKey = GlobalKey();
  final _listObserverKey = GlobalKey();
  final _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final balanceStore = Provider.of<BalanceStore>(context);
    final actionListStore = Provider.of<ActionListStore>(context);
    final syncStore = Provider.of<SyncStore>(context);
    final settingsStore = Provider.of<SettingsStore>(context);
    final _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    return Observer(
        key: _listObserverKey,
        builder: (_) {
          final items =
              actionListStore.items == null ? [] : actionListStore.items;
          final itemsCount = items.length + 2;

          return ListView.builder(
              key: _listKey,
              padding: EdgeInsets.only(bottom: 15),
              itemCount: itemsCount,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: _isDarkTheme
                            ? Theme.of(context).backgroundColor
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Palette.shadowGreyWithOpacity,
                              blurRadius: 10,
                              offset: Offset(0, 12))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Observer(
                            key: _syncingObserverKey,
                            builder: (_) {
                              final status = syncStore.status;
                              final statusText = status.title();
                              final progress = syncStore.status.progress();
                              final isFialure = status is FailedSyncStatus;

                              var descriptionText = '';

                              if (status is SyncingSyncStatus) {
                                descriptionText =
                                    '${syncStore.status.toString()} Blocks Remaining ';
                              }

                              if (status is FailedSyncStatus) {
                                descriptionText =
                                    'Please try to connect to another node';
                              }

                              return Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 3,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Palette.separator,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Palette.cakeGreen),
                                        value: progress,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(statusText,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isFialure
                                                ? Color.fromRGBO(226, 35, 35, 1)
                                                : Palette.cakeGreen)),
                                    Text(descriptionText,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Palette.wildDarkBlue,
                                            height: 2.0))
                                  ],
                                ),
                              );
                            }),
                        GestureDetector(
                          onTapUp: (_) => balanceStore.isReversing = false,
                          onTapDown: (_) => balanceStore.isReversing = true,
                          child: Container(
                            padding: EdgeInsets.only(top: 40, bottom: 40),
                            color: Colors.transparent,
                            child: Column(
                              children: <Widget>[
                                Container(width: double.infinity),
                                Observer(
                                    key: _balanceTitleObserverKey,
                                    builder: (_) {
                                      final savedDisplayMode =
                                          settingsStore.balanceDisplayMode;
                                      var title = 'XMR Hidden';
                                      BalanceDisplayMode displayMode =
                                          balanceStore.isReversing
                                              ? (savedDisplayMode.serialize() ==
                                                      BalanceDisplayMode
                                                          .availableBalance
                                                          .serialize()
                                                  ? BalanceDisplayMode
                                                      .fullBalance
                                                  : BalanceDisplayMode
                                                      .availableBalance)
                                              : savedDisplayMode;

                                      if (displayMode.serialize() ==
                                          BalanceDisplayMode.availableBalance
                                              .serialize()) {
                                        title = 'XMR Available Balance';
                                      }

                                      if (displayMode.serialize() ==
                                          BalanceDisplayMode.fullBalance
                                              .serialize()) {
                                        title = 'XMR Full Balance';
                                      }

                                      return Text(title,
                                          style: TextStyle(
                                              color: Palette.violet,
                                              fontSize: 16));
                                    }),
                                Observer(
                                    key: _connectionStatusObserverKey,
                                    builder: (_) {
                                      final savedDisplayMode =
                                          settingsStore.balanceDisplayMode;
                                      var balance = '---';
                                      BalanceDisplayMode displayMode =
                                          balanceStore.isReversing
                                              ? (savedDisplayMode.serialize() ==
                                                      BalanceDisplayMode
                                                          .availableBalance
                                                          .serialize()
                                                  ? BalanceDisplayMode
                                                      .fullBalance
                                                  : BalanceDisplayMode
                                                      .availableBalance)
                                              : savedDisplayMode;

                                      if (displayMode.serialize() ==
                                          BalanceDisplayMode.availableBalance
                                              .serialize()) {
                                        balance =
                                            balanceStore.unlockedBalance ??
                                                '0.0';
                                      }

                                      if (displayMode.serialize() ==
                                          BalanceDisplayMode.fullBalance
                                              .serialize()) {
                                        balance =
                                            balanceStore.fullBalance ?? '0.0';
                                      }

                                      return Text(
                                        balance,
                                        style: TextStyle(
                                            color: _isDarkTheme
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 42),
                                      );
                                    }),
                                Padding(
                                    padding: EdgeInsets.only(top: 7),
                                    child: Observer(
                                        key: _balanceObserverKey,
                                        builder: (_) {
                                          final displayMode =
                                              settingsStore.balanceDisplayMode;
                                          final symbol = settingsStore
                                              .fiatCurrency
                                              .toString();
                                          var balance = '---';

                                          if (displayMode.serialize() ==
                                              BalanceDisplayMode
                                                  .availableBalance
                                                  .serialize()) {
                                            balance =
                                                '${balanceStore.fiatUnlockedBalance} $symbol';
                                          }

                                          if (displayMode.serialize() ==
                                              BalanceDisplayMode.fullBalance
                                                  .serialize()) {
                                            balance =
                                                '${balanceStore.fiatFullBalance} $symbol';
                                          }

                                          return Text(balance,
                                              style: TextStyle(
                                                  color: Palette.wildDarkBlue,
                                                  fontSize: 16));
                                        }))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, bottom: 30),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      child: PrimaryImageButton(
                                    image: Image.asset(
                                        'assets/images/send_icon.png',
                                        height: 25,
                                        width: 25),
                                    text: 'Send',
                                    onPressed: () => Navigator.of(context,
                                            rootNavigator: true)
                                        .pushNamed(Routes.send),
                                    color: _isDarkTheme
                                        ? PaletteDark.darkThemePurpleButton
                                        : Palette.purple,
                                    borderColor: _isDarkTheme
                                        ? PaletteDark
                                            .darkThemePurpleButtonBorder
                                        : Palette.deepPink,
                                  )),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: PrimaryImageButton(
                                    image: Image.asset(
                                        'assets/images/receive_icon.png',
                                        height: 25,
                                        width: 25),
                                    text: 'Receive',
                                    onPressed: () => Navigator.of(context,
                                            rootNavigator: true)
                                        .pushNamed(Routes.receive),
                                    color: _isDarkTheme
                                        ? PaletteDark.darkThemeBlueButton
                                        : Palette.brightBlue,
                                    borderColor: _isDarkTheme
                                        ? PaletteDark.darkThemeBlueButtonBorder
                                        : Palette.cloudySky,
                                  ))
                                ],
                              ),
                            )),
                      ],
                    ),
                  );
                }

                if (index == 1 && actionListStore.items.length > 0) {
                  return Padding(
                    padding: EdgeInsets.only(right: 20, top: 10, bottom: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          PopupMenuButton<int>(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  enabled: false,
                                  value: -1,
                                  child: Text('Transactions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
                              PopupMenuItem(
                                  value: 0,
                                  child: Observer(
                                      builder: (_) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Incoming'),
                                                Checkbox(
                                                  value: actionListStore
                                                      .transactionFilterStore
                                                      .displayIncoming,
                                                  onChanged: (value) =>
                                                      actionListStore
                                                          .transactionFilterStore
                                                          .toggleIncoming(),
                                                )
                                              ]))),
                              PopupMenuItem(
                                  value: 1,
                                  child: Observer(
                                      builder: (_) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Outgoing'),
                                                Checkbox(
                                                  value: actionListStore
                                                      .transactionFilterStore
                                                      .displayOutgoing,
                                                  onChanged: (value) =>
                                                      actionListStore
                                                          .transactionFilterStore
                                                          .toggleOutgoing(),
                                                )
                                              ]))),
                              PopupMenuItem(
                                  value: 2,
                                  child: Text('Transactions by date')),
                              PopupMenuDivider(),
                              PopupMenuItem(
                                  enabled: false,
                                  value: -1,
                                  child: Text('Trades',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
                              PopupMenuItem(
                                  value: 3,
                                  child: Observer(
                                      builder: (_) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('XMR.TO'),
                                                Checkbox(
                                                  value: actionListStore
                                                      .tradeFilterStore
                                                      .displayXMRTO,
                                                  onChanged: (value) =>
                                                      actionListStore
                                                          .tradeFilterStore
                                                          .toggleDisplayExchange(
                                                              ExchangeProviderDescription
                                                                  .xmrto),
                                                )
                                              ]))),
                              PopupMenuItem(
                                  value: 4,
                                  child: Observer(
                                      builder: (_) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Change.NOW'),
                                                Checkbox(
                                                  value: actionListStore
                                                      .tradeFilterStore
                                                      .displayChangeNow,
                                                  onChanged: (value) =>
                                                      actionListStore
                                                          .tradeFilterStore
                                                          .toggleDisplayExchange(
                                                              ExchangeProviderDescription
                                                                  .changeNow),
                                                )
                                              ])))
                            ],
                            child: Text('Filters',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: _isDarkTheme
                                        ? PaletteDark.darkThemeGrey
                                        : Palette.wildDarkBlue)),
                            onSelected: (item) async {
                              if (item == 2) {
                                final List<DateTime> picked =
                                    await DateRagePicker.showDatePicker(
                                        context: context,
                                        initialFirstDate: DateTime.now()
                                            .subtract(Duration(days: 1)),
                                        initialLastDate: (DateTime.now()),
                                        firstDate: DateTime(2015),
                                        lastDate: DateTime.now()
                                            .add(Duration(days: 1)));

                                if (picked != null && picked.length == 2) {
                                  actionListStore.transactionFilterStore
                                      .changeStartDate(picked.first);
                                  actionListStore.transactionFilterStore
                                      .changeEndDate(picked.last);
                                }
                              }
                            },
                          )
                        ]),
                  );
                }

                index -= 2;

                if (index < 0 || index >= items.length) {
                  return Container();
                }

                final item = items[index];

                if (item is DateSectionItem) {
                  return DateSectionRaw(date: item.date);
                }

                if (item is TransactionListItem) {
                  final transaction = item.transaction;
                  final savedDisplayMode = settingsStore.balanceDisplayMode;
                  final formattedAmount = savedDisplayMode.serialize() ==
                          BalanceDisplayMode.hiddenBalance.serialize()
                      ? '---'
                      : transaction.amount();
                  final formattedFiatAmount = savedDisplayMode.serialize() ==
                          BalanceDisplayMode.hiddenBalance.serialize()
                      ? '---'
                      : transaction.fiatAmount();

                  return TransactionRow(
                      onTap: () => Navigator.of(context).pushNamed(
                          Routes.transactionDetails,
                          arguments: transaction),
                      direction: transaction.direction,
                      formattedDate:
                          transactionDateFormat.format(transaction.date),
                      formattedAmount: formattedAmount,
                      formattedFiatAmount: formattedFiatAmount,
                      isPending: transaction.isPending,
                      isDarkTheme: _isDarkTheme);
                }

                if (item is TradeListItem) {
                  final trade = item.trade;
                  final savedDisplayMode = settingsStore.balanceDisplayMode;
                  final formattedAmount = trade.amount != null
                      ? savedDisplayMode.serialize() ==
                              BalanceDisplayMode.hiddenBalance.serialize()
                          ? '---'
                          : trade.amount
                      : trade.amount;

                  return TradeRow(
                      onTap: () => Navigator.of(context)
                          .pushNamed(Routes.tradeDetails, arguments: trade),
                      provider: trade.provider,
                      from: trade.from,
                      to: trade.to,
                      createdAtFormattedDate:
                          DateFormat("dd.MM.yyyy, H:m").format(trade.createdAt),
                      formattedAmount: formattedAmount,
                      isDarkTheme: _isDarkTheme);
                }

                return Container();
              });
        });
  }
}
