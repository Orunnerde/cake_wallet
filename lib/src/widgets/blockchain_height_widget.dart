import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/monero/get_height_by_date.dart';
import 'package:intl/intl.dart';

class BlockchainHeightWidget extends StatefulWidget {
  BlockchainHeightWidget({GlobalKey key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BlockchainHeightState();
}

class BlockchainHeightState extends State<BlockchainHeightWidget> {
  final dateController = TextEditingController();
  final restoreHeightController = TextEditingController();
  int get height => _height;
  int _height = 0;

  @override
  void initState() {
    restoreHeightController
        .addListener(() => _height = int.parse(restoreHeightController.text));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
                child: Container(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: TextFormField(
                controller: restoreHeightController,
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Palette.lightBlue),
                    hintText: 'Restore from blockheight',
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Palette.lightGrey, width: 2.0)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Palette.lightGrey, width: 2.0))),
              ),
            ))
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: Text(
            'or',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: <Widget>[
            Flexible(
                child: Container(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Palette.lightBlue),
                        hintText: 'Restore from date',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Palette.lightGrey, width: 2.0)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Palette.lightGrey, width: 2.0))),
                    controller: dateController,
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ),
            ))
          ],
        ),
      ],
    );
  }

  Future _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: now.subtract(Duration(days: 1)),
        firstDate: DateTime(2014, DateTime.april),
        lastDate: now);

    if (date != null) {
      final height = getHeigthByDate(date: date);

      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(date);
        restoreHeightController.text = '$height';
        _height = height;
      });
    }
  }
}
