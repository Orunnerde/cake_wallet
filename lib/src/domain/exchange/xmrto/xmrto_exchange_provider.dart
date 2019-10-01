import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_pair.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_provider.dart';
import 'package:cake_wallet/src/domain/exchange/limits.dart';
import 'package:cake_wallet/src/domain/exchange/trade.dart';
import 'package:cake_wallet/src/domain/exchange/trade_request.dart';
import 'package:cake_wallet/src/domain/exchange/trade_state.dart';
import 'package:cake_wallet/src/domain/exchange/xmrto/xmrto_trade_request.dart';


class XMRTOExchangeProvider extends ExchangeProvider {
  static const userAgent = 'CakeWallet/XMR iOS';
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

  Future<Trade> createTrade({TradeRequest request}) async {
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
        return null;
      }
      return null;
    }

    final responseJSON = json.decode(response.body);
    final uuid = responseJSON["uuid"];
    return findTradeById(id: uuid);
  }

  Future<Trade> findTradeById({@required String id}) async {
    const url = XMRTOExchangeProvider.apiUri + '/order_status_query/';
    const headers = {
      'Content-Type': 'application/json',
      'User-Agent': userAgent
    };
    final body = {'uuid': id};
    final response = await post(url, headers: headers, body: json.encode(body));

    if (response.statusCode != 200) {
      // Throw error
      return null;
    }

    final responseJSON = json.decode(response.body);
    final dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");

    final address = responseJSON['xmr_receiving_integrated_address'];
    final paymentId = responseJSON['xmr_required_payment_id_short'];
    final amount = responseJSON['xmr_amount_total'];
    final stateRaw = responseJSON['state'];
    final expiredAtRaw = responseJSON['expires_at'];
    final expiredAt = dateFormatter.parse(expiredAtRaw);
    final outputTransaction = responseJSON['btc_transaction_id'];
    final state = TradeState.deserialize(raw: stateRaw);

    return Trade(
        id: id,
        from: CryptoCurrency.xmr,
        to: CryptoCurrency.btc,
        inputAddress: address,
        extraId: paymentId,
        expiredAt: expiredAt,
        amount: amount,
        state: state,
        outputTransaction: outputTransaction);
  }
}