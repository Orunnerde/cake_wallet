import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:cw_monero/signatures.dart';
import 'package:cw_monero/types.dart';
import 'package:cw_monero/monero_api.dart';
import 'package:cw_monero/structs/account_row.dart';

final accountSizeNative = moneroApi
    .lookup<NativeFunction<account_size>>('account_size')
    .asFunction<SubaddressSize>();

final accountRefreshNative = moneroApi
    .lookup<NativeFunction<account_refresh>>('account_refresh')
    .asFunction<AccountRefresh>();

final accountGetAllNative = moneroApi
    .lookup<NativeFunction<account_get_all>>('account_get_all')
    .asFunction<AccountGetAll>();

final accountAddNewNative = moneroApi
    .lookup<NativeFunction<account_add_new>>('account_add_row')
    .asFunction<AccountAddNew>();

final accountSetLabelNative = moneroApi
    .lookup<NativeFunction<account_set_label>>('account_set_label_row')
    .asFunction<AccountSetLabel>();

refreshAccounts() => accountRefreshNative();

List<AccountRow> getAllAccount() {
  final size = accountSizeNative();
  final accountAddressesPointer = accountGetAllNative();
  final accountAddresses = accountAddressesPointer.asTypedList(size);

  return accountAddresses
      .map((addr) => Pointer<AccountRow>.fromAddress(addr).ref)
      .toList();
}

addAccount({String label}) {
  final labelPointer = Utf8.toUtf8(label);
  accountAddNewNative(labelPointer);
  free(labelPointer);
}

setLabelForAccount({int accountIndex, String label}) {
  final labelPointer = Utf8.toUtf8(label);
  accountSetLabelNative(accountIndex, labelPointer);
  free(labelPointer);
}
