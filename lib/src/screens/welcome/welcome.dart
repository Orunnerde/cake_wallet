import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/routes.dart';

class Welcome extends StatelessWidget {
  static const _aspectRatioImage = 1.26;
  static const _baseWidth = 411.43;
  final _image = Image.asset('assets/images/welcomeImg.png');

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = _screenWidth < _baseWidth ? 0.76 : 1;
    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: _aspectRatioImage,
            child: FittedBox(child: _image, fit: BoxFit.fill)
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('WELCOME\nTO CAKE WALLET',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: textScaleFactor,
                      textAlign: TextAlign.center,
                    ),
                    Text('Awesome wallet\nfor Monero',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Palette.lightBlue,
                      ),
                      textScaleFactor: textScaleFactor,
                      textAlign: TextAlign.center,
                    ),
                    Text('Please make a selection below to either create\na new wallet or restore a wallet',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Palette.lightBlue,
                      ),
                      textScaleFactor: textScaleFactor,
                      textAlign: TextAlign.center,
                    )
                  ]),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Column(
                      children: <Widget>[
                        PrimaryButton(
                          onPressed: (){
                            Navigator.pushNamed(context, newWalletFromWelcomeRoute);
                          },
                          text: 'Create new',
                        ),
                        SizedBox(height: 10),
                        PrimaryButton(
                          onPressed: (){},
                          color: Palette.indigo,
                          borderColor: Palette.deepIndigo,
                          text: 'Restore',
                        )
                      ]))
              ]))
        ])
    
    );
  }
}