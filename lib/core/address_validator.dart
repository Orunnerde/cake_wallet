import 'package:flutter/foundation.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/core/validator.dart';
import 'package:cake_wallet/entities/crypto_currency.dart';

class AddressValidator extends TextValidator {
  AddressValidator({@required CryptoCurrency type})
      : super(
            errorMessage: S.current.error_text_address,
            pattern: getPattern(type),
            length: getLength(type));

  static String getPattern(CryptoCurrency type) {
    switch (type) {
      case CryptoCurrency.xmr:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.ada:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.bch:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.bnb:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.btc:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.dai:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.dash:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.eos:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.eth:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.ltc:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.nano:
        return '[0-9a-zA-Z_]';
      case CryptoCurrency.trx:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.usdt:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.usdterc20:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.xlm:
        return '[0-9a-zA-Z]';
      case CryptoCurrency.xrp:
        return '[0-9a-zA-Z]';
      default:
        return '[0-9a-zA-Z]';
    }
  }

  static List<int> getLength(CryptoCurrency type) {
    switch (type) {
      case CryptoCurrency.xmr:
        return [95, 106];
      case CryptoCurrency.ada:
        return [59, 92, 105];
      case CryptoCurrency.bch:
        return [42];
      case CryptoCurrency.bnb:
        return [42];
      case CryptoCurrency.btc:
        return [33, 34, 42];
      case CryptoCurrency.dai:
        return [42];
      case CryptoCurrency.dash:
        return [34];
      case CryptoCurrency.eos:
        return [42];
      case CryptoCurrency.eth:
        return [42];
      case CryptoCurrency.ltc:
        return [34];
      case CryptoCurrency.nano:
        return [64, 65];
      case CryptoCurrency.trx:
        return [34];
      case CryptoCurrency.usdt:
        return [42];
      case CryptoCurrency.usdterc20:
        return [42];
      case CryptoCurrency.xlm:
        return [56];
      case CryptoCurrency.xrp:
        return [34];
      default:
        return [];
    }
  }
}
