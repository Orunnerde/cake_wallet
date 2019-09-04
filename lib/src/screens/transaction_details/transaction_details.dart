import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/routes.dart';
import 'package:intl/intl.dart';

import 'package:cake_wallet/src/domain/common/transaction_info.dart';

class StandartListRow extends StatelessWidget {
  final String title;
  final String value;

  StandartListRow({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title,
                style: TextStyle(
                    fontSize: 14, color: const Color.fromRGBO(34, 40, 75, 1)),
                textAlign: TextAlign.left),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromRGBO(155, 172, 197, 1))),
            )
          ]),
    );
  }
}

class StandartListItem {
  final String title;
  final String value;

  StandartListItem({this.title, this.value});
}

class TransactionDetails extends StatelessWidget {
  static final dateFormat = DateFormat('dd.MM.yyyy, HH:mm');

  final List<StandartListItem> _items = List<StandartListItem>();

  TransactionDetails({TransactionInfo transactionInfo}) {
    _items.addAll([
      StandartListItem(title: 'Transaction ID', value: transactionInfo.id),
      StandartListItem(title: 'Date', value: dateFormat.format(transactionInfo.date)),
      StandartListItem(title: 'Height', value: transactionInfo.height),
      StandartListItem(title: 'Amount', value: transactionInfo.amount())
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: CupertinoNavigationBar(
          // leading: FlatButton(child: Text('done'), onPressed: () => Navigator.of(context).pop()),
          middle: Text('Transaction details',
              style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(34, 40, 75, 1),
                  fontFamily: 'Lato')),
          backgroundColor: Colors.white,
          border: null,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
          child: ListView.separated(
              separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: Color.fromRGBO(240, 241, 244, 1),
                  ),
              padding:
                  EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 15),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];

                return StandartListRow(
                    title: '${item.title}:', value: item.value);
              }),
        ));
  }
}
