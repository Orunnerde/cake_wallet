import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_provider_description.dart';
import 'package:cake_wallet/src/domain/exchange/trade_state.dart';

class Trade {
  String id;
  ExchangeProviderDescription provider;
  CryptoCurrency from;
  CryptoCurrency to;
  TradeState state;
  DateTime createdAt;
  DateTime expiredAt;
  String amount;
  String inputAddress;
  String extraId;
  String outputTransaction;
  String refundAddress;

  static Trade fromMap(Map map) {
    return Trade(
        id: map['id'],
        provider: ExchangeProviderDescription.deserialize(raw: map['provider']),
        from: CryptoCurrency.deserialize(raw: map['input']),
        to: CryptoCurrency.deserialize(raw: map['output']),
        createdAt: map['date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['date'])
            : null,
        amount: map['amount']);
  }

  Trade(
      {this.id,
      this.provider,
      this.from,
      this.to,
      this.state,
      this.createdAt,
      this.expiredAt,
      this.amount,
      this.inputAddress,
      this.extraId,
      this.outputTransaction,
      this.refundAddress});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provider': provider.serialize(),
      'input': from.serialize(),
      'output': to.serialize(),
      'date': createdAt != null ? createdAt.millisecondsSinceEpoch : null,
      'amount': amount
    };
  }
}
