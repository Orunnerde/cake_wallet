import 'package:flutter/material.dart';

class SettingsArrowListRow extends StatelessWidget {
  final VoidCallback onTaped;
  final String title;
  final _cakeArrowImage = Image.asset('assets/images/cake_arrow.png');

  SettingsArrowListRow({@required this.onTaped, this.title});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Theme.of(context).accentTextTheme.headline.backgroundColor,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).primaryTextTheme.title.color
          ),
        ),
        trailing: _cakeArrowImage,
        onTap: onTaped
      ),
    );
  }

}