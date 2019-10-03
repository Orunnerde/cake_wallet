import 'package:flutter/material.dart';
import 'dart:async';

class TimerWidget extends StatefulWidget {

  final int exchangeTime;
  final Color color;

  TimerWidget(
    this.exchangeTime,
    {this.color = Colors.black}
  );

  @override
  createState() => TimerWidgetState(exchangeTime);

}

class TimerWidgetState extends State<TimerWidget> {

  int _exchangeTime;
  int _minutes;
  int _seconds;
  Timer _timer;

  TimerWidgetState(this._exchangeTime);

  void exchangeTimer() {
    if (_exchangeTime > 0) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _exchangeTime--;
        _minutes = _exchangeTime~/60;
        _seconds = _exchangeTime%60;
        setState(() {});
        if (_exchangeTime == 0) Navigator.pop(context);
      });
    } else Navigator.pop(context);
  }

  _afterLayout(_) {
    exchangeTimer();
  }

  @override
  void initState() {
    super.initState();
    _minutes = _exchangeTime~/60;
    _seconds = _exchangeTime%60;
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('${_minutes}m ${_seconds}s',
      style: TextStyle(
        fontSize: 14.0,
        color: widget.color
      ),
    );
  }

}