import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';

class PrimaryButton extends StatelessWidget {

  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;
  final String text;

  const PrimaryButton({
    @required this.onPressed,
    @required this.text,
    this.color = Palette.purple,
    this.borderColor = Palette.deepPink});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 56.0,
      child: FlatButton(
        onPressed: onPressed,
        color:color,
        shape: RoundedRectangleBorder(side: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(10.0)),
        child: Text(text, style: TextStyle(fontSize: 18.0)),
      )
    );
  }
}

class LoadingPrimaryButton extends StatelessWidget {

  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;
  final bool isLoading;
  final String text;

  const LoadingPrimaryButton({
    @required this.onPressed,
    @required this.text,
    this.color = Palette.purple,
    this.borderColor = Palette.deepPink,
    this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 56.0,
      child: FlatButton(
        onPressed: onPressed,
        color: color,
        shape: RoundedRectangleBorder(side: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(10.0)),
        child: isLoading ? CupertinoActivityIndicator(animating: true) : Text(text, style: TextStyle(fontSize: 18.0)),
      )
    );
  }
}

class PrimaryIconButton extends StatelessWidget {

  final VoidCallback onPressed;
  final Widget widget;
  final Color color;
  final Color borderColor;
  final String text;

  const PrimaryIconButton({
    @required this.onPressed,
    @required this.widget,
    @required this.text,
    this.color = Palette.purple,
    this.borderColor = Palette.deepPink});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: double.infinity,
        height: 56.0,
        child: FlatButton(
          onPressed: onPressed,
          color:color,
          shape: RoundedRectangleBorder(side: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget,
              Text(text, style: TextStyle(fontSize: 18.0))
            ],
          ),
        )
    );
  }
}