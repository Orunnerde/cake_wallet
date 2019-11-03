import 'package:cake_wallet/src/domain/exchange/exchange_provider_description.dart';
import 'package:mobx/mobx.dart';

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
}
