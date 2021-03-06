import 'package:mobx/mobx.dart';
import 'package:cake_wallet/core/execution_state.dart';
import 'package:cake_wallet/monero/monero_account_list.dart';
import 'package:cake_wallet/view_model/monero_account_list/account_list_item.dart';

part 'monero_account_edit_or_create_view_model.g.dart';

class MoneroAccountEditOrCreateViewModel = MoneroAccountEditOrCreateViewModelBase
    with _$MoneroAccountEditOrCreateViewModel;

abstract class MoneroAccountEditOrCreateViewModelBase with Store {
  MoneroAccountEditOrCreateViewModelBase(this._moneroAccountList,
      {AccountListItem accountListItem})
      : state = InitialExecutionState(),
        isEdit = accountListItem != null,
        _accountListItem = accountListItem;

  final bool isEdit;

  @observable
  ExecutionState state;

  @observable
  String label;

  final MoneroAccountList _moneroAccountList;
  final AccountListItem _accountListItem;

  Future<void> save() async {
    try {
      state = IsExecutingState();

      if (_accountListItem != null) {
        await _moneroAccountList.setLabelAccount(
            accountIndex: _accountListItem.id, label: label);
      } else {
        await _moneroAccountList.addAccount(label: label);
      }

      state = ExecutedSuccessfullyState();
    } catch (e) {
      state = FailureState(e.toString());
    }
  }
}
