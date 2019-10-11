import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  static const _originalHeight = 44.0; // iOS nav bar height
  static const _height = 60.0;

  final Widget leading;
  final Widget middle;
  final Widget trailing;
  final Color backgroundColor;

  NavBar({this.leading, this.middle, this.trailing, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final pad = _height - _originalHeight;
    final paddingTop = pad / 2;
    final paddingBottom = pad / 2;

    return Container(
      color: backgroundColor,
      padding:
          EdgeInsetsDirectional.only(bottom: paddingBottom, top: paddingTop),
      child: CupertinoNavigationBar(
        leading: leading,
        middle: middle,
        trailing: trailing,
        backgroundColor: backgroundColor,
        border: null,
      ),
    );
  }

  @override
  bool get fullObstruction => false;

  @override
  Size get preferredSize {
    return new Size.fromHeight(_height);
  }
}
