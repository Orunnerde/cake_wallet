import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';

class StandartSwitch extends StatefulWidget {

  final bool value;
  final VoidCallback onTaped;

  const StandartSwitch({
    @required this.value,
    @required this.onTaped});

  @override
  createState() => StandartSwitchState();

}

class StandartSwitchState extends State<StandartSwitch> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTaped,
      child: AnimatedContainer(
        padding: EdgeInsets.only(left: 4.0, right: 4.0),
        alignment: widget.value
            ? Alignment.centerRight
            : Alignment.centerLeft,
        duration: Duration(milliseconds: 250),
        width: 55.0,
        height: 33.0,
        decoration: BoxDecoration(
            color: Palette.switchBackground,
            border: Border.all(color: Palette.switchBorder),
            borderRadius:
            BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          width: 25.0,
          height: 25.0,
          decoration: BoxDecoration(
              color: widget.value
                  ? Palette.cakeGreen
                  : Palette.wildDarkBlue,
              borderRadius:
              BorderRadius.all(Radius.circular(8.0))),
          child: Icon(widget.value
                ? Icons.check
                : Icons.close,
            color: Colors.white,
            size: 16.0,
          ),
        ),
      ),
    );
  }

}