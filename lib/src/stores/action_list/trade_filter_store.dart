import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_provider_description.dart';
import 'package:cake_wallet/src/stores/action_list/trade_list_item.dart';

part 'trade_filter_store.g.dart';

class TradeFilterStore = TradeFilterStoreBase with _$TradeFilterStore;

abstract class TradeFilterStoreBase with Store {
  @observable
  bool displayXMRTO;

  @observable
  bool displayChangeNow;

  TradeFilterStoreBase(
      {this.displayXMRTO = true, this.displayChangeNow = true});

  @action
  void toggleDisplayExchange(ExchangeProviderDescription provider) {
    switch (provider) {
      case ExchangeProviderDescription.changeNow:
        displayChangeNow = !displayChangeNow;
        break;
      case ExchangeProviderDescription.xmrto:
        displayXMRTO = !displayXMRTO;
        break;
    }
  }

  List<TradeListItem> filtered({List<TradeListItem> trades}) {
    List<TradeListItem> _trades = [];

    final needToFilter = !displayChangeNow || !displayXMRTO;

    if (needToFilter) {
      _trades = trades.where((item) {
        return (!displayXMRTO &&
                item.trade.provider != ExchangeProviderDescription.xmrto) ||
            (!displayChangeNow &&
                item.trade.provider != ExchangeProviderDescription.changeNow);
      }).toList();
    } else {
      _trades = trades;
    }

    return _trades;
  }
}
