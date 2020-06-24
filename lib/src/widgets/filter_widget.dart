import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/src/widgets/alert_background.dart';
import 'package:cake_wallet/src/widgets/alert_close_button.dart';

class FilterWidget extends StatelessWidget {
  FilterWidget({@required this.child, this.title = ''});

  final Widget child;
  final String title;
  final backVector = Image.asset('assets/images/back_vector.png');

  @override
  Widget build(BuildContext context) {
    return AlertBackground(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              title.isNotEmpty
              ? Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              )
              : Offstage(),
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: title.isNotEmpty ? 24 : 0
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  child: Container(
                    color: Theme.of(context).accentTextTheme.title.backgroundColor,
                    child: child ?? Container(),
                  ),
                ),
              ),
            ],
          ),
          AlertCloseButton(image: backVector)
        ],
      ),
    );
  }
}