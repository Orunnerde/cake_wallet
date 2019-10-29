import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/common/pending_transaction.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/fetch_price.dart';
import 'package:cake_wallet/src/domain/monero/monero_transaction_creation_credentials.dart';
import 'package:cake_wallet/src/domain/common/recipient_address_list.dart';
import 'package:cake_wallet/src/stores/send/sending_state.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';

part 'send_store.g.dart';

class SendStore = SendStoreBase with _$SendStore;

abstract class SendStoreBase with Store {
  WalletService walletService;
  SettingsStore settingsStore;
  RecipientAddressList recipientAddressList;

  @observable
  SendingState state;

  @observable
  String fiatAmount;

  @observable
  String cryptoAmount;

  PendingTransaction get pendingTransaction => _pendingTransaction;
  PendingTransaction _pendingTransaction;
  NumberFormat _cryptoNumberFormat;
  NumberFormat _fiatNumberFormat;
  String _lastRecipientAddress;

  SendStoreBase(
      {@required this.walletService,
      @required this.settingsStore,
      this.recipientAddressList}) {
    state = SendingStateInitial();
    _pendingTransaction = null;
    _cryptoNumberFormat = NumberFormat()..maximumFractionDigits = 12;
    _fiatNumberFormat = NumberFormat()..maximumFractionDigits = 2;

    reaction((_) => this.fiatAmount, (amount) async {
      fetchPriceFor(crypto: CryptoCurrency.xmr, fiat: settingsStore.fiatCurrency)
          .then((price) => amount.isEmpty ? null : double.parse(amount) / price)
          .then((amount) =>
              amount == null ? '' : _cryptoNumberFormat.format(amount))
          .then((amount) => cryptoAmount = amount);
    });

    reaction((_) => this.cryptoAmount, (amount) async {
      fetchPriceFor(crypto: CryptoCurrency.xmr, fiat: settingsStore.fiatCurrency)
          .then((price) => amount.isEmpty
              ? null
              : double.parse(amount.replaceAll(',', '.')) * price)
          .then((amount) =>
              amount == null ? '' : _fiatNumberFormat.format(amount))
          .then((amount) => fiatAmount = amount);
    });
  }

  @action
  Future<void> createTransaction({String address, String paymentId}) async {
    state = CreatingTransaction();

    try {
      final amount =
          cryptoAmount == 'ALL' ? null : cryptoAmount.replaceAll(',', '.');
      final credentials = MoneroTransactionCreationCredentials(
          address: address,
          paymentId: paymentId,
          amount: amount,
          priority: settingsStore.transactionPriority);

      _pendingTransaction = await walletService.createTransaction(credentials);
      state = TransactionCreatedSuccessfully();
      _lastRecipientAddress = address;
    } catch (e) {
      state = SendingFailed(error: e.toString());
    }
  }

  @action
  Future<void> commitTransaction() async {
    try {
      final transactionId = _pendingTransaction.hash;
      state = TransactionCommiting();
      await _pendingTransaction.commit();
      state = TransactionCommitted();

      if (settingsStore.shouldSaveRecipientAddress) {
        await recipientAddressList.add(
            recipientAddress: _lastRecipientAddress,
            transactionId: transactionId);
      }
    } catch (e) {
      state = SendingFailed(error: e.toString());
    }

    _pendingTransaction = null;
  }

  @action
  void setSendAll() {
    cryptoAmount = 'ALL';
    fiatAmount = '';
  }
}
