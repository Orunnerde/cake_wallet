import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/domain/common/transaction_info.dart';
import 'package:cake_wallet/src/domain/common/recipient_address_list.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/screens/transaction_details/standart_list_item.dart';
import 'package:cake_wallet/src/screens/transaction_details/standart_list_row.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class TransactionDetailsPage extends BasePage {
  bool get isModalBackButton => true;
  String get title => 'Transaction Details';

  final TransactionInfo transactionInfo;

  TransactionDetailsPage({this.transactionInfo});

  @override
  Widget body(BuildContext context) {
    final recipientAddressList = Provider.of<RecipientAddressList>(context);
    final settingsStore = Provider.of<SettingsStore>(context);

    return TransactionDetailsForm(
        transactionInfo: transactionInfo,
        recipientAddressList: recipientAddressList,
        settingsStore: settingsStore);
  }
}

class TransactionDetailsForm extends StatefulWidget {
  final TransactionInfo transactionInfo;
  final RecipientAddressList recipientAddressList;
  final SettingsStore settingsStore;

  TransactionDetailsForm(
      {@required this.transactionInfo,
      @required this.recipientAddressList,
      @required this.settingsStore});

  @override
  createState() => TransactionDetailsFormState();
}

class TransactionDetailsFormState extends State<TransactionDetailsForm> {
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy, HH:mm');
  List<StandartListItem> _items = List<StandartListItem>();

  @override
  void initState() {
    _items.addAll([
      StandartListItem(
          title: 'Transaction ID', value: widget.transactionInfo.id),
      StandartListItem(
          title: 'Date',
          value: _dateFormat.format(widget.transactionInfo.date)),
      StandartListItem(title: 'Height', value: '${widget.transactionInfo.height}'),
      StandartListItem(title: 'Amount', value: widget.transactionInfo.amountFormatted())
    ]);

    if (widget.settingsStore.shouldSaveRecipientAddress) {
      widget.recipientAddressList
          .findRecipientAddress(transactionsId: widget.transactionInfo.id)
          .then((address) {
        if (address == null) {
          return;
        }

        _addRecipientAddress(address: address);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
      child: ListView.separated(
          separatorBuilder: (context, index) => Container(
                height: 1,
                color: Theme.of(context).dividerTheme.color,
              ),
          padding: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 15),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];

            return GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: item.value));
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.title} copied to Clipboard'),
                    backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 1500),
                  ),
                );
              },
              child: StandartListRow(title: '${item.title}:', value: item.value),
            );
          }),
    );
  }

  void _addRecipientAddress({String address}) {
    setState(() => _items
        .add(StandartListItem(title: 'Recipient address', value: address)));
  }
}
