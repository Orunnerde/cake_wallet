import 'package:flutter/material.dart';

class CloseButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final image = Image.asset('assets/images/close.png',
      color: Theme.of(context).primaryTextTheme.title.color,
      height: 20,
      width: 20,
    );

    /*return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle
        ),
        child: Center(
          child: image,
        ),
      ),
    );*/

    return SizedBox(
      height: 37,
      width: 37,
      child: ButtonTheme(
        minWidth: double.minPositive,
        child: FlatButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            padding: EdgeInsets.all(0),
            onPressed: () => Navigator.of(context).pop(),
            child: image),
      ),
    );
  }
}