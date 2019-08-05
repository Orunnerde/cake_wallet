import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _welcomeImg = new AssetImage('lib/src/screens/welcome/images/welcomeImg.png');
    var _image = new Image(image: _welcomeImg, fit: BoxFit.contain);

    double _firstTextFontSize = 40.0;
    double _secondTextFontSize = 30.0;
    double _thirdTextFontSize = 18.5;
    double _buttonTextFontSize = 20.0;

    double _buttonHeight = 50.0;

    Color _textColor = Colors.indigo[300];
    Color _buttonCreateColor = Colors.purple[50];
    Color _buttonRestoreColor = Colors.indigo[50];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Center(
              child: _image,
            ),
            Text('WELCOME\n TO CAKE WALLET',
              style: TextStyle(fontSize: _firstTextFontSize),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text('Awesome wallet\nfor Monero',
              style: TextStyle(fontSize: _secondTextFontSize, color: _textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 25.0,
            ),
            Text('Please make a selection below to either create a new wallet or restore a wallet',
              style: TextStyle(fontSize: _thirdTextFontSize, color: _textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 25.0,
            ),
            ButtonTheme(
              minWidth: double.infinity,
              height: _buttonHeight,
              buttonColor: _buttonCreateColor,
              child: RaisedButton(
                onPressed: (){},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text('Create new',
                  style: TextStyle(
                      fontSize: _buttonTextFontSize
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ButtonTheme(
              minWidth: double.infinity,
              height: _buttonHeight,
              buttonColor: _buttonRestoreColor,
              child: RaisedButton(
                onPressed: (){},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text('Restore',
                  style: TextStyle(
                      fontSize: _buttonTextFontSize
                  ),
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}