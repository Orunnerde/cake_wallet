import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/fetch_price.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';

part 'price_store.g.dart';

class PriceStore = PriceStoreBase with _$PriceStore;

String calculateFiatAmount({double price, String cryptoAmount}) {
  if (price == null || cryptoAmount == null) {
    return '0.0';
  }

  final _amount = double.parse(cryptoAmount);
  final result = price * _amount;

  if (result == 0.0) {
    return '0.0';
  }

  return result > 0.01 ? result.toStringAsFixed(2) : '< 0.01';
}

String calculateFiatAmountRaw({double price, double cryptoAmount}) {
  if (price == null) {
    return '0.0';
  }

  final result = price * cryptoAmount;

  if (result == 0.0) {
    return '0.0';
  }

  return result > 0.01 ? result.toStringAsFixed(2) : '< 0.01';
}

abstract class PriceStoreBase with Store {
  static String generateSymbolForPair(
      {FiatCurrency fiat, CryptoCurrency crypto}) {
    return crypto.toString().toUpperCase() + fiat.toString().toUpperCase();
  }

  @observable
  ObservableMap<String, double> prices;

  PriceStoreBase() {
    prices = ObservableMap();
  }

  @action
  Future updatePrice({FiatCurrency fiat, CryptoCurrency crypto}) async {
    final symbol = generateSymbolForPair(fiat: fiat, crypto: crypto);
    final price = await fetchPriceFor(fiat: fiat, crypto: crypto);
    prices[symbol] = price;
  }
}
