import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/exchange_trade/widgets/copy_button.dart';
import 'package:cake_wallet/src/screens/receive/qr_image.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'dart:async';

class ExchangeTradePage extends BasePage {
  String get title => 'Exchange';

  final String exchangeID;
  final double amount;
  final String paymentID;
  final String status;
  final int exchangeTime;
  final String address;
  final double exchangeValue;
  final String currencyType;
  final String walletName;
  final String poweredTrade;

  ExchangeTradePage(
      this.exchangeID,
      this.amount,
      this.paymentID,
      this.status,
      this.exchangeTime,
      this.address,
      this.exchangeValue,
      this.currencyType,
      this.walletName,
      this.poweredTrade
      );

  @override
  Widget body(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('ID: ',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Text('$exchangeID',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Palette.wildDarkBlue
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Amount: ',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Text('$amount',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Palette.wildDarkBlue
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Payment ID: ',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Text('$paymentID',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Palette.wildDarkBlue
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Status: ',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Text('$status',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Palette.wildDarkBlue
                          ),
                        )
                      ],
                    ),
                    TimerWidget(exchangeTime)
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Spacer(),
                        Flexible(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: QrImage(
                              data: address,
                              backgroundColor: Colors.white,
                            ),
                          )
                        ),
                        Spacer()
                      ],
                    ), 
                    SizedBox(height: 7.0,),
                    Text('This trade is powered by $poweredTrade',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
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
              Container(
                padding: EdgeInsets.only(
                  left: 50.0,
                  right: 50.0
                ),
                child: Row(
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
              )
            ],
          )
        ),
        Container(
          padding: EdgeInsets.only(
            left: 30.0,
            right: 30.0
          ),
          child: Text('By pressing confirm, you will be sending $exchangeValue $currencyType from '
                      'your wallet called $walletName to the address shown above.'
                      '\n\n'
                      'Please press confirm to continue or go back to change the amounts.'
                      '\n\n'
                      '*Please copy or write down your ID shown above',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.0),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: 20.0,
            top: 20.0,
            right: 20.0,
            bottom: 40.0
          ),
          child: PrimaryButton(
            onPressed: (){},
            text: 'Confirm'
          ),
        )
      ],
    );
  }
}

class TimerWidget extends StatefulWidget {

  final int exchangeTime;

  TimerWidget(this.exchangeTime);

  @override
  createState() => TimerWidgetState(exchangeTime);

}

class TimerWidgetState extends State<TimerWidget> {

  int _exchangeTime;
  int _minutes;
  int _seconds;
  Timer _timer;

  TimerWidgetState(this._exchangeTime);

  void exchangeTimer() {
    if (_exchangeTime > 0) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _exchangeTime--;
        _minutes = _exchangeTime~/60;
        _seconds = _exchangeTime%60;
        setState(() {});
        if (_exchangeTime == 0) Navigator.pop(context);
      });
    } else Navigator.pop(context);
  }

  _afterLayout(_) {
    exchangeTimer();
  }

  @override
  void initState() {
    super.initState();
    _minutes = _exchangeTime~/60;
    _seconds = _exchangeTime%60;
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Offer expires in: ',
          style: TextStyle(fontSize: 14.0),
        ),
        Text('${_minutes}m ${_seconds}s',
          style: TextStyle(
            fontSize: 14.0,
            color: Palette.wildDarkBlue
          ),
        )
      ],
    );
  }

}