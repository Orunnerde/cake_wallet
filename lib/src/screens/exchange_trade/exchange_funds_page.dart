import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/exchange_trade/widgets/copy_button.dart';
import 'package:cake_wallet/src/screens/receive/qr_image.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class ExchangeFundsPage extends BasePage {
  String get title => 'Exchange funds';

  final String address;
  final double exchangeValue;
  final String currencyType;
  final String walletName;

  ExchangeFundsPage(this.address, this.exchangeValue, this.currencyType, this.walletName);

  @override
  Widget trailing(BuildContext context) {
    return ButtonTheme(
      minWidth: double.minPositive,
      child: FlatButton(
        onPressed: (){},
        child: Text('Clear',
          style: TextStyle(
            fontSize: 16.0,
            color: Palette.wildDarkBlue
          ),
        )
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        top: 40.0,
        right: 20.0,
        bottom: 40.0
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              Flexible(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: QrImage(
                    data: address,
                    backgroundColor: Colors.white,
                  ),
                )
              ),
              Spacer(
                flex: 2,
              )
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 50.0,
              right: 50.0
            ),
            child: Text(
              address,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Palette.violet
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 30.0,
                right: 30.0
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(right: 5.0),
                          child: CopyButton(
                            onPressed: (){},
                            text: 'Copy Address'
                          ),
                        )
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: CopyButton(
                            onPressed: (){},
                            text: 'Copy ID'
                          ),
                        )
                      )
                    ],
                  ),
                  Text('By pressing Confirm, you will be sending $exchangeValue $currencyType from '
                       'your wallet called $walletName to the address shown Above. '
                       'Or you can send from your external wallet to the above '
                       'address/QR code.\n\n'
                       'Please press confirm to continue or go back to change '
                       'the amounts.',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14.0),
                  )
                ],
              ),
            )
          ),
          Container(
            padding: EdgeInsets.only(
              left: 30.0,
              right: 30.0,
              bottom: 25.0
            ),
            alignment: Alignment.centerLeft,
            child: Text('*Please copy or write down your ID shown above',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Palette.wildDarkBlue
              ),
            ),
          ),
          PrimaryButton(
            onPressed: (){},
            text: 'Confirm'
          )
        ],
      ),
    );
  }
}