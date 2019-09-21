import 'dart:convert';
import 'package:http/http.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/currency_formatter.dart';

const coinMarketCapAuthority = 'api.coinmarketcap.com';
const coinMarketCapPath = '/v2/ticker/';
var _cachedPrices = {};

Future<double> fetchPriceFor({CryptoCurrency crypto, FiatCurrency fiat}) async {
  final fiatStringified = fiatToString(fiat);

  if (_cachedPrices[fiatStringified] != null) {
    return _cachedPrices[fiatStringified];
  }

  final uri = Uri.https(coinMarketCapAuthority, coinMarketCapPath,
      {'structure': 'array', 'convert': fiatStringified});

  final response = await get(uri.toString());

  if (response.statusCode != 200) {
    return 0;
  }

  final responseJSON = json.decode(response.body);
  final data = responseJSON['data'];
  double price;

  for (final item in data) {
    if (item['symbol'] == cryptoToString(crypto)) {
      price = item['quotes'][fiatStringified]['price'];
      _cachedPrices[fiatStringified] = price;
      break;
    }
  }

  return price;
}
