import 'package:cake_wallet/src/stores/action_list/action_list_display_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/common/transaction_direction.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_provider_description.dart';
import 'package:cake_wallet/src/stores/action_list/action_list_store.dart';
import 'package:cake_wallet/src/stores/balance/balance_store.dart';
import 'package:cake_wallet/src/stores/sync/sync_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/theme_changer.dart';

class DashboardPage extends BasePage {
  final _bodyKey = GlobalKey();

  @override
  Widget leading(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme)
      _isDarkTheme = true;
    else
      _isDarkTheme = false;

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
                          arguments: [
                            (auth, authContext) => Navigator.of(authContext)
                                .popAndPushNamed(Routes.seed)
                          ]);
                    }),
                CupertinoActionSheetAction(
                    child: const Text('Show keys'),
                    onPressed: () {
                      Navigator.of(context).pop();

                      Navigator.of(context).pushNamed(Routes.auth, arguments: [
                        (auth, authContext) => Navigator.of(authContext)
                            .popAndPushNamed(Routes.showKeys)
                      ]);
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
  static final transactionDateFormat = DateFormat("dd.MM.yyyy, HH:mm");
  static final dateSectionDateFormat = DateFormat("d MMM");
  static final nowDate = DateTime.now();

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
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme)
      _isDarkTheme = true;
    else
      _isDarkTheme = false;

    return Observer(
        key: _listObserverKey,
        builder: (_) {
          final items =
              actionListStore.items == null ? [] : actionListStore.items;

          return ListView.builder(
              key: _listKey,
              padding: EdgeInsets.only(bottom: 15),
              itemCount: items.length + 2,
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

                if (index == 1) {
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
                            child: Text('Filters'),
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
                          ),
                          SizedBox(width: 10),
                          PopupMenuButton<ActionListDisplayMode>(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value:
                                            ActionListDisplayMode.transactions,
                                        child: Observer(
                                            builder: (_) => Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Transactions'),
                                                      Checkbox(
                                                        value: settingsStore
                                                            .actionlistDisplayMode
                                                            .contains(
                                                                ActionListDisplayMode
                                                                    .transactions),
                                                        onChanged: (value) =>
                                                            settingsStore
                                                                .toggleTransactionsDisplay(),
                                                      )
                                                    ]))),
                                    PopupMenuItem(
                                        value: ActionListDisplayMode.trades,
                                        child: Observer(
                                            builder: (_) => Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Trades'),
                                                      Checkbox(
                                                        value: settingsStore
                                                            .actionlistDisplayMode
                                                            .contains(
                                                                ActionListDisplayMode
                                                                    .trades),
                                                        onChanged: (value) =>
                                                            settingsStore
                                                                .toggleTradesDisplay(),
                                                      )
                                                    ])))
                                  ],
                              child: Observer(builder: (_) {
                                var title = '';

                                if (settingsStore
                                        .actionlistDisplayMode.length ==
                                    ActionListDisplayMode.values.length) {
                                  title = 'ALL';
                                }

                                if (title.isEmpty &&
                                    settingsStore.actionlistDisplayMode
                                        .contains(
                                            ActionListDisplayMode.trades)) {
                                  title = 'Only trades';
                                }

                                if (title.isEmpty &&
                                    settingsStore.actionlistDisplayMode
                                        .contains(ActionListDisplayMode
                                            .transactions)) {
                                  title = 'Only transactions';
                                }

                                if (title.isEmpty) {
                                  title = 'None';
                                }

                                return Text('Display: ' + title);
                              })),
                        ]),
                  );
                }

                index -= 2;
                final item = items[index];

                if (item is DateSectionItem) {
                  final diffDays = item.date.difference(nowDate).inDays;

                  // final txDateUtc = item.date.toUtc();
                  // final txDate = DateTime(txDateUtc.year, txDateUtc.month, txDateUtc.day);

                  var title = "";

                  // var r = nowDate.compareTo(txDate);

                  // print('Test $r');

                  if (diffDays == 0) {
                    title = "Today";
                  } else if (diffDays == -1) {
                    title = "Yesterday";
                  } else if (diffDays > -7 && diffDays < 0) {
                    final dateFormat = DateFormat("EEEE");
                    title = dateFormat.format(item.date);
                  } else {
                    title = dateSectionDateFormat.format(item.date);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                        child: Text(title,
                            style: TextStyle(
                                fontSize: 16, color: Palette.wildDarkBlue))),
                  );
                }

                if (item is TransactionListItem) {
                  final transaction = item.transaction;

                  return TransactionRow(
                      onTap: () => Navigator.of(context).pushNamed(
                          Routes.transactionDetails,
                          arguments: transaction),
                      direction: transaction.direction,
                      formattedDate:
                          transactionDateFormat.format(transaction.date),
                      formattedAmount: transaction.amount(),
                      formattedFiatAmount: transaction.fiatAmount());
                }

                if (item is TradeListItem) {
                  final trade = item.trade;

                  return TradeRow(
                      onTap: () => null,
                      provider: trade.provider,
                      from: trade.from,
                      to: trade.to,
                      createdAtFormattedDate:
                          DateFormat("dd.MM.yyyy, H:m").format(trade.createdAt),
                      formattedAmount: trade.amount);
                }

                return Container();
              });
        });
  }
}

