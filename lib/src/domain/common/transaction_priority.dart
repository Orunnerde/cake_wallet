import 'package:cake_wallet/src/domain/common/enumerable_item.dart';

class TransactionPriority extends EnumerableItem<int> with Serializable<int> {
  static final all = [
    TransactionPriority.slow,
    TransactionPriority.regular,
    TransactionPriority.medium,
    TransactionPriority.fast,
    TransactionPriority.fastest
  ];
  static final slow = TransactionPriority(title: 'Slow', raw: 0);
  static final regular = TransactionPriority(title: 'Regular', raw: 1);
  static final medium = TransactionPriority(title: 'Medium', raw: 2);
  static final fast = TransactionPriority(title: 'Fast', raw: 3);
  static final fastest = TransactionPriority(title: 'Fastest', raw: 4);
  static final standart = slow;

  static TransactionPriority deserialize({int raw}) {
    var title = '';

    switch (raw) {
      case 0:
        title = 'Slow';
        break;
      case 1:
        title = 'Regular';
        break;
      case 2:
        title = 'Fast';
        break;
      case 3:
        title = 'Fastest';
        break;
      default:
        return null;
    }

    return TransactionPriority(title: title, raw: raw);
  }

  TransactionPriority({String title, int raw}) : super(title: title, raw: raw);
}
