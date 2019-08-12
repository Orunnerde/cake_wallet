import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Welcome image

    var _image = new Image(image: AssetImage('assets/images/welcomeImg.png'));

    // Default screen parameters for Pixel 2

    const double _defaultHeight = 683.43;
    const double _defaultWidth = 411.43;

    // Default font sizes

    const double _defaultFontText1 = 30.0;
    const double _defaultFontText2 = 25.0;
    const double _defaultFontText3 = 16.0;

    // Insets and radius

    const double _horizontalInsets = 30.0;
    const double _verticalInsets = 10.0;
    const double _radius = 10.0;

    // Defining of screen height and width

    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;

    // Aspects of image

    double _aspectRatioImage = 375.0/297.0;

    // Weights

    double _weightOfInset1 = 0.1;
    double _weightOfInset2 = 0.2;
    double _weightOfInset3 = 0.4;

    // Defining scale factor

    double _scaleFactor = _screenWidth/_defaultWidth;
    _scaleFactor = (_scaleFactor < (_screenHeight/_defaultHeight))? _scaleFactor:(_screenHeight/_defaultHeight);

    // Heights of widgets

    double _buttonHeight = 56.0;
    double _buttonTextFontSize = 18.0;

    _screenHeight = _screenHeight - (_screenWidth/_aspectRatioImage + 2*_buttonHeight + _verticalInsets +
    _scaleFactor*2.5*(_defaultFontText1 + _defaultFontText2 + _defaultFontText3));

    double _sizedBox1Height = _weightOfInset1*_screenHeight;
    double _sizedBox2Height = _weightOfInset2*_screenHeight;
    double _sizedBox3Height = _weightOfInset3*_screenHeight;

    // Colors of widgets

    Color _textColor = Color.fromARGB(255, 126, 147, 177);
    Color _buttonCreateColor = Colors.purple[50];
    Color _borderButtonCreateColor = Colors.deepPurple[100];
    Color _buttonRestoreColor = Colors.indigo[50];
    Color _borderButtonRestoreColor = Colors.indigo[100];

    return Scaffold(
      body: Column(children: <Widget>[
        AspectRatio(
          aspectRatio: _aspectRatioImage,
          child: Container(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.contain,
              child: _image,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: _horizontalInsets,
            right: _horizontalInsets,
          ),
          child: Column(
            children: <Widget>[
              Text('WELCOME\nTO CAKE WALLET',
                style: TextStyle(
                  fontSize: _defaultFontText1,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato'
                ),
                textAlign: TextAlign.center,
                textScaleFactor: _scaleFactor,
              ),
              SizedBox(
                height: _sizedBox1Height,
              ),
              Text('Awesome wallet\nfor Monero',
                style: TextStyle(
                    fontSize: _defaultFontText2,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                    fontFamily: 'Lato'
                ),
                textAlign: TextAlign.center,
                textScaleFactor: _scaleFactor,
              ),
              SizedBox(
                height: _sizedBox2Height,
              ),
              Text('Please make a selection below to either create\na new wallet or restore a wallet',
                style: TextStyle(
                    fontSize: _defaultFontText3,
                    color: _textColor,
                    fontFamily: 'Lato'
                ),
                textAlign: TextAlign.center,
                textScaleFactor: _scaleFactor,
              ),
              SizedBox(
                height: _sizedBox3Height,
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