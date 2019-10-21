import 'package:mobx/mobx.dart';

part 'validation_store.g.dart';

class ValidationStore = ValidationStoreBase with _$ValidationStore;

abstract class ValidationStoreBase with Store {

  @observable
  bool isValidate;

  void _validate(String value, String p) {
    RegExp regExp = new RegExp(p);
    if (regExp.hasMatch(value))
      isValidate = true;
    else
      isValidate = false;
  }

  @action
  void validateWalletName(String value) {
    String p = '^[a-zA-Z0-9_]{1,10}\$';
    _validate(value, p);
  }

  @action
  void validateKeys(String value) {
    String p = '^[a-fA-F0-9]{64}\$';
    _validate(value, p);
  }

  @action
  void validateAddress(String value) {
    String p = 'xmr|btc|eth|ltc|bch|dash';
    _validate(value, p);
  }

  @action
  void validatePaymentID(String value) {
    String p = '^[a-fA-F0-9]{16,64}\$';
    _validate(value, p);
  }

}