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
  final String initialAddress;
  final bool initialIsActive;
  final bool isAmountEstimated;
  final Image imageArrow;

  ExchangeCard(
      {Key key,
      this.initialCurrency,
      this.initialAddress,
      this.initialWalletName,
      this.initialIsActive,
      this.isAmountEstimated,
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
  bool _isAmountEstimated;

  @override
  void initState() {
    _isActive = widget.initialIsActive;
    _walletName = widget.initialWalletName;
    _selectedCurrency = widget.initialCurrency;
    _isAmountEstimated = widget.isAmountEstimated;
    changeAddress(address: widget.initialAddress);
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

  void changeIsAmountEstimated(bool isEstimated) {
    setState(() => _isAmountEstimated = isEstimated);
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme)
      _isDarkTheme = true;
    else
      _isDarkTheme = false;

    return Container(
      padding: EdgeInsets.fromLTRB(22, 30, 22, 30),
      width: double.infinity,
      decoration: BoxDecoration(
          color: _isDarkTheme ? PaletteDark.darkThemeMidGrey : Palette.lavender,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(children: <Widget>[
        Container(
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <
              Widget>[
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
                                    color: _isDarkTheme
                                        ? PaletteDark.darkThemeTitle
                                        : Colors.black)),
                            widget.imageArrow
                          ]),
                      _walletName != null
                          ? Text(_walletName,
                              style: TextStyle(
                                  fontSize: 12, color: Palette.wildDarkBlue))
                          : SizedBox(),
                    ]),
              ),
            ),
            SizedBox(width: 36),
            Flexible(
              child: Column(
                children: [
                  TextField(
                      style: TextStyle(fontSize: 23, height: 1.21),
                      controller: amountController,
                      enabled: _isActive,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      decoration: InputDecoration(
                          prefixIcon: _isAmountEstimated != null &&
                                  _isAmountEstimated
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        decoration: BoxDecoration(
                                            color: Palette.lightGrey,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Text(
                                          'Estimated',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Palette.wildDarkBlue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : null,
                          hintStyle: TextStyle(
                              color: _isDarkTheme
                                  ? PaletteDark.darkThemeGrey
                                  : Palette.cadetBlue,
                              fontSize: 23,
                              height: 1.21),
                          hintText: '0.00000000',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: _isDarkTheme
                                      ? PaletteDark.darkThemeGreyWithOpacity
                                      : Palette.lightGrey,
                                  width: 1.0)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: _isDarkTheme
                                      ? PaletteDark.darkThemeGreyWithOpacity
                                      : Palette.lightGrey,
                                  width: 1.0)))),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 15,
                    width: double.infinity,
                    child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _min != null
                                ? Text(
                                    'Min: $_min ${_selectedCurrency.toString()}',
                                    style: TextStyle(
                                        fontSize: 10,
                                        height: 1.2,
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeGrey
                                            : Palette.wildDarkBlue),
                                  )
                                : SizedBox(),
                            _min != null ? SizedBox(width: 10) : SizedBox(),
                            _max != null
                                ? Text(
                                    'Max: $_max ${_selectedCurrency.toString()}',
                                    style: TextStyle(
                                        fontSize: 10,
                                        height: 1.2,
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeGrey
                                            : Palette.wildDarkBlue))
                                : SizedBox(),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        SizedBox(height: 10),
        AddressTextField(
          controller: addressController,
          isActive: _isActive,
          options: _walletName != null
              ? [
                  AddressTextFieldOption.qrCode,
                  AddressTextFieldOption.addressBook,
                  AddressTextFieldOption.subaddressList
                ]
              : [
                  AddressTextFieldOption.qrCode,
                  AddressTextFieldOption.addressBook,
                ],
        )
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
