import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_pair.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_provider.dart';
import 'package:cake_wallet/src/domain/exchange/limits.dart';
import 'package:cake_wallet/src/domain/exchange/trade.dart';
import 'package:cake_wallet/src/domain/exchange/trade_request.dart';
import 'package:cake_wallet/src/domain/exchange/trade_state.dart';
import 'package:cake_wallet/src/domain/exchange/changenow/changenow_request.dart';

class ChangeNowExchangeProvider extends ExchangeProvider {
  static const apiUri = 'https://changenow.io/api/v1';
  static const apiKey = '';
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

  Future<Trade> createTrade({TradeRequest request}) async {
    const url = apiUri + '/transactions/' + apiKey;
    final _request = request as ChangeNowRequest;
    final body = {
      'from': _request.from.toString(),
      'to': _request.to.toString(),
      'address': _request.address,
      'refundAddress': _request.refundAddress
    };

    final response = await post(url,
        headers: {'Content-Type': 'application/json'}, body: json.encode(body));

    // if (response.statusCode != 200) {
    //   // Throw error
    //   json["error"].string {
    //                     if error == "cannot_create_transction" {
    //                         o.onError(ExchangerError.tradeNotCreated)
    //                     } else {
    //                         o.onError(ExchangerError.notCreated(error))
    //                     }
    //   return null;
    // }

    final responseJSON = json.decode(response.body);

    return Trade(
        id: responseJSON['id'],
        from: _request.from,
        to: _request.to,
        inputAddress: responseJSON['payinAddress'],
        refundAddress: responseJSON['refundAddress'],
        extraId: responseJSON["payinExtraId"],
        amount: _request.amount,
        state: TradeState.created);
  }

  Future<Trade> findTradeById({@required String id}) async {
    final url = apiUri + '/transactions/' + id + '/' + apiKey;
    final response = await get(url);
    final responseJSON = json.decode(response.body);

    return Trade(
        id: id,
        from: CryptoCurrency.fromString(responseJSON['from']),
        to: CryptoCurrency.fromString(responseJSON['to']),
        inputAddress: responseJSON['payinAddress'],
        amount: responseJSON['amountSend'],
        state: TradeState.deserialize(raw: responseJSON['status']),
        extraId: responseJSON['payinExtraId'],
        outputTransaction: responseJSON['payoutHash']);
  }
}