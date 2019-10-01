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

class ExchangePage extends BasePage {
  // final depositAddressController = TextEditingController();
  // final depositAmountController = TextEditingController();
  // final receiveAddressController = TextEditingController();
  // final receiveAmountController = TextEditingController();

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
  Widget body(BuildContext context) {
    print('REBUILD');
    final exchangeStore = Provider.of<ExchangeStore>(context);
    final depositWalletName =
        exchangeStore.depositCurrency == CryptoCurrency.xmr
            ? 'WalletName'
            : null;
    final receiveWalletName =
        exchangeStore.receiveCurrency == CryptoCurrency.xmr
            ? 'WalletName'
            : null;

    reaction((_) => exchangeStore.tradeState, (state) {
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

    // depositAddressController.addListener(
    //     () => exchangeStore.depositAddress = depositAddressController.text);

    // depositAmountController.addListener(
    //     () => exchangeStore.depositAmount = depositAmountController.text);

    // receiveAddressController.addListener(
    //     () => exchangeStore.receiveAddress = receiveAddressController.text);

    // receiveAmountController.addListener(
    //     () => exchangeStore.receiveAmount = receiveAmountController.text);

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
            Observer(builder: (_) {
              final state = exchangeStore.limitsState;
              final isXMRTO = exchangeStore.provider is XMRTOExchangeProvider;
              String min;
              String max;

              if (!isXMRTO) {
                if (state is LimitsLoadedSuccessfully) {
                  min = state.limits.min != null
                      ? state.limits.min.toString()
                      : null;
                  max = state.limits.max != null
                      ? state.limits.max.toString()
                      : null;
                }

                if (state is LimitsLoadedFailure) {
                  min = '0';
                  max = '0';
                }

                if (state is LimitsIsLoading) {
                  min = '...';
                  max = '...';
                }
              }

              return ExchangeCard(
                  selectedCurrency: exchangeStore.depositCurrency,
                  walletName: depositWalletName,
                  min: min,
                  max: max,
                  isActive: !(exchangeStore.provider is XMRTOExchangeProvider),
                  // addressController: depositAddressController,
                  // amountController: depositAmountController,
                  currencies: CryptoCurrency.all
                      .where((c) => c != exchangeStore.receiveCurrency)
                      .toList(),
                  onCurrencySelected: (currency) =>
                      exchangeStore.changeDepositCurrency(currency: currency));
            }),
            SizedBox(height: 35),
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'You will get',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, height: 1.1),
                )),
            Observer(builder: (_) {
              final state = exchangeStore.limitsState;
              final isXMRTO = exchangeStore.provider is XMRTOExchangeProvider;
              String min;
              String max;

              if (isXMRTO) {
                if (state is LimitsLoadedSuccessfully) {
                  min = state.limits.min != null
                      ? state.limits.min.toString()
                      : null;
                  max = state.limits.max != null
                      ? state.limits.max.toString()
                      : null;
                }

                if (state is LimitsLoadedFailure) {
                  min = '0';
                  max = '0';
                }

                if (state is LimitsIsLoading) {
                  min = '...';
                  max = '...';
                }
              }

              return ExchangeCard(
                  selectedCurrency: exchangeStore.receiveCurrency,
                  walletName: receiveWalletName,
                  min: min,
                  max: max,
                  isActive: exchangeStore.provider is XMRTOExchangeProvider,
                  // addressController: receiveAddressController,
                  // amountController: receiveAmountController,
                  currencies: CryptoCurrency.all
                      .where((c) => c != exchangeStore.depositCurrency)
                      .toList(),
                  onCurrencySelected: (currency) =>
                      exchangeStore.changeReceiveCurrency(currency: currency));
            }),
            SizedBox(height: 35),
            Observer(
                builder: (_) => LoadingPrimaryButton(
                      text: 'Create exchange',
                      onPressed: () => exchangeStore.createTrade(),
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
