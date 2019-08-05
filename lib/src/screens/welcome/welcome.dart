import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Welcome image

    var _image = new Image(image: AssetImage('lib/src/screens/welcome/images/welcomeImg.png'));

    // Scales of widgets

    const double _imageScale = 0.4;
    const double _firstTextScale = 0.13;
    const double _secondTextScale = 0.1;
    const double _thirdTextScale = 0.07;
    const double _buttonScale = 0.07;
    const double _buttonTextScale = 0.03;
    const double _marginScale = 0.02;

    // Values of insets and radius

    const double _insets = 10.0;
    const double _radius = 10.0;

    // Defining of screen height

    double _screenHeight = MediaQuery.of(context).size.height - 2*_insets;

    // Heights of widgets

    double _imageHeight = _imageScale*_screenHeight;
    double _firstTextHeight = _firstTextScale*_screenHeight;
    double _secondTextHeight = _secondTextScale*_screenHeight;
    double _thirdTextHeight = _thirdTextScale*_screenHeight;
    double _buttonHeight = _buttonScale*_screenHeight;
    double _buttonTextFontSize = _buttonTextScale*_screenHeight;
    double _marginHeight = _marginScale*_screenHeight;

    // Colors of widgets

    Color _textColor = Colors.indigo[300];
    Color _buttonCreateColor = Colors.purple[50];
    Color _buttonRestoreColor = Colors.indigo[50];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(_insets),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: _imageHeight,
              child: FittedBox(
                fit: BoxFit.contain,
                child: _image,
              ),
            ),
            SizedText('WELCOME\n TO CAKE WALLET', _firstTextHeight,
              marginTop: _marginHeight,
              marginBottom: _marginHeight,
            ),
            SizedText('Awesome wallet\n for Monero', _secondTextHeight,
              textColor: _textColor,
              marginBottom: _marginHeight,
            ),
            SizedText('Please make a selection below to either create \n a new wallet or restore a wallet', _thirdTextHeight,
              textColor: _textColor,
              marginTop: _marginHeight,
              marginBottom: _marginHeight,
            ),
            ButtonTheme(
              minWidth: double.infinity,
              height: _buttonHeight,
              buttonColor: _buttonCreateColor,
              child: RaisedButton(
                onPressed: (){},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
                child: Text('Create new',
                  style: TextStyle(
                    fontSize: _buttonTextFontSize
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _marginHeight,
            ),
            ButtonTheme(
              minWidth: double.infinity,
              height: _buttonHeight,
              buttonColor: _buttonRestoreColor,
              child: RaisedButton(
                onPressed: (){},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
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

class SizedText extends StatelessWidget{

  final String _text;
  final double _heightContainer;
  Color _textColor;
  double _marginTop, _marginBottom;

  SizedText(this._text, this._heightContainer, {Color textColor = Colors.black,
    double marginTop = 0.0, double marginBottom = 0.0}){

    _textColor = textColor;
    _marginTop = marginTop;
    _marginBottom = marginBottom;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _heightContainer,
      margin: EdgeInsets.only(top: _marginTop, bottom: _marginBottom),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(_text,
          style: TextStyle(color: _textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}