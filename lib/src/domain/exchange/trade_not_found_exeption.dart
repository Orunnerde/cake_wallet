import 'package:cake_wallet/src/domain/exchange/exchange_provider_description.dart';

class TradeNotFoundException implements Exception {
  String tradeId;
  ExchangeProviderDescription provider;
  String description;

  TradeNotFoundException(this.tradeId, {this.provider, this.description = ''});

  @override
  String toString() {
    var text = tradeId != null && provider != null
        ? 'Trade $tradeId of ${provider.title} not found.'
        : 'Trade not found.';
    text += ' $description';

    return text;
  }
}
