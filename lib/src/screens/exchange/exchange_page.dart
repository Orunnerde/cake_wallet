import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/stores/exchange/exchange_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/screens/exchange/widgets/exchange_card.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/widgets/picker.dart';
import 'package:cake_wallet/src/domain/exchange/xmrto/xmrto_exchange_provider.dart';
import 'package:cake_wallet/src/stores/exchange/exchange_trade_state.dart';
import 'package:cake_wallet/src/stores/exchange/limits_state.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/routes.dart';

class ExchangePage extends BasePage {
  String get title => 'Exchange';

  @override
  Widget middle(BuildContext context) {
    final exchangeStore = Provider.of<ExchangeStore>(context);

    return InkWell(
      onTap: () => _presentProviderPicker(context),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Exchange',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400)),
                SizedBox(width: 5),
                Image.asset(
                  'assets/images/arrow_bottom_purple_icon.png',
                  height: 8,
                )
              ]),
          Observer(
              builder: (_) => Text(exchangeStore.provider.title,
                  style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400)))
        ],
      ),
    );
  }

  @override
  Widget leading(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('History')]);
  }

  @override
  Widget trailing(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        'Clear',
        style: TextStyle(color: Color.fromRGBO(155, 172, 197, 1)),
      )
    ]);
  }

  @override
  Widget body(BuildContext context) => ExchangeForm();

  void _presentProviderPicker(BuildContext context) {
    final exchangeStore = Provider.of<ExchangeStore>(context);

    showDialog(
        builder: (_) => Picker(
            items: exchangeStore.providerList,
            selectedAtIndex:
                exchangeStore.providerList.indexOf(exchangeStore.provider),
            title: 'Change Exchange Provider',
            onItemSelected: (provider) =>
                exchangeStore.changeProvider(provider: provider)),
        context: context);
  }
}

class ExchangeForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExchangeFormState();
}

class ExchangeFormState extends State<ExchangeForm> {
  final depositKey = GlobalKey<ExchangeCardState>();
  final receiveKey = GlobalKey<ExchangeCardState>();
  var _isReactionsSet = false;

