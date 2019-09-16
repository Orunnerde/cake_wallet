import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';


class PinCode extends StatefulWidget {
  @override
  PinCodeState createState() => PinCodeState();
}

class PinCodeState<T extends StatefulWidget> extends State<T> {
  GlobalKey _gridViewKey = GlobalKey();

  static const defaultPinLength = 4;
  static const sixPinLength = 6;
  static const fourPinLength = 4;
  static final deleteIconImage = Image.asset('assets/images/delete_icon.png');
  static final backArrowImage = Image.asset('assets/images/back_arrow.png');

  int pinLength = defaultPinLength;
  List<int> pin = List<int>.filled(defaultPinLength, null);
  String title = 'Enter your pin';
  double _aspectRatio = 0;

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

  _getCurrentAspectRatio(){
    final RenderBox renderBox = _gridViewKey.currentContext.findRenderObject();

    double cellWidth = renderBox.size.width/3;
    double cellHeight = renderBox.size.height/4;
    if (cellWidth > 0 && cellHeight > 0) _aspectRatio = cellWidth/cellHeight;
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    _getCurrentAspectRatio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body(context));
  }

  Widget body(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 40.0),
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
                  child: Container(
                      key: _gridViewKey,
                      child: _aspectRatio > 0 ? GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: _aspectRatio,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(12, (index) {

                          if (index == 9) {
                            return Container(
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Palette.darkGrey,
                              ),
                            );
                          } else if (index == 10) {
                            index = 0;
                          } else if (index == 11) {
                            return Container(
                              margin: EdgeInsets.all(5.0),
                              child: FlatButton(
                                onPressed: () { _pop(); },
                                color: Palette.darkGrey,
                                shape: CircleBorder(),
                                child: deleteIconImage,
                              ),
                            );
                          } else {
                            index++;
                          }

                          return Container(
                            margin: EdgeInsets.all(5.0),
                            child: FlatButton(
                              onPressed: () { _push(index); },
                              color: Palette.creamyGrey,
                              shape: CircleBorder(),
                              child: Text(
                                  '$index',
                                  style: TextStyle(
                                      fontSize: 23.0,
                                      color: Palette.blueGrey
                                  )
                              ),
                            ),
                          );
                        }),
                      ) : null
                  )
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

  String _changePinLengthText() {
    return 'Use '
        + (pinLength == PinCodeState.fourPinLength ? '${PinCodeState.sixPinLength}' : '${PinCodeState.fourPinLength}')
        + '-digit Pin';
  }
}