import 'dart:async';
import 'package:cake_wallet/core/wallet_base.dart';
import 'package:cake_wallet/exchange/changenow/changenow_exchange_provider.dart';
import 'package:cake_wallet/exchange/exchange_provider.dart';
import 'package:cake_wallet/exchange/exchange_provider_description.dart';
import 'package:cake_wallet/exchange/morphtoken/morphtoken_exchange_provider.dart';
import 'package:cake_wallet/exchange/trade.dart';
import 'package:cake_wallet/exchange/xmrto/xmrto_exchange_provider.dart';
import 'package:cake_wallet/store/dashboard/trades_store.dart';
import 'package:cake_wallet/view_model/send/send_view_model.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/screens/exchange_trade/exchange_trade_item.dart';
import 'package:cake_wallet/generated/i18n.dart';

part 'exchange_trade_view_model.g.dart';

class ExchangeTradeViewModel = ExchangeTradeViewModelBase
    with _$ExchangeTradeViewModel;

abstract class ExchangeTradeViewModelBase with Store {
  ExchangeTradeViewModelBase(
      {this.wallet, this.trades, this.tradesStore, this.sendViewModel}) {
    trade = tradesStore.trade;

    isSendable = trade.from == wallet.currency ||
        trade.provider == ExchangeProviderDescription.xmrto;

    switch (trade.provider) {
      case ExchangeProviderDescription.xmrto:
        _provider = XMRTOExchangeProvider();
        break;
      case ExchangeProviderDescription.changeNow:
        _provider = ChangeNowExchangeProvider();
        break;
      case ExchangeProviderDescription.morphToken:
        _provider = MorphTokenExchangeProvider(trades: trades);
        break;
    }

    items = ObservableList<ExchangeTradeItem>();
    items.addAll([
      ExchangeTradeItem(
          title: S.current.id, data: '${trade.id}', isCopied: true),
      ExchangeTradeItem(
          title: S.current.amount, data: '${trade.amount}', isCopied: false),
      ExchangeTradeItem(
          title: S.current.status, data: '${trade.state}', isCopied: false),
      ExchangeTradeItem(
          title: S.current.widgets_address + ':',
          data: trade.inputAddress,
          isCopied: true),
    ]);

    _updateTrade();
    _timer = Timer.periodic(Duration(seconds: 20), (_) async => _updateTrade());
  }

  final WalletBase wallet;
  final Box<Trade> trades;
  final TradesStore tradesStore;
  final SendViewModel sendViewModel;

  @observable
  Trade trade;

  @observable
  bool isSendable;

  @observable
  ObservableList<ExchangeTradeItem> items;

  ExchangeProvider _provider;

  Timer _timer;

  @action
  Future confirmSending() async {
    if (!isSendable) {
      return;
    }

    sendViewModel.address = trade.inputAddress;
    sendViewModel.setCryptoAmount(trade.amount);
    await sendViewModel.createTransaction();
  }

  @action
  Future<void> _updateTrade() async {
    try {
      final updatedTrade = await _provider.findTradeById(id: trade.id);

      if (updatedTrade.createdAt == null && trade.createdAt != null) {
        updatedTrade.createdAt = trade.createdAt;
      }

      trade = updatedTrade;
    } catch (e) {
      print(e.toString());
    }
  }
}
