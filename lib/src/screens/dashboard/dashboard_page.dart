import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';
import 'package:cake_wallet/src/domain/common/transaction_direction.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/stores/balance/balance_store.dart';
import 'package:cake_wallet/src/stores/sync/sync_store.dart';
import 'package:cake_wallet/src/stores/transaction_list/transaction_list_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/screens/dashboard/date_section_item.dart';
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

  static List<Object> formatTransactionsList(
      List<TransactionInfo> transactions) {
    var formattedList = List<Object>();
    DateTime lastDate;
    transactions.sort((a, b) => b.date.compareTo(a.date));

    for (int i = 0; i < transactions.length; i++) {
      final transaction = transactions[i];
      final txDateUtc = transaction.date.toUtc();
      final txDate = DateTime(txDateUtc.year, txDateUtc.month, txDateUtc.day);

      if (lastDate == null) {
        lastDate = txDate;
        formattedList.add(DateSectionItem(transaction.date));
        formattedList.add(transaction);
        continue;
      }

      if (lastDate.compareTo(txDate) == 0) {
        formattedList.add(transaction);
        continue;
      }

      lastDate = txDate;
      formattedList.add(DateSectionItem(transaction.date));
      formattedList.add(transaction);
    }

    return formattedList;
  }

  @override
  Widget build(BuildContext context) {
    final balanceStore = Provider.of<BalanceStore>(context);
    final transactionListStore = Provider.of<TransactionListStore>(context);
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
          final items = transactionListStore.transactions == null
              ? []
              : formatTransactionsList(transactionListStore.transactions);

          return ListView.builder(
              key: _listKey,
              padding: EdgeInsets.only(bottom: 15),
              itemCount: items.length + 1,
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
                                            BalanceDisplayMode.availableBalance
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
                                      }),
                                ),
                                // Container(
                                //   margin: EdgeInsets.only(top: 45),
                                //   decoration: BoxDecoration(
                                //       color: Palette.containerLavender,
                                //       borderRadius: BorderRadius.circular(5)),
                                //   padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                //   child: SizedBox(
                                //       width: 125,
                                //       child: Observer(
                                //           key: _syncingObserverKey,
                                //           builder: (_) {
                                //             if (syncStore.status
                                //                     is SyncingSyncStatus ||
                                //                 syncStore.status
                                //                     is RestoringSyncStatus) {
                                //               return Row(
                                //                   mainAxisAlignment:
                                //                       MainAxisAlignment
                                //                           .spaceBetween,
                                //                   children: <Widget>[
                                //                     Image.asset(
                                //                       'assets/images/refresh_icon.png',
                                //                       width: 10,
                                //                       height: 10,
                                //                     ),
                                //                     Text(
                                //                         'BLOCKS REMAINING ${syncStore.status.toString()}',
                                //                         style: TextStyle(
                                //                             fontSize: 8,
                                //                             color: Palette
                                //                                 .wildDarkBlue))
                                //                   ]);
                                //             }

                                //             var text = '';

                                //             if (syncStore.status
                                //                 is SyncedSyncStatus) {
                                //               text = 'SYNCRONIZED';
                                //             }

                                //             if (syncStore.status
                                //                 is NotConnectedSyncStatus) {
                                //               text = 'NOT CONNECTED';
                                //             }

                                //             if (syncStore.status
                                //                 is FailedSyncStatus) {
                                //               text =
                                //                   'FAILED CONNECT TO THE NODE';
                                //             }

                                //             if (syncStore.status
                                //                 is StartingSyncStatus) {
                                //               text = 'STARTING SYNC';
                                //             }

                                //             if (syncStore.status
                                //                 is ConnectingSyncStatus) {
                                //               text = 'CONNECTING';
                                //             }

                                //             if (syncStore.status
                                //                 is ConnectedSyncStatus) {
                                //               text = 'CONNECTED';
                                //             }

                                //             return Center(
                                //               child: Text(text,
                                //                   style: TextStyle(
                                //                       fontSize: 9,
                                //                       color: Palette
                                //                           .wildDarkBlue)),
                                //             );
                                //           })
                                //           ),
                                // ),
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

                index -= 1;
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

                if (item is TransactionInfo) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.transactionDetails,
                          arguments: item);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 14, bottom: 14, left: 20, right: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: PaletteDark.darkGrey,
                            width: 0.5,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Row(children: <Widget>[
                        Image.asset(
                            item.direction == TransactionDirection.incoming
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        item.direction ==
                                                TransactionDirection.incoming
                                            ? 'Received'
                                            : 'Sent',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: _isDarkTheme
                                                ? Palette.blueGrey
                                                : Colors.black)),
                                    Text(item.amount(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Palette.purpleBlue))
                                  ]),
                              SizedBox(height: 6),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        transactionDateFormat.format(item.date),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Palette.blueGrey)),
                                    Text(item.fiatAmount(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Palette.blueGrey))
                                  ]),
                            ],
                          ),
                        ))
                      ]),
                    ),
                  );
                }

                return Container();
              });
        });
  }
}
