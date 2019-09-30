import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/widgets/picker.dart';
import 'package:cake_wallet/src/widgets/address_text_field.dart';

class ExchangeCard extends StatefulWidget {
  final TextEditingController addressController;
  final TextEditingController amountController;
  final CryptoCurrency selectedCurrency;
  final String walletName;
  final String min;
  final String max;
  final bool isActive;
  final List<CryptoCurrency> currencies;
  final Function(CryptoCurrency) onCurrencySelected;

  ExchangeCard(
      {@required this.selectedCurrency,
      @required this.walletName,
      @required this.min,
      @required this.max,
      this.isActive = true,
      this.currencies,
      this.onCurrencySelected,
      this.addressController,
      this.amountController});

  @override
  createState() => ExchangeCardState();
}

class ExchangeCardState extends State<ExchangeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color.fromRGBO(249, 250, 253, 1),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(children: <Widget>[
        Container(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 52,
                  width: 70,
                  child: InkWell(
                    onTap: () => _presentPicker(context),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(widget.selectedCurrency.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                Image.asset(
                                  'assets/images/arrow_bottom_purple_icon.png',
                                  height: 8,
                                )
                              ]),
                          widget.walletName != null
                              ? Text(widget.walletName,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(155, 172, 197, 1)))
                              : SizedBox(),
                        ]),
                  ),
                ),
                SizedBox(width: 36),
                Flexible(
                  child: TextField(
                      controller: widget.amountController,
                      enabled: widget.isActive,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(191, 201, 215, 1),
                              fontSize: 23,
                              height: 1.21),
                          hintText: '0.00000000',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Palette.lightGrey, width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: widget.isActive
                                      ? Palette.deepPurple
                                      : Palette.lightGrey,
                                  width: 2.0)))),
                ),
              ]),
        ),
        SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          widget.min != null
              ? Text(
                  'Min: ${widget.min} ${widget.selectedCurrency.toString()}',
                  style: TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: Color.fromRGBO(155, 172, 197, 1)),
                )
              : SizedBox(),
          widget.min != null ? SizedBox(width: 10) : SizedBox(),
          widget.max != null
              ? Text('Max: ${widget.max} ${widget.selectedCurrency.toString()}',
                  style: TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: Color.fromRGBO(155, 172, 197, 1)))
              : SizedBox(),
        ]),
        SizedBox(height: 10),
        AddressTextField(controller: widget.addressController)
      ]),
    );
  }

  void _presentPicker(BuildContext context) {
    showDialog(
        builder: (_) => Picker(
            items: widget.currencies,
            selectedAtIndex: widget.currencies.indexOf(widget.selectedCurrency),
            title: 'Change Currency',
            onItemSelected: (item) => widget.onCurrencySelected != null
                ? widget.onCurrencySelected(item)
                : null),
        context: context);
  }
}
