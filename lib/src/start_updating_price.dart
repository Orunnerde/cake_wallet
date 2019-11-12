import 'dart:async';

import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/stores/price/price_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';

bool _startedUpdatingPrice = false;

void startUpdatingPrice({SettingsStore settingsStore, PriceStore priceStore}) {
  if (_startedUpdatingPrice) {
    return;
  }

  _startedUpdatingPrice = true;

  priceStore.updatePrice(
      fiat: settingsStore.fiatCurrency, crypto: CryptoCurrency.xmr);

  Timer.periodic(
      Duration(seconds: 30),
      (_) async => priceStore.updatePrice(
          fiat: settingsStore.fiatCurrency, crypto: CryptoCurrency.xmr));
}
