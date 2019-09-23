import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/common/enumerable_item.dart';

class BalanceDisplayMode extends EnumerableItem<int> with Serializable<int> {
  static final all = [
    BalanceDisplayMode.fullBalance,
    BalanceDisplayMode.availableBalance,
    BalanceDisplayMode.hiddenBalance
  ];
  static final fullBalance = BalanceDisplayMode.deserialize(raw: 0);
  static final availableBalance = BalanceDisplayMode.deserialize(raw: 1);
  static final hiddenBalance = BalanceDisplayMode.deserialize(raw: 2);

  static BalanceDisplayMode deserialize({int raw}) {
    var title = '';

    switch (raw) {
      case 0:
        title = 'Full Balance';
        break;
      case 1:
        title = 'Available Balance';
        break;
      case 2:
        title = 'Hidden Balance';
        break;
      default:
        return null;
    }

    return BalanceDisplayMode(title: title, raw: raw);
  }

  BalanceDisplayMode({@required String title, @required int raw})
      : super(title: title, raw: raw);
}
