import 'package:cake_wallet/src/domain/exchange/exchange_provider_description.dart';

class TradeNotCreatedException implements Exception {
  ExchangeProviderDescription provider;
  String description;

  TradeNotCreatedException(this.provider, {this.description = ''});

  @override
  String toString() {
    var text = provider != null
        ? 'Trade for ${provider.title} is not created.'
        : 'Trade not created.';
    text += ' $description';

    return text;
  }
}
