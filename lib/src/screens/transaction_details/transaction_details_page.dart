import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';
import 'package:cake_wallet/src/screens/transaction_details/standart_list_item.dart';
import 'package:cake_wallet/src/screens/transaction_details/standart_list_row.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class TransactionDetailsPage extends BasePage {
  bool get isModalBackButton => true;
  String get title => 'Transaction details';
  
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy, HH:mm');
  final List<StandartListItem> _items = List<StandartListItem>();

  TransactionDetailsPage({TransactionInfo transactionInfo}) { 
    _items.addAll([
      StandartListItem(title: 'Transaction ID', value: transactionInfo.id),
      StandartListItem(
          title: 'Date', value: _dateFormat.format(transactionInfo.date)),
      StandartListItem(title: 'Height', value: transactionInfo.height),
      StandartListItem(title: 'Amount', value: transactionInfo.amount())
    ]);
  }

  @override
  Widget body(BuildContext context) => Container(
        padding: EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
        child: ListView.separated(
            separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: Color.fromRGBO(240, 241, 244, 1),
                ),
            padding: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 15),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];

              return StandartListRow(
                  title: '${item.title}:', value: item.value);
            }),
      );
}
