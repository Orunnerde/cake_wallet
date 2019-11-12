import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/contact.dart';
import 'package:cake_wallet/src/stores/address_book/address_book_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/widgets/address_text_field.dart';
import 'package:cake_wallet/src/widgets/scollable_with_bottom_section.dart';

class ContactPage extends BasePage {
  String get title => 'Contact';

  @override
  Widget body(BuildContext context) => ContactForm();
}

class ContactForm extends StatefulWidget {
  @override
  createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _contactNameController = TextEditingController();
  final _currencyTypeController = TextEditingController();
  final _addressController = TextEditingController();

  CryptoCurrency _selectectCrypto = CryptoCurrency.xmr;

  bool _isDarkTheme;

  @override
  void initState() {
    super.initState();
    _currencyTypeController.text = _selectectCrypto.toString();
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _currencyTypeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  _setCurrencyType(BuildContext context) async {
    _currencyTypeController.text =
        CryptoCurrency.all[0].toString();
    _selectectCrypto = CryptoCurrency.all[0];
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please select:'),
            backgroundColor:
                _isDarkTheme ? Theme.of(context).backgroundColor : Colors.white,
            content: Container(
              height: 150.0,
              child: CupertinoPicker(
                  backgroundColor: _isDarkTheme
                      ? Theme.of(context).backgroundColor
                      : Colors.white,
                  itemExtent: 45.0,
                  onSelectedItemChanged: (int index) {
                    _selectectCrypto = CryptoCurrency.all[index];
                    _currencyTypeController.text =
                        CryptoCurrency.all[index].toString();
                  },
                  children:
                      List.generate(CryptoCurrency.all.length, (int index) {
                    return Center(
                      child: Text(CryptoCurrency.all[index].toString()),
                    );
                  })),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final addressBookStore = Provider.of<AddressBookStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    return ScrollableWithBottomSection(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                style: TextStyle(
                    fontSize: 14.0,
                    color: _isDarkTheme
                        ? PaletteDark.darkThemeGrey
                        : Colors.black),
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: _isDarkTheme
                            ? PaletteDark.darkThemeGrey
                            : Palette.wildDarkBlue),
                    hintText: 'Contact Name',
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
                            width: 1.0))),
                controller: _contactNameController,
                validator: (value) {
                  addressBookStore.validateContactName(value);
                  return addressBookStore.errorMessage;
                },
              ),
              SizedBox(height: 14.0),
              Container(
                child: InkWell(
                  onTap: () => _setCurrencyType(context),
                  child: IgnorePointer(
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 14.0,
                          color: _isDarkTheme
                              ? PaletteDark.darkThemeGrey
                              : Colors.black),
                      decoration: InputDecoration(
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
                                  width: 1.0))),
                      controller: _currencyTypeController,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14.0),
              AddressTextField(
                  controller: _addressController,
                  options: [AddressTextFieldOption.qrCode],
                  validator: (value) {
                    addressBookStore.validateAddress(value, cryptoCurrency: _selectectCrypto);
                    return addressBookStore.errorMessage;
                  },
              )
            ],
          ),
        ),
        bottomSection: Row(
          children: <Widget>[
            Expanded(
              child: PrimaryButton(
                onPressed: () {
                  setState(() {
                    _selectectCrypto = CryptoCurrency.xmr;
                    _contactNameController.text = '';
                    _currencyTypeController.text = _selectectCrypto.toString();
                    _addressController.text = '';
                  });
                },
                text: 'Reset',
                color: _isDarkTheme
                    ? PaletteDark.darkThemeIndigoButton
                    : Palette.indigo,
                borderColor: _isDarkTheme
                    ? PaletteDark.darkThemeIndigoButtonBorder
                    : Palette.deepIndigo,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
                child: PrimaryButton(
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  return;
                }

                try {
                  final contact = Contact(
                      name: _contactNameController.text,
                      address: _addressController.text,
                      type: _selectectCrypto);

                  await addressBookStore.add(contact: contact);
                  Navigator.pop(context);
                } catch (e) {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            e.toString(),
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'))
                          ],
                        );
                      });
                }
              },
              text: 'Save',
              color: _isDarkTheme
                  ? PaletteDark.darkThemePurpleButton
                  : Palette.purple,
              borderColor: _isDarkTheme
                  ? PaletteDark.darkThemePurpleButtonBorder
                  : Palette.deepPink,
            ))
          ],
        ));
  }
}
