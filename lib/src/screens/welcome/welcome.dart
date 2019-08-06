import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Welcome image

    var _image = new Image(image: AssetImage('assets/images/welcomeImg.png'));

    // Scales of widgets

    const double _imageScale = 0.4;
    const double _firstTextScale = 0.12;
    const double _secondTextScale = 0.1;
    const double _thirdTextScale = 0.07;
    const double _marginScale = 0.025;

    // Values of insets and radius

    const double _verticalInsets = 10.0;
    const double _horizontalInsets = 30.0;
    const double _radius = 10.0;

    // Defining of screen height

    double _screenHeight = MediaQuery.of(context).size.height;

    // Heights of widgets

    double _imageHeight = _imageScale*_screenHeight;
    double _firstTextHeight = _firstTextScale*_screenHeight;
    double _secondTextHeight = _secondTextScale*_screenHeight;
    double _thirdTextHeight = _thirdTextScale*_screenHeight;
    double _buttonHeight = 56.0;
    double _buttonTextFontSize = 18.0;
    double _marginHeight = _marginScale*_screenHeight;

    // Colors of widgets

    Color _textColor = Color.fromARGB(255, 126, 147, 177);
    Color _buttonCreateColor = Colors.purple[50];
    Color _borderButtonCreateColor = Colors.deepPurple[100];
    Color _buttonRestoreColor = Colors.indigo[50];
    Color _borderButtonRestoreColor = Colors.indigo[100];

    return Scaffold(
      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: _verticalInsets
          ),
          width: double.infinity,
          height: _imageHeight,
          child: FittedBox(
            fit: BoxFit.cover,
            child: _image,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: _horizontalInsets,
            right: _horizontalInsets,
          ),
          child: Column(
            children: <Widget>[
              SizedText('WELCOME\nTO CAKE WALLET', _firstTextHeight,
                fontWeight: FontWeight.bold,
                marginTop: _marginHeight,
                marginBottom: _marginHeight,
              ),
              SizedText('Awesome wallet\nfor Monero', _secondTextHeight,
                textColor: _textColor,
                fontWeight: FontWeight.bold,
              ),
              SizedText('Please make a selection below to either create\na new wallet or restore a wallet', _thirdTextHeight,
                textColor: _textColor,
                marginTop: _marginHeight,
                marginBottom: _marginHeight,
              ),
              ButtonTheme(
                minWidth: double.infinity,
                height: _buttonHeight,
                child: FlatButton(
                  onPressed: (){},
                  color: _buttonCreateColor,
                  shape: RoundedRectangleBorder(side: BorderSide(color: _borderButtonCreateColor), borderRadius: BorderRadius.circular(_radius)),
                  child: Text('Create new',
                    style: TextStyle(
                      fontSize: _buttonTextFontSize,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Lato'
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _verticalInsets,
              ),
              ButtonTheme(
                minWidth: double.infinity,
                height: _buttonHeight,
                child: FlatButton(
                  onPressed: (){},
                  color: _buttonRestoreColor,
                  shape: RoundedRectangleBorder(side: BorderSide(color: _borderButtonRestoreColor), borderRadius: BorderRadius.circular(_radius)),
                  child: Text('Restore',
                    style: TextStyle(
                      fontSize: _buttonTextFontSize,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Lato'
                    ),
                  ),
                ),
              ),
            ],
          )
        )
      ],)
    );
  }
}

class SizedText extends StatelessWidget{

  final String _text;
  final double _heightContainer;
  Color _textColor;
  FontWeight _fontWeight;
  double _marginTop, _marginBottom;

  SizedText(this._text, this._heightContainer, {Color textColor = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    double marginTop = 0.0, double marginBottom = 0.0}){

    _textColor = textColor;
    _fontWeight = fontWeight;
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
          style: TextStyle(color: _textColor, fontWeight: _fontWeight, fontFamily: 'Lato'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}