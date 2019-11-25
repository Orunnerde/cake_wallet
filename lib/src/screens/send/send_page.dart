import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/address_text_field.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/stores/balance/balance_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/stores/send/send_store.dart';
import 'package:cake_wallet/src/stores/send/sending_state.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';

class SendPage extends BasePage {
  String get title => 'Send Monero';
  bool get isModalBackButton => true;
  bool get resizeToAvoidBottomPadding => false;

  @override
  Widget body(BuildContext context) => SendForm();
}

class SendForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SendFormState();
}

class SendFormState extends State<SendForm> {
  final _addressController = TextEditingController();
  final _paymentIdController = TextEditingController();
  final _cryptoAmountController = TextEditingController();
  final _fiatAmountController = TextEditingController();

  bool _effectsInstalled = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    final sendStore = Provider.of<SendStore>(context);
    sendStore.settingsStore = settingsStore;
    final balanceStore = Provider.of<BalanceStore>(context);
    final walletStore = Provider.of<WalletStore>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    _setEffects(context);

    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 38, right: 30),
          decoration: BoxDecoration(
              color: _isDarkTheme
                  ? PaletteDark.darkThemeBackgroundDark
                  : Colors.white,
              boxShadow: _isDarkTheme
                  ? null
                  : [
                BoxShadow(
                  color: Palette.shadowGrey,
                  blurRadius: 10,
                  offset: Offset(
                    0,
                    12,
                  ),
                )
              ],
              border: Border(
                  top: BorderSide(
                      width: 1,
                      color: _isDarkTheme
                          ? PaletteDark.darkThemeDarkGrey
                          : Palette.lightLavender))),
          child: SizedBox(
            height: 76,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Observer(builder: (_) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Your wallet',
                            style: TextStyle(
                                fontSize: 12, color: Palette.lightViolet)),
                        Text(walletStore.name,
                            style: TextStyle(
                                fontSize: 18,
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeTitle
                                    : Palette.nightBlue,
                                height: 1.25)),
                      ]);
                }),
                Observer(builder: (context) {
                  final savedDisplayMode = settingsStore.balanceDisplayMode;
                  final availableBalance = savedDisplayMode.serialize() ==
                      BalanceDisplayMode.hiddenBalance.serialize()
                      ? '---'
                      : balanceStore.unlockedBalance;

                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('XMR Available Balance',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isDarkTheme
                                  ? PaletteDark.darkThemeGrey
                                  : Palette.nightBlue,
                            )),
                        Text(availableBalance,
                            style: TextStyle(
                                fontSize: 22,
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeTitle
                                    : Palette.nightBlue,
                                height: 1.1)),
                      ]);
                })
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 38, right: 33, top: 30, bottom: 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(children: <Widget>[
                      AddressTextField(
                          controller: _addressController,
                          placeholder: 'Monero address',
                          onURIScanned: (uri) {
                            var address = '';
                            var amount = '';
                            var paymentId = '';

                            if (uri != null) {
                              address = uri.path;
                              amount = uri.queryParameters['tx_amount'];
                              paymentId = uri.queryParameters['tx_payment_id'];
                            } else {
                              address = uri.toString();
                            }

                            _addressController.text = address;
                            _cryptoAmountController.text = amount;
                            _paymentIdController.text = paymentId;
                          },
                          options: [
                            AddressTextFieldOption.qrCode,
                            AddressTextFieldOption.addressBook
                          ],
                          validator: (value) {
                            sendStore.validateAddress(value, cryptoCurrency: CryptoCurrency.xmr);
                            return sendStore.errorMessage;
                          },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                            style: TextStyle(
                                fontSize: 14.0,
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeGrey
                                    : Palette.nightBlue),
                            controller: _paymentIdController,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontSize: 14.0,
                                    color: _isDarkTheme
                                        ? PaletteDark.darkThemeGrey
                                        : Palette.lightBlue),
                                hintText: 'Payment ID (optional)',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0))),
                            validator: (value) {
                              sendStore.validatePaymentID(value);
                              return sendStore.errorMessage;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                            showCursor: false,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeTitle
                                    : Palette.nightBlue),
                            controller: _cryptoAmountController,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                            inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ |\\,]'))],
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text('XMR:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeTitle
                                            : Palette.nightBlue,
                                      )),
                                ),
                                suffixIcon: Container(
                                  width: 1,
                                  padding: EdgeInsets.only(top: 0),
                                  child: Center(
                                    child: InkWell(
                                        onTap: () => sendStore.setSendAll(),
                                        child: Text('ALL',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: _isDarkTheme
                                                    ? PaletteDark.darkThemeTitle
                                                    : Palette.manatee))),
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: _isDarkTheme
                                        ? PaletteDark.darkThemeTitle
                                        : Palette.lightBlue),
                                hintText: '0.0000',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0))),
                            validator: (value) {
                              sendStore.validateXMR(value, balanceStore.unlockedBalance);
                              return sendStore.errorMessage;
                            }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                            showCursor: false,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeTitle
                                    : Palette.nightBlue),
                            controller: _fiatAmountController,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                            inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ |\\,]'))],
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                      '${settingsStore.fiatCurrency.toString()}:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeTitle
                                            : Palette.nightBlue,
                                      )),
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: _isDarkTheme
                                        ? PaletteDark.darkThemeTitle
                                        : Palette.lightBlue),
                                hintText: '0.00',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme
                                            ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0))),
                            validator: (value) {
                              if (value.isEmpty) {
                                sendStore.validateFiat(value);
                                return sendStore.errorMessage;
                              } else {
                                try {
                                  double cryptoAmount = double.parse(_cryptoAmountController.text);
                                  double fiatAmount = double.parse(_fiatAmountController.text);
                                  double availableAmount = double.parse(balanceStore.unlockedBalance);
                                  if (cryptoAmount > 0) {
                                    availableAmount *= fiatAmount/cryptoAmount;
                                    sendStore.validateFiat(value, maxValue: availableAmount);
                                    return sendStore.errorMessage;
                                  } else return "Minimum value of amount is 0.01";
                                } catch (e) {
                                  return "Currency can only contain numbers";
                                }
                              }
                            }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Estimated fee:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _isDarkTheme
                                      ? PaletteDark.darkThemeGrey
                                      : Palette.nightBlue,
                                )),
                            Text('XMR 0.00003121',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _isDarkTheme
                                      ? PaletteDark.darkThemeGrey
                                      : Palette.nightBlue,
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                            'Currently the fee is set at ${settingsStore.transactionPriority.toString()} priority.\nTransaction priority can be adjusted in the settings',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeGrey
                                    : Palette.wildDarkBlue,
                                height: 1.3)),
                      ),
                    ]),
                    Observer(builder: (_) {
                      print(sendStore.state);

                      return LoadingPrimaryButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Creating transaction'),
                                      content: Text('Confirm sending'),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text("Send"),
                                            onPressed: () async {
                                              Navigator.of(context).popAndPushNamed(
                                                  Routes.auth, arguments:
                                                  (isAuthenticatedSuccessfully,
                                                  auth) {
                                                if (!isAuthenticatedSuccessfully) {
                                                  return;
                                                }

                                                Navigator.of(auth.context).pop();

                                                sendStore.createTransaction(
                                                    address:
                                                    _addressController.text,
                                                    paymentId:
                                                    _paymentIdController.text,
                                                    amount: _cryptoAmountController.text == 'ALL'?
                                                    balanceStore.unlockedBalance : null
                                                );
                                              });
                                            }),
                                        FlatButton(
                                            child: Text("Cancel"),
                                            onPressed: () =>
                                                Navigator.of(context).pop())
                                      ],
                                    );
                                  });
                            }
                          },
                          text: 'Send',
                          color: _isDarkTheme
                              ? PaletteDark.darkThemeIndigoButton
                              : Palette.indigo,
                          borderColor: _isDarkTheme
                              ? PaletteDark.darkThemeIndigoButtonBorder
                              : Palette.deepIndigo,
                          isLoading: sendStore.state is CreatingTransaction ||
                              sendStore.state is TransactionCommitted);
                    })
                  ])),
        )
      ])
    );
  }

  void _setEffects(BuildContext context) {
    if (_effectsInstalled) {
      return;
    }

    final sendStore = Provider.of<SendStore>(context);

    reaction((_) => sendStore.fiatAmount, (amount) {
      if (amount != _fiatAmountController.text) {
        _fiatAmountController.text = amount;
      }
    });

    reaction((_) => sendStore.cryptoAmount, (amount) {
      if (amount != _cryptoAmountController.text) {
        _cryptoAmountController.text = amount;
      }
    });

    _fiatAmountController.addListener(() {
      final fiatAmount = _fiatAmountController.text;

      if (sendStore.fiatAmount != fiatAmount) {
        sendStore.changeFiatAmount(fiatAmount);
      }
    });

    _cryptoAmountController.addListener(() {
      final cryptoAmount = _cryptoAmountController.text;

      if (sendStore.cryptoAmount != cryptoAmount) {
        sendStore.changeCryptoAmount(cryptoAmount);
      }
    });

    reaction((_) => sendStore.state, (state) {
      if (state is SendingFailed) {
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

      if (state is TransactionCreatedSuccessfully) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm sending'),
                  content: Text(
                      'Commit transaction\nAmount: ${sendStore.pendingTransaction.amount}\nFee: ${sendStore.pendingTransaction.fee}'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          sendStore.commitTransaction();
                        }),
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              });
        });
      }

      if (state is TransactionCommitted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Sending'),
                  content: Text('Transaction sent!'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          _addressController.text = '';
                          _cryptoAmountController.text = '';
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        });
      }
    });

    _effectsInstalled = true;
  }
}
