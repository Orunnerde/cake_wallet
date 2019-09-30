import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/contact.dart';
import 'package:cake_wallet/src/stores/address_book/address_book_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:provider/provider.dart';

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
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please select:'),
            content: Container(
              height: 150.0,
              child: CupertinoPicker(
                  backgroundColor: Colors.white,
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

    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: EdgeInsets.all(38.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Palette.wildDarkBlue),
                              hintText: 'Contact Name',
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Palette.lightGrey, width: 2.0)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Palette.lightGrey, width: 2.0))),
                          controller: _contactNameController,
                          validator: (value) {
                            String p = '[^ ]';
                            RegExp regExp = new RegExp(p);
                            if (regExp.hasMatch(value))
                              return null;
                            else
                              return 'Please enter a contact name';
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: InkWell(
                          onTap: () => _setCurrencyType(context),
                          child: IgnorePointer(
                            child: TextFormField(
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.lightGrey,
                                          width: 2.0)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Palette.lightGrey,
                                          width: 2.0))),
                              controller: _currencyTypeController,
                              validator: (value) => null, // ??
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Palette.wildDarkBlue),
                              hintText: 'Address',
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Palette.lightGrey, width: 2.0)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Palette.lightGrey, width: 2.0))),
                          controller: _addressController,
                          validator: (value) => null, // ??
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
        Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Flexible(
                  child: Container(
                padding: EdgeInsets.only(right: 8.0),
                child: PrimaryButton(
                  onPressed: () {
                    setState(() {
                      _selectectCrypto = CryptoCurrency.xmr;
                      _contactNameController.text = '';
                      _currencyTypeController.text =
                          _selectectCrypto.toString();
                      _addressController.text = '';
                    });
                  },
                  text: 'Reset',
                  color: Palette.indigo,
                  borderColor: Palette.deepIndigo,
                ),
              )),
              Flexible(
                  child: Container(
                padding: EdgeInsets.only(left: 8.0),
                child: PrimaryButton(
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      try {
                        final contact = Contact(
                            name: _contactNameController.text,
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
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('OK'))
                                ],
                              );
                            });
                      }
                    },
                    text: 'Save'),
              )),
            ],
          ),
        )
      ],
    );
  }
}
