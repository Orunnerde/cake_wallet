import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/stores/user/user_store_state.dart';

part 'exchange_store.g.dart';

class ExchangePair {
  final CryptoCurrency from;
  final CryptoCurrency to;
  final bool reverse;

  ExchangePair({this.from, this.to, this.reverse = true});
}

abstract class TradeRequest {}

abstract class ExchangeProvider {
  String get title;
  List<ExchangePair> pairList;

  @override
  String toString() => title;

  Future<Limits> fetchLimits({CryptoCurrency from, CryptoCurrency to});
  Future createTrade({TradeRequest request});
}

class XMRTOTradeRequest extends TradeRequest {
  final CryptoCurrency from;
  final CryptoCurrency to;
  final String amount;
  final String address;

  XMRTOTradeRequest(
      {@required this.from,
      @required this.to,
      @required this.amount,
      @required this.address});
}

class XMRTOExchangeProvider extends ExchangeProvider {
  static const apiUri = 'https://xmr.to/api/v2/xmr2btc';

  String get title => 'XMR.TO';
  List<ExchangePair> pairList = [
    ExchangePair(
        from: CryptoCurrency.xmr, to: CryptoCurrency.btc, reverse: false)
  ];

  Future<Limits> fetchLimits({CryptoCurrency from, CryptoCurrency to}) async {
    final url = apiUri + '/order_parameter_query';
    final response = await get(url);

    if (response.statusCode != 200) {
      return Limits(min: 0, max: 0);
    }

    final responseJSON = json.decode(response.body);
    final double min = responseJSON['lower_limit'];
    final double max = responseJSON['upper_limit'];

    return Limits(min: min, max: max);
  }

  Future createTrade({TradeRequest request}) async {
    final _request = request as XMRTOTradeRequest;
    final url = apiUri + '/order_create/';
    final body = {
      'btc_amount': _request.amount,
      'btc_dest_address': _request.address
    };
    final response = await post(url,
        headers: {'Content-Type': 'application/json'}, body: json.encode(body));

    if (response.statusCode != 201) {
      if (response.statusCode == 400) {
        final responseJSON = json.decode(response.body);
        print(responseJSON);
        // error_msg field
        return;
      }
      return;
    }

    final responseJSON = json.decode(response.body);
    print(responseJSON);
    final uuid = responseJSON["uuid"];
    print('uuid $uuid');
  }
}

class ChangeNowRequest extends TradeRequest {
  ChangeNowRequest();
}

class ChangeNowExchangeProvider extends ExchangeProvider {
  static const apiUri = 'https://changenow.io/api/v1';
  String get title => 'ChangeNOW';

  ChangeNowExchangeProvider() {
    pairList = CryptoCurrency.all
        .map((i) {
          return CryptoCurrency.all.map((k) {
            if (i == CryptoCurrency.btc && k == CryptoCurrency.xmr) {
              return ExchangePair(from: i, to: k, reverse: false);
            }

            if (i == CryptoCurrency.xmr && k == CryptoCurrency.btc) {
              return null;
            }

            return ExchangePair(from: i, to: k, reverse: true);
          }).where((c) => c != null);
        })
        .expand((i) => i)
        .toList();
  }

  Future<Limits> fetchLimits({CryptoCurrency from, CryptoCurrency to}) async {
    final symbol = from.toString() + '_' + to.toString();
    final url = apiUri + '/min-amount/' + symbol;
    final response = await get(url);
    final responseJSON = json.decode(response.body);
    final double min = responseJSON['minAmount'];

    return Limits(min: min, max: null);
  }

  Future createTrade({TradeRequest request}) async {
// ChangeNowRequest
  }
}

abstract class LimitsState {}

class LimitsInitialState extends LimitsState {}

class LimitsIsLoading extends LimitsState {}

class LimitsLoadedSuccessfully extends LimitsState {
  final Limits limits;

  LimitsLoadedSuccessfully({@required this.limits});
}

class LimitsLoadedFailure extends LimitsState {
  final String error;

  LimitsLoadedFailure({@required this.error});
}

abstract class ExchangeTradeState {}

class ExchangeTradeStateInitial extends ExchangeTradeState {}

class TradeIsCreating extends ExchangeTradeState {}

class TradeIsCreatedSuccessfully extends ExchangeTradeState {}

class TradeIsCreatedFailure extends ExchangeTradeState {
  final String error;

  TradeIsCreatedFailure({@required this.error});
}

class Limits {
  final double min;
  final double max;

  const Limits({this.min, this.max});
}

class ExchangeStore = ExchangeStoreBase with _$ExchangeStore;

abstract class ExchangeStoreBase with Store {
  @observable
  ExchangeProvider provider;

  @observable
  List<ExchangeProvider> providerList;

  @observable
  CryptoCurrency depositCurrency;

  @observable
  CryptoCurrency receiveCurrency;

  @observable
  LimitsState limitsState;

  @observable
  ExchangeTradeState tradeState;

  String depositAddress;

  String depositAmount;

  String receiveAddress;

  String receiveAmount;

  ExchangeStoreBase(
      {@required ExchangeProvider initialProvider,
      @required CryptoCurrency initialDepositCurrency,
      @required CryptoCurrency initialReceiveCurrency,
      @required this.providerList}) {
    provider = initialProvider;
    depositCurrency = initialDepositCurrency;
    receiveCurrency = initialReceiveCurrency;
    limitsState = LimitsInitialState();
    tradeState = ExchangeTradeStateInitial();
  }

  @action
  void changeProvider({ExchangeProvider provider}) {
    this.provider = provider;
  }

  @action
  void changeDepositCurrency({CryptoCurrency currency}) {
    depositCurrency = currency;
    _onPairChange();
  }

  @action
  void changeReceiveCurrency({CryptoCurrency currency}) {
    receiveCurrency = currency;
    _onPairChange();
  }

  @action
  Future loadLimits() async {
    limitsState = LimitsIsLoading();

    try {
      final limits = await provider.fetchLimits(
          from: depositCurrency, to: receiveCurrency);
      limitsState = LimitsLoadedSuccessfully(limits: limits);
    } catch (e) {
      limitsState = LimitsLoadedFailure(error: e.toString());
    }
  }

  @action
  Future createTrade() async {
    TradeRequest request;

    if (provider is XMRTOExchangeProvider) {
      request = XMRTOTradeRequest(
          to: depositCurrency,
          from: receiveCurrency,
          amount: receiveAmount,
          address: receiveAddress);
    }

    try {
      tradeState = TradeIsCreating();
      await provider.createTrade(request: request);
      tradeState = TradeIsCreatedSuccessfully();
    } catch (e) {
      tradeState = TradeIsCreatedFailure(error: e.toString());
    }
  }

  void _onPairChange() {
    final isPairExist = provider.pairList
            .where((pair) =>
                pair.from == depositCurrency && pair.to == receiveCurrency)
            .length >
        0;

    if (!isPairExist) {
      final provider =
          _providerForPair(from: depositCurrency, to: receiveCurrency);

      if (provider != null) {
        this.provider = provider;
      }
    }

    loadLimits();
  }

  ExchangeProvider _providerForPair({CryptoCurrency from, CryptoCurrency to}) {
    final providers = providerList
        .where((provider) =>
            provider.pairList
                .where((pair) =>
                    pair.from == depositCurrency && pair.to == receiveCurrency)
                .length >
            0)
        .toList();

    return providers.length > 0 ? providers[0] : null;
  }
}
