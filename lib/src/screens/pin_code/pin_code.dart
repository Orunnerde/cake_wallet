import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';


class PinCode extends StatefulWidget {
  @override
  PinCodeState createState() => PinCodeState();
}

class PinCodeState<T extends StatefulWidget> extends State<T> {
  static const defaultButtonWidth = 79.0;
  static const defaultPinLength = 4;
  static const sixPinLength = 6;
  static const fourPinLength = 4;
  static final deleteIconImage = Image.asset('assets/images/delete_icon.png');
  static final backArrowImage = Image.asset('assets/images/back_arrow.png');

  int pinLength = defaultPinLength;
  List<int> pin = List<int>.filled(defaultPinLength, null);
  String title = 'Create PIN';
  double crossAxisSpacing;

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
    return (_currentWidth - 3*defaultButtonWidth)/4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body(context));
  }

  Widget body(BuildContext context) {
    crossAxisSpacing = getCurrentCrossAxisSpacing(context);
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            height: 37.0,
            margin: EdgeInsets.only(
              top: 5.0,
            ),
            padding: EdgeInsets.only(
                left: 17.0,
                right: 17.0
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                    left: 0.0,
                    child: Container(
                      width: 19.0,
                      height: 37.0,
                      child: InkWell(
                        onTap: (){ Navigator.pop(context); },
                        child: backArrowImage,
                      ),
                    )
                ),
                Container(
                  height: 37.0,
                  alignment: Alignment.center,
                  child: Text('Setup Pin', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: crossAxisSpacing, right: crossAxisSpacing),
              child: Column(
                  children: <Widget>[
                    Spacer(flex: 2),
                    Text(
                        title,
                        style: TextStyle(
                            fontSize: 24,
                            color: Palette.wildDarkBlue
                        )
                    ),
                    Spacer(flex: 3),
                    Container(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(pinLength, (index) {
                          const size = 10.0;
                          final isFilled = pin[index] != null;

                          return Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isFilled ? Palette.deepPurple : Colors.transparent,
                                  border: Border.all(color: Palette.wildDarkBlue),
                              ));
                        }),
                      ),
                    ),
                    Spacer(flex: 2),
                    FlatButton(
                      onPressed: (){ changePinLength(pinLength == PinCodeState.fourPinLength ? PinCodeState.sixPinLength : PinCodeState.fourPinLength); },
                      child: Text(_changePinLengthText(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Palette.wildDarkBlue
                        ),
                      )
                    ),
                    Spacer(flex: 1),
                    Flexible(
                      flex: 24,
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: crossAxisSpacing,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 40.0),
                        children: List.generate(12, (index) {
                          String buttonText = "";

                          if (index == 9) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Palette.darkGrey,
                              ),
                            );
                          } else if (index == 10) {
                            index = 0;
                            buttonText = "0";
                          } else if (index == 11) {
                            return ButtonTheme(
                              child: FlatButton(
                                onPressed: () { _pop(); },
                                color: Palette.darkGrey,
                                shape: CircleBorder(),
                                child: deleteIconImage,
                              ),
                            );
                          } else {
                            int i = ++index;
                            buttonText =  '$i';
                          }

                          return ButtonTheme(
                            child: FlatButton(
                              onPressed: () { _push(index); },
                              color: Palette.creamyGrey,
                              shape: CircleBorder(),
                              child: Text(
                                  '$buttonText',
                                  style: TextStyle(
                                      fontSize: 23.0,
                                      color: Palette.wildDarkBlue
                                  )
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  ]
              ),
            )
          )
        ],
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

  String _changePinLengthText() {
    return 'Use '
        + (pinLength == PinCodeState.fourPinLength ? '${PinCodeState.sixPinLength}' : '${PinCodeState.fourPinLength}')
        + '-digit Pin';
  }
}