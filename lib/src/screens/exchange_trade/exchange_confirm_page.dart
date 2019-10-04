import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/stores/exhange_trade/exchange_trade_store.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/domain/exchange/trade.dart';

class ExchangeConfirmPage extends BasePage {
  String get title => 'Copy ID';

  @override
  Widget body(BuildContext context) {
    //final exchangeTradeStore = Provider.of<ExchangeTradeStore>(context);
    final Trade trade = ModalRoute.of(context).settings.arguments;

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: 80.0,
              right: 80.0
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Please copy or write down the trade ID to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 70.0,),
                  Text('Trade ID:\n${trade.id}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 70.0,),
                  PrimaryButton(
                    onPressed: (){},
                    text: 'Copy ID',
                    color: Palette.brightBlue,
                    borderColor: Palette.cloudySky,
                  )
                ],
              ),
            )
          )
        ),
        Container(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 40.0
          ),
          child: PrimaryButton(
            onPressed: (){},
            text: "I've saved the trade ID"
          ),
        )
      ],
    );
  }
}