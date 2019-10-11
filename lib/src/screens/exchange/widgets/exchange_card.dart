import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/widgets/picker.dart';
import 'package:cake_wallet/src/widgets/address_text_field.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/theme_changer.dart';

class ExchangeCard extends StatefulWidget {
  final List<CryptoCurrency> currencies;
  final Function(CryptoCurrency) onCurrencySelected;
  final CryptoCurrency initialCurrency;
  final String initialWalletName;
  final bool initialIsActive;
  final Image imageArrow;

  ExchangeCard(
      {Key key,
      this.initialCurrency,
      this.initialWalletName,
      this.initialIsActive,
      this.currencies,
      this.onCurrencySelected,
      this.imageArrow})
      : super(key: key);

  @override
  createState() => ExchangeCardState();
}

class ExchangeCardState extends State<ExchangeCard> {
  final addressController = TextEditingController();
  final amountController = TextEditingController();

  String _min;
  String _max;
  CryptoCurrency _selectedCurrency;
  String _walletName;
  bool _isActive;

  @override
  void initState() {
    _isActive = widget.initialIsActive;
    _walletName = widget.initialWalletName;
    _selectedCurrency = widget.initialCurrency;
    super.initState();
  }

  void changeLimits({String min, String max}) {
    setState(() {
      _min = min;
      _max = max;
    });
  }

  void changeSelectedCurrency(CryptoCurrency currency) {
    setState(() => _selectedCurrency = currency);
  }

  void changeWalletName(String walletName) {
    setState(() => _walletName = walletName);
  }

  void changeIsAction(bool isActive) {
    setState(() => _isActive = isActive);
  }

  void active() {
    setState(() => _isActive = true);
  }

  void disactive() {
    setState(() => _isActive = false);
  }

  void changeAddress({String address}) {
    setState(() => addressController.text = address);
  }

  void changeAmount({String amount}) {
    setState(() => amountController.text = amount);
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Container(
      padding: EdgeInsets.all(22),
      width: double.infinity,
      decoration: BoxDecoration(
          color: _isDarkTheme ? PaletteDark.darkThemeMidGrey : Palette.lavender,
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
                                Text(_selectedCurrency.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: _isDarkTheme ? PaletteDark.darkThemeTitle
                                            : Colors.black
                                    )),
                                widget.imageArrow
                              ]),
                          _walletName != null
                              ? Text(_walletName,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Palette.wildDarkBlue))
                              : SizedBox(),
                        ]),
                  ),
                ),
                SizedBox(width: 36),
                Flexible(
                  child: TextField(
                      style: TextStyle(fontSize: 23, height: 1.21),
                      controller: amountController,
                      enabled: _isActive,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: _isDarkTheme ? PaletteDark.darkThemeGrey
                                  : Palette.cadetBlue,
                              fontSize: 23,
                              height: 1.21),
                          hintText: '0.00000000',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                      : Palette.lightGrey,
                                  width: 1.0)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                      : Palette.lightGrey,
                                  width: 1.0)))),
                ),
              ]),
        ),
        SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          _min != null
              ? Text(
                  'Min: $_min ${_selectedCurrency.toString()}',
                  style: TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: _isDarkTheme ? PaletteDark.darkThemeGrey
                          : Palette.wildDarkBlue),
                )
              : SizedBox(),
          _min != null ? SizedBox(width: 10) : SizedBox(),
          _max != null
              ? Text('Max: $_max ${_selectedCurrency.toString()}',
                  style: TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: _isDarkTheme ? PaletteDark.darkThemeGrey
                          : Palette.wildDarkBlue))
              : SizedBox(),
        ]),
        SizedBox(height: 10),
        AddressTextField(controller: addressController)
      ]),
    );
  }

  void _presentPicker(BuildContext context) {
    showDialog(
        builder: (_) => Picker(
            items: widget.currencies,
            selectedAtIndex: widget.currencies.indexOf(_selectedCurrency),
            title: 'Change Currency',
            onItemSelected: (item) => widget.onCurrencySelected != null
                ? widget.onCurrencySelected(item)
                : null),
        context: context);
  }
}
