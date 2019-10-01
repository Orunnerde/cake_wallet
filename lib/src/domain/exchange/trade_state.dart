import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/common/enumerable_item.dart';

class TradeState extends EnumerableItem<String> with Serializable<String> {
  static const pending = TradeState(raw: 'pending', title: 'Pending');
  static const confirming = TradeState(raw: 'confirming', title: 'Confirming');
  static const trading = TradeState(raw: 'trading', title: 'Trading');
  static const traded = TradeState(raw: 'traded', title: 'Traded');
  static const complete = TradeState(raw: 'complete', title: 'Complete');
  static const toBeCreated =
      TradeState(raw: 'TO_BE_CREATED', title: 'To be created');
  static const unpaid = TradeState(raw: 'UNPAID', title: 'Unpaid');
  static const underpaid = TradeState(raw: 'UNDERPAID', title: 'Underpaid');
  static const paidUnconfirmed =
      TradeState(raw: 'PAID_UNCONFIRMED', title: 'Paid unconfirmed');
  static const paid = TradeState(raw: 'PAID', title: 'Paid');
  static const btcSent = TradeState(raw: 'BTC_SENT', title: 'Btc sent');
  static const timeout = TradeState(raw: 'TIMED_OUT', title: 'Timeout');
  static const notFound = TradeState(raw: 'NOT_FOUND', title: 'Not found');
  static const created = TradeState(raw: 'created', title: 'Created');
  static const finished = TradeState(raw: 'finished', title: 'Finished');

  static TradeState deserialize({String raw}) {
    var title = '';

    switch (raw) {
      case 'pending':
        title = 'Pending';
        break;
      case 'confirming':
        title = 'Confirming';
        break;
      case 'trading':
        title = 'Trading';
        break;
      case 'traded':
        title = 'Traded';
        break;
      case 'complete':
        title = 'Complete';
        break;
      case 'TO_BE_CREATED':
        title = 'To be created';
        break;
      case 'UNPAID':
        title = 'Unpaid';
        break;
      case 'UNDERPAID':
        title = 'Underpaid';
        break;
      case 'PAID_UNCONFIRMED':
        title = 'Paid unconfirmed';
        break;
      case 'PAID':
        title = 'Paid';
        break;
      case 'BTC_SENT':
        title = 'Btc sen';
        break;
      case 'TIMED_OUT':
        title = 'Timeout';
        break;
      case 'created':
        title = 'Created';
        break;
      case 'finished':
        title = 'Finished';
        break;
      default:
        return null;
    }

    return TradeState(raw: raw, title: title);
  }

  const TradeState({@required String raw, @required String title})
      : super(raw: raw, title: title);
}