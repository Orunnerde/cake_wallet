import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/exchange/trade.dart';

part 'exchange_trade_store.g.dart';

class ExchangeTradeStore = ExchangeTradeStoreBase with _$ExchangeTradeStore;

abstract class ExchangeTradeStoreBase with Store {

  @observable
  Trade exchangeTrade;

  @action
  setTrade(Trade trade) {
    exchangeTrade = trade;
  }

}