class TransactionRow extends StatelessWidget {
  final VoidCallback onTap;
  final TransactionDirection direction;
  final String formattedDate;
  final String formattedAmount;
  final String formattedFiatAmount;

  TransactionRow(
      {this.direction,
      this.formattedDate,
      this.formattedAmount,
      this.formattedFiatAmount,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final _isDarkTheme = false;

    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 14, bottom: 14, left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: PaletteDark.darkGrey,
                      width: 0.5,
                      style: BorderStyle.solid))),
          child: Row(children: <Widget>[
            Image.asset(
                direction == TransactionDirection.incoming
                    ? 'assets/images/transaction_incoming.png'
                    : 'assets/images/transaction_outgoing.png',
                height: 25,
                width: 25),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            direction == TransactionDirection.incoming
                                ? 'Received'
                                : 'Sent',
                            style: TextStyle(
                                fontSize: 16,
                                color: _isDarkTheme
                                    ? Palette.blueGrey
                                    : Colors.black)),
                        Text(formattedAmount,
                            style: const TextStyle(
                                fontSize: 16, color: Palette.purpleBlue))
                      ]),
                  SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(formattedDate,
                            style: const TextStyle(
                                fontSize: 13, color: Palette.blueGrey)),
                        Text(formattedFiatAmount,
                            style: const TextStyle(
                                fontSize: 14, color: Palette.blueGrey))
                      ]),
                ],
              ),
            ))
          ]),
        ));
  }
}

class TradeRow extends StatelessWidget {
  final VoidCallback onTap;
  final ExchangeProviderDescription provider;
  final CryptoCurrency from;
  final CryptoCurrency to;
  final String createdAtFormattedDate;
  final String formattedAmount;

  TradeRow(
      {this.provider,
      this.from,
      this.to,
      this.createdAtFormattedDate,
      this.formattedAmount,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final _isDarkTheme = false;

    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 14, bottom: 14, left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: PaletteDark.darkGrey,
                      width: 0.5,
                      style: BorderStyle.solid))),
          child: Row(children: <Widget>[
            _getPoweredImage(provider),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${from.toString()} �� ${to.toString()}',
                            style: TextStyle(
                                fontSize: 16,
                                color: _isDarkTheme
                                    ? Palette.blueGrey
                                    : Colors.black)),
                        Text(formattedAmount ?? '',
                            style: const TextStyle(
                                fontSize: 16, color: Palette.purpleBlue))
                      ]),
                  SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(createdAtFormattedDate,
                            style: const TextStyle(
                                fontSize: 13, color: Palette.blueGrey)),
                        // Text(formattedFiatAmount,
                        //     style: const TextStyle(
                        //         fontSize: 14, color: Palette.blueGrey))
                      ]),
                ],
              ),
            ))
          ]),
        ));
  }

  Image _getPoweredImage(ExchangeProviderDescription provider) {
    Image image;
    switch (provider) {
      case ExchangeProviderDescription.xmrto:
        image = Image.asset('assets/images/xmr_btc.png');
        break;
      case ExchangeProviderDescription.changeNow:
        image = Image.asset('assets/images/change_now.png');
        break;
      default:
        image = null;
    }
    return image;
  }
}
