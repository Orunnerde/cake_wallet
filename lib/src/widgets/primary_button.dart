import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';

class PrimaryButton extends StatefulWidget{

  @required VoidCallback _onPressed;

  Color _color;
  Color _borderColor;
  String _text;

  PrimaryButton({@required VoidCallback onPressed, Color color = Palette.purple,
  Color borderColor = Palette.deepPink, String text = ''}){
    _onPressed = onPressed;
    _color = color;
    _borderColor = borderColor;
    _text = text;
  }

  @override
  createState() => _PrimaryButtonState();

}

class _PrimaryButtonState extends State<PrimaryButton>{

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 56.0,
      child: FlatButton(
        onPressed: widget._onPressed,
        color: widget._color,
        shape: RoundedRectangleBorder(side: BorderSide(color: widget._borderColor), borderRadius: BorderRadius.circular(10.0)),
        child: Text(widget._text, style: TextStyle(fontSize: 18.0)),
      ),
    );
  }

}