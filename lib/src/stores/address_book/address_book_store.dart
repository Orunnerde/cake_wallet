import 'package:cake_wallet/src/domain/common/contact.dart';
import 'package:cake_wallet/src/domain/services/address_book_service.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';

part 'address_book_store.g.dart';

class AddressBookStore = AddressBookStoreBase with _$AddressBookStore;

abstract class AddressBookStoreBase with Store {
  @observable
  List<Contact> contactList;

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
}
