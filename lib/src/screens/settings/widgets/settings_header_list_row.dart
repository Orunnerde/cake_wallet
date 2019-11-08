import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';

class SettingsHeaderListRow extends StatelessWidget {
  final String title;

  SettingsHeaderListRow({this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 28.0,
        ),
        Container(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15.0, color: Palette.wildDarkBlue),
              )
            ],
          ),
        ),
        SizedBox(
          height: 14.0,
        ),
      ],
    );
  }

}