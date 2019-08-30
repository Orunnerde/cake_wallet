import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';


class PinCode extends StatefulWidget {
  @override
  PinCodeState createState() => PinCodeState();
}

class PinCodeState<T extends StatefulWidget> extends State<T> {
  static const baseWidth = 411.43;
  static const baseHeight = 683.43;
  static const baseCrossAxisSpacing = 35;
  static const defaultPinLength = 4;
  static const sixPinLength = 6;
  static const fourPinLength = 4;
  static final deleteIconImage = Image.asset('assets/images/delete_icon.png');

  int pinLength = defaultPinLength;
  List<int> pin = List<int>.filled(defaultPinLength, null);
  String title = 'Create PIN';

  void setTitle(String title) {
    setState(() => this.title = title);
  }

  void clear() {
    setState(() => pin = List<int>.filled(pinLength, null));
  }

  void onPinCodeEntered(PinCodeState state) {}

  void changePinLength(int length) {
    List<int> newPin = List<int>.filled(length, null);

    setState(() {
      pinLength = length;
      pin = newPin;
    });
  }

  double getCurrentCrossAxisSpacing(BuildContext context){

    double _currentWidth = MediaQuery.of(context).size.width;
    double _currentHeight = MediaQuery.of(context).size.height;

    double _baseAspectRatio = baseWidth/baseHeight;
    double _currentAspectRatio = _currentWidth/_currentHeight;

    double _currentCrossAxisSpacing = _currentWidth*baseCrossAxisSpacing/baseWidth;

    return _currentAspectRatio > _baseAspectRatio ? 2*_currentCrossAxisSpacing : _currentCrossAxisSpacing;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body(context));
  }

  Widget body(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 35, right: 35),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Spacer(flex: 1),
              Text(
                  title,
                  style: TextStyle(
                      fontSize: 24,
                      color: Palette.wildDarkBlue
                  )
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                width: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(pinLength, (index) {
                    const size = 14.0;
                    const radius = size / 2;
                    final isFilled = pin[index] != null;

                    return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                            color: isFilled ? Palette.deepPurple : Colors.transparent,
                            border: Border.all(color: Palette.wildDarkBlue),
                            borderRadius: BorderRadius.circular(radius)));
                  }),
                ),
              ),
              Spacer(flex: 2),
              Flexible(
                flex: 8,
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: getCurrentCrossAxisSpacing(context),
                  mainAxisSpacing: 8.0,
                  //childAspectRatio: 1.0,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40.0),
                  children: List.generate(12, (index) {
                    String buttonText = "";

                    if (index == 9) {
                      return Container();
                    } else if (index == 10) {
                      index = 0;
                      buttonText = "0";
                    } else if (index == 11) {
                      return ButtonTheme(
                        minWidth: 15.0,
                        height: 15.0,
                        child: FlatButton(
                          onPressed: () { _pop(); },
                          color: Colors.transparent,
                          shape: CircleBorder(),
                          child: deleteIconImage,
                        ),
                      );
                    } else {
                      int i = ++index;
                      buttonText =  '$i';
                    }

                    return Container(
                      padding: EdgeInsets.all(5),
                      child: ButtonTheme(
                        child: FlatButton(
                          onPressed: () { _push(index); },
                          color: Palette.creamyGrey,
                          shape: CircleBorder(),
                          child: Text(
                              '$buttonText',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Palette.wildDarkBlue
                              )
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )
            ]
        ),
      )
    );
  }

  void _push(int num) {
    if (_pinLength() >= pinLength) {
      return;
    }

    for (var i = 0; i < pin.length; i++) {
      if (pin[i] == null) {
        setState(() => pin[i] = num);
        break;
      }
    }

    if (_pinLength() == pinLength) {
      onPinCodeEntered(this);
    }
  }

  void _pop() {
    if (_pinLength() == 0) {
      return;
    }

    for (var i = pin.length - 1; i >= 0; i--) {
      if (pin[i] != null) {
        setState(()  => pin[i] = null);
        break;
      }
    }
  }

  int _pinLength() {
    return pin.fold(0, (v, e) {
      if (e != null) {
        return v + 1;
      }

      return v;
    });
  }
}