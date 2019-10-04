import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/stores/trade_history/trade_history_store.dart';

class TradeHistoryPage extends BasePage {
  String get title => 'Copy ID';
  bool get isModalBackButton => true;

  @override
  Widget body(BuildContext context) {
    final tradeHistoryStore = Provider.of<TradeHistoryStore>(context);

    return ListView.separated(
      separatorBuilder: (_, __) => Divider(
        color: Palette.lightGrey,
        height: 3.0,
      ),
      itemCount: tradeHistoryStore.tradeList == null
      ? 0
      : tradeHistoryStore.tradeList.length,
      itemBuilder: (BuildContext context, int index){
        final date = DateFormat("dd-MM-yyyy").format(tradeHistoryStore.tradeList[index].createdAt);
        final time = DateFormat("H:m").format(tradeHistoryStore.tradeList[index].createdAt);
        final poweredTitle = tradeHistoryStore.tradeList[index].provider.title;

        return Container(
          child: Column(
            children: <Widget>[
              index == 0 ? Divider(
                color: Palette.lightGrey,
                height: 3.0,
              ) : Offstage(),
              ListTile(
                leading: _getPoweredImage(poweredTitle),
                title: Text('$poweredTitle',
                  style: TextStyle(fontSize: 16.0),
                ),
                trailing: Text('$date, $time',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Palette.wildDarkBlue
                  ),
                )
              ),
              index == tradeHistoryStore.tradeList.length - 1 ? Divider(
                color: Palette.lightGrey,
                height: 3.0,
              ) : Offstage(),
            ],
          ),
        );
      },
    );
  }

  Image _getPoweredImage(String poweredTitle){
    Image image;
    switch (poweredTitle) {
      case 'XMR.TO':
        image = Image.asset('assets/images/xmr_btc.png');
        break;
      case 'ChangeNOW':
        image = Image.asset('assets/images/change_now.png');
        break;
      default:
        image = null;
    }
    return image;
  }
}