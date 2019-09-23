import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';

// String fiatToString(FiatCurrency fiat) {
//   switch (fiat) {
//     case FiatCurrency.usd:
//       return 'USD';
//     case FiatCurrency.eur:
//       return 'EUR';
//     default:
//       return '';
//   }
// }

String cryptoToString(CryptoCurrency crypto) {
  switch (crypto) {
    case CryptoCurrency.xmr:
      return 'XMR';
    default:
      return '';
  }
}