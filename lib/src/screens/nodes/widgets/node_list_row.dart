import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NodeListRow extends StatelessWidget {
  NodeListRow({
    @required this.title,
    @required this.trailing,
    @required this.color,
    @required this.textColor,
    @required this.onTap,
    @required this.isDrawTop,
    @required this.isDrawBottom});

  final String title;
  final Widget trailing;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final bool isDrawTop;
  final bool isDrawBottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isDrawTop
        ? Container(
          width: double.infinity,
          height: 1,
          color: Theme.of(context).dividerColor,
        )
        : Offstage(),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 56,
            color: color,
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor
                  ),
                  textAlign: TextAlign.left
                ),
                trailing
              ],
            )
          ),
        ),
        isDrawBottom
        ? Container(
          width: double.infinity,
          height: 1,
          color: Theme.of(context).dividerColor,
        )
        : Offstage(),
      ],
    );
  }
}
