import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:intl/intl.dart';

class TradeHistoryPage extends BasePage {
  String get title => 'Copy ID';
  bool get isModalBackButton => true;

  final Image imageXmr = Image.asset('assets/images/xmr_to.png');
  final List<DateTime>dateTimeList;

  TradeHistoryPage(this.dateTimeList);

  @override
  Widget body(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => Divider(
        color: Palette.lightGrey,
        height: 3.0,
      ),
      itemCount: dateTimeList == null ? 0 : dateTimeList.length,
      itemBuilder: (BuildContext context, int index){
        final date = DateFormat("dd-MM-yyyy").format(dateTimeList[index]);
        final time = DateFormat("H:m").format(dateTimeList[index]);

        return Container(
          child: Column(
            children: <Widget>[
              index == 0 ? Divider(
                color: Palette.lightGrey,
                height: 3.0,
              ) : Offstage(),
              ListTile(
                leading: imageXmr,
                title: Text('XMR.TO',
                  style: TextStyle(fontSize: 16.0),
                ),
                trailing: Text('$date, $time',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Palette.wildDarkBlue
                  ),
                )
              ),
              index == dateTimeList.length - 1 ? Divider(
                color: Palette.lightGrey,
                height: 3.0,
              ) : Offstage(),
            ],
          ),
        );
      },
    );
  }
}