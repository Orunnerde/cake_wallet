import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/stores/user/user_store.dart';
import 'package:cake_wallet/src/screens/pin_code/pin_code.dart';

class SetupPinCode extends PinCodeWidget {
  final Function(BuildContext, String) onPinCodeSetup;
  final bool hasLengthSwitcher = true;

  SetupPinCode({@required this.onPinCodeSetup});

  @override
  _SetupPinCodeState createState() => _SetupPinCodeState();
}

class _SetupPinCodeState<WidgetType extends SetupPinCode>
    extends PinCodeState<WidgetType> {
  static final backArrowImage = Image.asset('assets/images/back_arrow.png');

  bool isEnteredOriginalPin() => !(_originalPin.length == 0);
  Function(BuildContext) onPinCodeSetup;
  List<int> _originalPin = [];
  UserStore _userStore;

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
        final String pin = state.pin.fold("", (ac, val) => ac + '$val');
        _userStore.set(password: pin);

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
                      widget.onPinCodeSetup(context, pin);
                      reset();
                    },
                  ),
                ],
              );
            });
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
            });

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
    _userStore = Provider.of<UserStore>(context);

    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('Setup PIN'),
          backgroundColor: Colors.white,
          border: null,
        ),
        backgroundColor: Colors.white,
        body: body(context));
  }
}
