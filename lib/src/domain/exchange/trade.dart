import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/exchange/trade_state.dart';

class Trade {
  String id;
  CryptoCurrency from;
  CryptoCurrency to;
  TradeState state;
  DateTime expiredAt;
  String amount;
  String inputAddress;
  String extraId;
  String outputTransaction;
  String refundAddress;

  Trade(
      {this.id,
      this.from,
      this.to,
      this.state,
      this.expiredAt,
      this.amount,
      this.inputAddress,
      this.extraId,
      this.outputTransaction,
      this.refundAddress});
}
