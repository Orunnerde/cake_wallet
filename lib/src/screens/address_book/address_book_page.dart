import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/stores/address_book/address_book_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class AddressBookPage extends BasePage {
  bool get isModalBackButton => true;
  String get title => 'Address Book';
  final bool isEditable;

  AddressBookPage({this.isEditable = true});

  @override
  Widget trailing(BuildContext context) {
    if (!isEditable) {
      return null;
    }

    final addressBookStore = Provider.of<AddressBookStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme)
      _isDarkTheme = true;
    else
      _isDarkTheme = false;

    return Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isDarkTheme ? PaletteDark.darkThemeViolet : Palette.purple),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(Icons.add, color: Palette.violet, size: 22.0),
            ButtonTheme(
              minWidth: 28.0,
              height: 28.0,
              child: FlatButton(
                  shape: CircleBorder(),
                  onPressed: () async {
                    await Navigator.of(context)
                        .pushNamed(Routes.addressBookAddContact);
                    await addressBookStore.updateContactList();
                  },
                  child: Offstage()),
            )
          ],
        ));
  }

  @override
  Widget body(BuildContext context) {
    final addressBookStore = Provider.of<AddressBookStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme)
      _isDarkTheme = true;
    else
      _isDarkTheme = false;

    return Column(
      children: <Widget>[
        SizedBox(height: 10.0),
        Expanded(
            child: Stack(
          children: <Widget>[
            _isDarkTheme
                ? Container(
                    height: 10.0,
                  )
                : Container(
                    height: 10.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [Palette.lightGrey2, Colors.white],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 1.0),
                    )),
                  ),
            Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Observer(
                  builder: (_) => ListView.separated(
                      separatorBuilder: (_, __) => Divider(
                            color: _isDarkTheme
                                ? PaletteDark.darkThemeGreyWithOpacity
                                : Palette.lightGrey,
                            height: 1.0,
                          ),
                      itemCount: addressBookStore.contactList == null
                          ? 0
                          : addressBookStore.contactList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final contact = addressBookStore.contactList[index];

                        return InkWell(
                          onTap: () => !isEditable
                              ? Navigator.of(context).pop(contact)
                              : null,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Container(
                                    height: 25.0,
                                    width: 48.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _getCurrencyBackgroundColor(
                                          contact.type),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Text(
                                      contact.type.toString(),
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color:
                                            _getCurrencyTextColor(contact.type),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    contact.name,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeTitle
                                            : Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ))
          ],
        ))
      ],
    );
  }

  Color _getCurrencyBackgroundColor(CryptoCurrency currency) {
    Color color;
    switch (currency) {
      case CryptoCurrency.xmr:
        color = Palette.cakeGreenWithOpacity;
        break;
      case CryptoCurrency.btc:
        color = Colors.orange;
        break;
      case CryptoCurrency.eth:
        color = Colors.black;
        break;
      case CryptoCurrency.ltc:
        color = Colors.blue[200];
        break;
      case CryptoCurrency.bch:
        color = Colors.orangeAccent;
        break;
      case CryptoCurrency.dash:
        color = Colors.blue;
        break;
      default:
        color = Colors.white;
    }
    return color;
  }

  Color _getCurrencyTextColor(CryptoCurrency currency) {
    Color color;
    switch (currency) {
      case CryptoCurrency.xmr:
        color = Palette.cakeGreen;
        break;
      case CryptoCurrency.ltc:
        color = Palette.lightBlue;
        break;
      default:
        color = Colors.white;
    }
    return color;
  }
}
