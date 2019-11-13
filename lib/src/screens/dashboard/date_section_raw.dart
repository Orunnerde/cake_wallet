import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:intl/intl.dart';

class DateSectionRaw extends StatelessWidget {
  static final dateSectionDateFormat = DateFormat("d MMM");
  static final nowDate = DateTime.now();

  final DateTime date;

  DateSectionRaw({this.date});

  @override
  Widget build(BuildContext context) {
    final diffDays = date.difference(nowDate).inDays;
    var title = "";

    if (diffDays == 0) {
      title = "Today";
    } else if (diffDays == -1) {
      title = "Yesterday";
    } else if (diffDays > -7 && diffDays < 0) {
      final dateFormat = DateFormat("EEEE");
      title = dateFormat.format(date);
    } else {
      title = dateSectionDateFormat.format(date);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
          child: Text(title,
              style: TextStyle(fontSize: 16, color: Palette.wildDarkBlue))),
    );
  }
}
