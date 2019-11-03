import 'package:mobx/mobx.dart';

part 'transaction_filter_store.g.dart';

class TransactionFilterStore = TransactionFilterStoreBase
    with _$TransactionFilterStore;

abstract class TransactionFilterStoreBase with Store {
  @observable
  bool displayIncoming;

  @observable
  bool displayOutgoing;

  @observable
  DateTime startDate;

  @observable
  DateTime endDate;

  TransactionFilterStoreBase(
      {this.displayIncoming = true, this.displayOutgoing = true});

  @action
  void toggleIncoming() => displayIncoming = !displayIncoming;

  @action
  void toggleOutgoing() => displayOutgoing = !displayOutgoing;

  @action
  void changeStartDate(DateTime date) => startDate = date;

  @action
  void changeEndDate(DateTime date) => endDate = date;
}
