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

  @observable
  bool isValid;

  @observable
  String errorMessage;

  PendingTransaction get pendingTransaction => _pendingTransaction;
  PendingTransaction _pendingTransaction;
  NumberFormat _cryptoNumberFormat;
  NumberFormat _fiatNumberFormat;
  String _lastRecipientAddress;

  SendStoreBase(
      {@required this.walletService,
      this.settingsStore,
      this.recipientAddressList}) {
    state = SendingStateInitial();
    _pendingTransaction = null;
    _cryptoNumberFormat = NumberFormat()..maximumFractionDigits = 12;
    _fiatNumberFormat = NumberFormat()..maximumFractionDigits = 2;
  }

  @action
  Future<void> createTransaction(
      {String address, String paymentId, String amount}) async {
    state = CreatingTransaction();

    try {
      final _amount = amount != null
          ? amount
          : cryptoAmount == 'ALL' ? null : cryptoAmount.replaceAll(',', '.');
      final credentials = MoneroTransactionCreationCredentials(
          address: address,
          paymentId: paymentId ?? '',
          amount: _amount,
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
  void setSendAll(String availableBalance) {
    /*cryptoAmount = 'ALL';
    fiatAmount = '';*/
    changeCryptoAmount(availableBalance);
  }

  @action
  void changeCryptoAmount(String amount) {
    cryptoAmount = amount;

    if (cryptoAmount != null && cryptoAmount.isNotEmpty) {
      _calculateFiatAmount();
    }
  }

  @action
  void changeFiatAmount(String amount) {
    fiatAmount = amount;

    if (fiatAmount != null && fiatAmount.isNotEmpty) {
      _calculateCryptoAmount();
    }
  }

  @action
  Future _calculateFiatAmount() async {
    final price =
        await fetchPriceFor(crypto: CryptoCurrency.xmr, fiat: settingsStore.fiatCurrency);
    final amount = double.parse(cryptoAmount) * price;
    fiatAmount = _fiatNumberFormat.format(amount);
  }

  @action
  Future _calculateCryptoAmount() async {
    final price =
        await fetchPriceFor(crypto: CryptoCurrency.xmr, fiat: settingsStore.fiatCurrency);
    final amount = double.parse(fiatAmount) / price;
    cryptoAmount = _cryptoNumberFormat.format(amount);
  }

  void validateAddress(String value, {CryptoCurrency cryptoCurrency}) {
    // XMR (95), BTC (34), ETH (42), LTC (34), BCH (42), DASH (34)
    String p = '^[0-9a-zA-Z]{95}\$|^[0-9a-zA-Z]{34}\$|^[0-9a-zA-Z]{42}\$';
    RegExp regExp = new RegExp(p);
    isValid = regExp.hasMatch(value);
    if (isValid && cryptoCurrency != null) {
      switch (cryptoCurrency.toString()) {
        case 'XMR':
          isValid = (value.length == 95);
          break;
        case 'BTC':
          isValid = (value.length == 34);
          break;
        case 'ETH':
          isValid = (value.length == 42);
          break;
        case 'LTC':
          isValid = (value.length == 34);
          break;
        case 'BCH':
          isValid = (value.length == 42);
          break;
        case 'DASH':
          isValid = (value.length == 34);
      }
    }
    errorMessage = isValid ? null : 'Wallet address must correspond to the type of cryptocurrency';
  }

  void validatePaymentID(String value) {
    if (value.isEmpty) {
      isValid = true;
    } else {
      String p = '^[A-Fa-f0-9]{16,64}\$';
      RegExp regExp = new RegExp(p);
      isValid = regExp.hasMatch(value);
    }
    errorMessage = isValid ? null : 'Payment ID can only contain from 16 to 64 chars in hex';
  }

  void validateXMR(String value, String availableBalance) {
    const double maxValue = 18446744.073709551616;
    String p = '^([0-9]+([.][0-9]{0,12})?|[.][0-9]{1,12})\$';
    RegExp regExp = new RegExp(p);
    if (regExp.hasMatch(value)) {
      try {
        double dValue = double.parse(value);
        double maxAvailable = double.parse(availableBalance);
        isValid = (dValue <= maxAvailable && dValue <= maxValue && dValue > 0);
      } catch (e) {
        isValid = false;
      }
    } else isValid = false;
    errorMessage = isValid ? null : "XMR value can't exceed available balance.\n"
                                    "The number of fraction digits must be less or equal to 12";
  }

  void validateFiat(String value, double maxValue) {
    const double minValue = 0.01;
    String p = '^([0-9]+([.][0-9]{0,2})?|[.][0-9]{1,2})\$';
    RegExp regExp = new RegExp(p);
    if (regExp.hasMatch(value)) {
      try {
        double dValue = double.parse(value);
        isValid = (dValue >= minValue && dValue <= maxValue);
      } catch (e) {
        isValid = false;
      }
    } else isValid = false;
    errorMessage = isValid ? null : "Value of amount can't exceed available balance."
                                    "The number of fraction digits must be less or equal to 2";
  }
}
