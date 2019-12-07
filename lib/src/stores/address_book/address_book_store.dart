import 'package:cake_wallet/src/domain/common/contact.dart';
import 'package:cake_wallet/src/domain/services/address_book_service.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';

part 'address_book_store.g.dart';

class AddressBookStore = AddressBookStoreBase with _$AddressBookStore;

abstract class AddressBookStoreBase with Store {
  @observable
  List<Contact> contactList;

  @observable
  bool isValid;

  @observable
  String errorMessage;

  AddressBookService _addressBookService;

  AddressBookStoreBase({@required AddressBookService addressBookService}) {
    _addressBookService = addressBookService;
    updateContactList();
  }

  @action
  Future add({Contact contact}) async {
    await _addressBookService.add(contact: contact);
  }

  @action
  Future updateContactList() async {
    final contacts = await _addressBookService.getAll();
    contactList = contacts;
  }

  @action
  Future change({Contact contact}) async {
    await _addressBookService.change(contact: contact);
  }

  @action
  Future delete({Contact contact}) async {
    await _addressBookService.delete(contact: contact);
  }

  void validateContactName(String value) {
    String p = '''^[^`,'"]{1,32}\$''';
    RegExp regExp = new RegExp(p);
    isValid = regExp.hasMatch(value);
    errorMessage = isValid ? null : '''Contact name can't contain ` , ' " '''
                     'symbols\nand must be between 1 and 32 characters long';
  }

  void validateAddress(String value, {CryptoCurrency cryptoCurrency}) {
    // XMR (95), BTC (34), ETH (42), LTC (34), BCH (42), DASH (34)
    String p = '^[0-9a-zA-Z]{95}\$|^[0-9a-zA-Z]{34}\$|^[0-9a-zA-Z]{42}\$';
    RegExp regExp = new RegExp(p);
    isValid = regExp.hasMatch(value);
    if (isValid && cryptoCurrency != null) {
      switch (cryptoCurrency.toString()) {
        case 'XMR':
          isValid = (value.length == 95);
          break;
        case 'BTC':
          isValid = (value.length == 34);
          break;
        case 'ETH':
          isValid = (value.length == 42);
          break;
        case 'LTC':
          isValid = (value.length == 34);
          break;
        case 'BCH':
          isValid = (value.length == 42);
          break;
        case 'DASH':
          isValid = (value.length == 34);
      }
    }
    errorMessage = isValid ? null : 'Wallet address must correspond to the type\nof cryptocurrency';
  }
}
