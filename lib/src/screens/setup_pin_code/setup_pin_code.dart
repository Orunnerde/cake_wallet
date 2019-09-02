import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';

class SetupPinCode extends StatefulWidget {
  final Function(BuildContext) onPinCodeSetup;
  
  SetupPinCode(this.onPinCodeSetup);

  @override
  _SetupPinCodeState createState() => _SetupPinCodeState();
}

class _SetupPinCodeState<WidgetType extends SetupPinCode> extends PinCodeState<WidgetType> {
  bool isEnteredOriginalPin() => !(_originalPin.length == 0);
  Function(BuildContext) onPinCodeSetup;
  List<int> _originalPin = [];
  
  _SetupPinCodeState() {
    title = "Enter your pin";
  }

  @override
  void onPinCodeEntered(PinCodeState state) {
    if (!isEnteredOriginalPin()) {
      _originalPin = state.pin;
      state.title = 'Enter your pin again';
      state.clear();
    } else {

      if (listEquals<int>(state.pin, _originalPin)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Your PIN has been set up successfully!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onPinCodeSetup(context);
                    reset();
                  },
                ),
              ],
            );
          }
        );
      } else {
        showDialog(
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

        reset();
      }
    }
  }

  void reset() {
    clear();
    setTitle('Enter your pin');
    _originalPin = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body(context)
    );
  }

}
