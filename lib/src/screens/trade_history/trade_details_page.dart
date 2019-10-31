import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/screens/transaction_details/standart_list_item.dart';
import 'package:cake_wallet/src/screens/transaction_details/standart_list_row.dart';
import 'package:cake_wallet/src/stores/exchange_trade/exchange_trade_store.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class TradeDetailsPage extends BasePage {
  String get title => 'Trade Details';

  @override
  Widget body(BuildContext context) {
    final exchangeStore = Provider.of<ExchangeTradeStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    return Column(
      children: <Widget>[
        SizedBox(height: 10.0),
        Expanded(
            child: Stack(
          children: <Widget>[
            _isDarkTheme
                ? Container(
                    height: 10.0,
                  )
                : Container(
                    height: 10.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [Palette.lightGrey2, Colors.white],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 1.0),
                    )),
                  ),
            Container(
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 20.0, left: 20, right: 20),
                child: Observer(builder: (_) {
                  final trade = exchangeStore.trade;
                  final items = [
                    StandartListItem(title: 'ID', value: trade.id),
                    StandartListItem(
                        title: 'State',
                        value: trade.state != null
                            ? trade.state.toString()
                            : 'Fetching')
                  ];

                  if (trade.provider != null) {
                    items.add(StandartListItem(
                        title: 'Provider', value: trade.provider.toString()));
                  }

                  if (trade.createdAt != null) {
                    items.add(StandartListItem(
                        title: 'Created at',
                        value: trade.createdAt.toString()));
                  }

                  if (trade.from != null && trade.to != null) {
                    items.add(StandartListItem(
                        title: 'Pair',
                        value:
                            '${trade.from.toString()} → ${trade.to.toString()}'));
                  }

                  return ListView.separated(
                      separatorBuilder: (_, __) => Divider(
                            color: _isDarkTheme
                                ? PaletteDark.darkThemeGreyWithOpacity
                                : Palette.lightGrey,
                            height: 1.0,
                          ),
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: '${item.value}'));
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.title} copied to Clipboard'),
                                backgroundColor: Colors.green,
                                duration: Duration(milliseconds: 1500),
                              ),
                            );
                          },
                          child: StandartListRow(
                              title: '${item.title}', value: '${item.value}')
                        );
                      });
                }))
          ],
        ))
      ],
    );
  }
}
