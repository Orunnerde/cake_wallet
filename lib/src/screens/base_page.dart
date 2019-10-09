import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/src/widgets/nav_bar.dart';

abstract class BasePage extends StatelessWidget {
  String get title => null;
  bool get isModalBackButton => false;

  Color get backgroundColor => Colors.white;

  final _backArrowImage = Image.asset('assets/images/back_arrow.png');
  final _closeButtonImage = Image.asset('assets/images/close_button.png');

  Widget leading(BuildContext context) {
    if (ModalRoute.of(context).isFirst) {
      return null;
    }

    return SizedBox(
      height: 37,
      width: isModalBackButton ? 37 : 10,
      child: ButtonTheme(
        minWidth: double.minPositive,
        child: FlatButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            padding: EdgeInsets.all(0),
            onPressed: () => Navigator.of(context).pop(),
            child: isModalBackButton ? _closeButtonImage : _backArrowImage),
      ),
    );
  }

  Widget middle(BuildContext context) => title == null
      ? null
      : Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16.0,
              height: 1.2,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lato',
              color: Colors.black),
        );

  Widget trailing(BuildContext context) => null;

  Widget body(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomPadding: false,
        appBar: NavBar(
            leading: leading(context),
            middle: middle(context),
            trailing: trailing(context),
            backgroundColor: backgroundColor),
        body: SafeArea(child: body(context)));
  }
}
