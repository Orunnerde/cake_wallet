import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/exchange/trade_history.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/exchange/trade.dart';

part 'trade_history_store.g.dart';

class TradeHistoryStore = TradeHistoryStoreBase with _$TradeHistoryStore;

abstract class TradeHistoryStoreBase with Store {
  @observable
  List<Trade> tradeList;

  TradeHistory _tradeHistory;

  TradeHistoryStoreBase({@required TradeHistory tradeHistory}) {
    _tradeHistory = tradeHistory;
    updateTradeList();
  }

  @action
  Future updateTradeList() async {
    final trades = await _tradeHistory.all();
    tradeList = trades;
  }
}