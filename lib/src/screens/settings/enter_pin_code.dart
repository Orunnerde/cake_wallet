import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:flutter/foundation.dart';

class EnterPinCode extends StatefulWidget{

  final int currentPinLength;
  final List<int> currentPin;

  const EnterPinCode(this.currentPinLength, this.currentPin);

  @override
  createState() => EnterPinCodeState(currentPinLength, currentPin);

}

class EnterPinCodeState extends State<EnterPinCode>{
  GlobalKey _gridViewKey = GlobalKey();

  static final closeButtonImage = Image.asset('assets/images/close_button.png');
  static final deleteIconImage = Image.asset('assets/images/delete_icon.png');
  final int pinLength;
  final List<int> currentPin;
  List<int> pin;
  double _aspectRatio = 0;

  EnterPinCodeState(this.pinLength, this.currentPin);

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
    pin = List<int>.filled(pinLength, null);
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    _getCurrentAspectRatio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){ Navigator.pop(context, false); },
            child: closeButtonImage
          ),
        ),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 40.0),
          child: Column(
            children: <Widget>[
              Spacer(flex: 2),
              Text('Enter your pin',
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
              Spacer(flex: 3),
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
            ],
          ),
        )
      ),
    );
  }

  _showIncorrectPinDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("PIN is incorrect"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
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

      if (listEquals<int>(pin, currentPin)){

        Navigator.pop(context, true);

      } else {

        Navigator.pop(context, false);

        _showIncorrectPinDialog(context);

      }

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