  @override
  Widget build(BuildContext context) {
    final exchangeStore = Provider.of<ExchangeStore>(context);
    final walletStore = Provider.of<WalletStore>(context);

    final depositWalletName =
        exchangeStore.depositCurrency == CryptoCurrency.xmr
            ? walletStore.name
            : null;
    final receiveWalletName =
        exchangeStore.receiveCurrency == CryptoCurrency.xmr
            ? walletStore.name
            : null;

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _setReactions(context, exchangeStore, walletStore));

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'You will send',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, height: 1.1),
              ),
            ),
            ExchangeCard(
                key: depositKey,
                initialCurrency: exchangeStore.depositCurrency,
                initialWalletName: depositWalletName,
                initialIsActive:
                    !(exchangeStore.provider is XMRTOExchangeProvider),
                currencies: CryptoCurrency.all,
                onCurrencySelected: (currency) =>
                    exchangeStore.changeDepositCurrency(currency: currency)),
            SizedBox(height: 35),
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'You will get',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, height: 1.1),
                )),
            ExchangeCard(
                key: receiveKey,
                initialCurrency: exchangeStore.receiveCurrency,
                initialWalletName: receiveWalletName,
                initialIsActive:
                    exchangeStore.provider is XMRTOExchangeProvider,
                currencies: CryptoCurrency.all,
                onCurrencySelected: (currency) =>
                    exchangeStore.changeReceiveCurrency(currency: currency)),
            SizedBox(height: 35),
            Observer(
                builder: (_) => LoadingPrimaryButton(
                      text: 'Create exchange',
                      //onPressed: () => exchangeStore.createTrade(),
                      onPressed: (){
                        exchangeStore.createTrade();
                        Navigator.of(context).pushNamed(Routes.exchangeConfirm);
                      },
                      isLoading: exchangeStore.tradeState is TradeIsCreating,
                    )),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/xmr_btc.png'),
                  SizedBox(width: 10),
                  Text(
                    'Powered by XMR.to',
                    style: TextStyle(
                        fontSize: 14, color: Color.fromRGBO(191, 201, 215, 1)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _setReactions(
      BuildContext context, ExchangeStore store, WalletStore walletStore) {
    if (_isReactionsSet) {
      return;
    }

    final depositAddressController = depositKey.currentState.addressController;
    final depositAmountController = depositKey.currentState.amountController;
    final receiveAddressController = receiveKey.currentState.addressController;
    final receiveAmountController = receiveKey.currentState.amountController;
    final limitsState = store.limitsState;

    if (limitsState is LimitsLoadedSuccessfully) {
      final min = limitsState.limits.min != null
          ? limitsState.limits.min.toString()
          : null;
      final max = limitsState.limits.max != null
          ? limitsState.limits.max.toString()
          : null;
      final key =
          store.provider is XMRTOExchangeProvider ? receiveKey : depositKey;
      key.currentState.changeLimits(min: min, max: max);
    }

    _onCurrencyChange(store.receiveCurrency, walletStore, receiveKey);
    _onCurrencyChange(store.depositCurrency, walletStore, depositKey);

    reaction(
        (_) => walletStore.name,
        (_) => _onWalletNameChange(
            walletStore, store.receiveCurrency, receiveKey));

    reaction(
        (_) => walletStore.name,
        (_) => _onWalletNameChange(
            walletStore, store.depositCurrency, depositKey));

    reaction((_) => store.receiveCurrency,
        (currency) => _onCurrencyChange(currency, walletStore, receiveKey));

    reaction((_) => store.depositCurrency,
        (currency) => _onCurrencyChange(currency, walletStore, depositKey));

    reaction((_) => store.depositAmount, (amount) {
      depositKey.currentState.amountController.text = amount;
    });

    reaction((_) => store.receiveAmount, (amount) {
      if (receiveKey.currentState.amountController.text !=
          store.receiveAmount) {
        receiveKey.currentState.amountController.text = amount;
      }
    });

    reaction((_) => store.tradeState, (state) {
      if (state is TradeIsCreatedFailure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(state.error),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.of(context).pop())
                  ],
                );
              });
        });
      }
    });

    reaction((_) => store.limitsState, (state) {
      final isXMRTO = store.provider is XMRTOExchangeProvider;
      String min;
      String max;

      if (state is LimitsLoadedSuccessfully) {
        min = state.limits.min != null ? state.limits.min.toString() : null;
        max = state.limits.max != null ? state.limits.max.toString() : null;
      }

      if (state is LimitsLoadedFailure) {
        min = '0';
        max = '0';
      }

      if (state is LimitsIsLoading) {
        min = '...';
        max = '...';
      }

      final depositMin = isXMRTO ? null : min;
      final depositMax = isXMRTO ? null : max;
      final receiveMin = isXMRTO ? min : null;
      final receiveMax = isXMRTO ? max : null;

      depositKey.currentState.changeLimits(min: depositMin, max: depositMax);
      receiveKey.currentState.changeLimits(min: receiveMin, max: receiveMax);
    });

    depositAddressController.addListener(
        () => store.depositAddress = depositAddressController.text);

    depositAmountController.addListener(() {
      if (depositAmountController.text != store.depositAmount) {
        store.changeDepositAmount(amount: depositAmountController.text);
      }
    });

    receiveAddressController.addListener(
        () => store.receiveAddress = receiveAddressController.text);

    receiveAmountController.addListener(() {
      if (receiveAmountController.text != store.receiveAmount) {
        store.changeReceiveAmount(amount: receiveAmountController.text);
      }
    });

    _isReactionsSet = true;
  }

  void _onCurrencyChange(CryptoCurrency currency, WalletStore walletStore,
      GlobalKey<ExchangeCardState> key) {
    final isCurrentTypeWallet = currency == walletStore.type;

    key.currentState.changeSelectedCurrency(currency);
    key.currentState
        .changeWalletName(isCurrentTypeWallet ? walletStore.name : null);

    if (isCurrentTypeWallet) {
      key.currentState.addressController.text = walletStore.address;
    } else if (key.currentState.addressController.text == walletStore.address) {
      key.currentState.addressController.text = null;
    }
  }

  void _onWalletNameChange(WalletStore walletStore, CryptoCurrency currency,
      GlobalKey<ExchangeCardState> key) {
    final isCurrentTypeWallet = currency == walletStore.type;

    if (isCurrentTypeWallet) {
      key.currentState.changeWalletName(walletStore.name);
      key.currentState.addressController.text = walletStore.address;
    } else if (key.currentState.addressController.text == walletStore.address) {
      key.currentState.changeWalletName(null);
      key.currentState.addressController.text = null;
    }
  }
}
