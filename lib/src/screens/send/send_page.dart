import 'package:cake_wallet/src/screens/auth/auth_page.dart';
import 'package:cake_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/widgets/address_text_field.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/stores/balance/balance_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/stores/send/send_store.dart';
import 'package:cake_wallet/src/stores/send/sending_state.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/common/calculate_estimated_fee.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/stores/sync/sync_store.dart';
import 'package:cake_wallet/src/widgets/top_panel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:cake_wallet/src/widgets/alert_with_one_action.dart';
import 'package:cake_wallet/src/widgets/alert_with_two_actions.dart';
import 'package:cake_wallet/src/screens/send/widgets/confirm_sending_alert.dart';
import 'package:cake_wallet/src/screens/send/widgets/sending_alert.dart';
import 'package:cake_wallet/src/widgets/template_tile.dart';
import 'package:cake_wallet/src/stores/send_template/send_template_store.dart';
import 'package:cake_wallet/src/widgets/trail_button.dart';
import 'package:cake_wallet/src/widgets/base_text_form_field.dart';

class SendPage extends BasePage {
  @override
  String get title => S.current.send_title;

  @override
  Color get backgroundLightColor => Palette.lavender;

  @override
  Color get backgroundDarkColor => PaletteDark.lightNightBlue;

  @override
  bool get resizeToAvoidBottomPadding => false;

  @override
  bool get isModalBackButton => true;

  @override
  Widget trailing(context) {
    final sendStore = Provider.of<SendStore>(context);

    return TrailButton(
      caption: S.of(context).clear,
      onPressed: () => sendStore.clear()
    );
  }

  @override
  Widget body(BuildContext context) => SendForm();
}

class SendForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SendFormState();
}

class SendFormState extends State<SendForm> {
  final _addressController = TextEditingController();
  final _cryptoAmountController = TextEditingController();
  final _fiatAmountController = TextEditingController();

  final _focusNode = FocusNode();

  bool _effectsInstalled = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus &&_addressController.text.isNotEmpty) {
        getOpenaliasRecord(context);
      }
    });

    super.initState();
  }

  Future<void> getOpenaliasRecord(BuildContext context) async {
    final sendStore = Provider.of<SendStore>(context);
    final isOpenalias = await sendStore.isOpenaliasRecord(_addressController.text);

    if (isOpenalias) {
      _addressController.text = sendStore.recordAddress;

      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertWithOneAction(
              alertTitle: S.of(context).openalias_alert_title,
              alertContent: S.of(context).openalias_alert_content(sendStore.recordName),
              buttonText: S.of(context).ok,
              buttonAction: () => Navigator.of(context).pop()
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    final sendStore = Provider.of<SendStore>(context);
    sendStore.settingsStore = settingsStore;
    final balanceStore = Provider.of<BalanceStore>(context);
    final walletStore = Provider.of<WalletStore>(context);
    final syncStore = Provider.of<SyncStore>(context);
    final sendTemplateStore = Provider.of<SendTemplateStore>(context);

    _setEffects(context);

    return Container(
      color: Theme.of(context).backgroundColor,
      child: ScrollableWithBottomSection(
        contentPadding: EdgeInsets.only(bottom: 24),
        content: Column(
          children: <Widget>[
            TopPanel(
              color: Theme.of(context).accentTextTheme.title.backgroundColor,
              widget: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  AddressTextField(
                    controller: _addressController,
                    placeholder: S.of(context).send_monero_address,
                    focusNode: _focusNode,
                    onURIScanned: (uri) {
                      var address = '';
                      var amount = '';

                      if (uri != null) {
                        address = uri.path;
                        amount = uri.queryParameters['tx_amount'];
                      } else {
                        address = uri.toString();
                      }

                      _addressController.text = address;
                      _cryptoAmountController.text = amount;
                    },
                    options: [
                      AddressTextFieldOption.paste,
                      AddressTextFieldOption.qrCode,
                      AddressTextFieldOption.addressBook
                    ],
                    buttonColor: Theme.of(context).accentTextTheme.headline.decorationColor,
                    borderColor: Theme.of(context).primaryTextTheme.display4.decorationColor,
                    validator: (value) {
                      sendStore.validateAddress(value,
                          cryptoCurrency: CryptoCurrency.xmr);
                      return sendStore.errorMessage;
                    },
                  ),
                  Observer(
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: BaseTextFormField(
                          controller: _cryptoAmountController,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: true),
                          inputFormatters: [
                            BlacklistingTextInputFormatter(
                                RegExp('[\\-|\\ |\\,]'))
                          ],
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text('XMR:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryTextTheme.title.color,
                                )),
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      ' / ' + balanceStore.unlockedBalance,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).primaryTextTheme.caption.color
                                      )
                                  ),
                                ),
                                Container(
                                  height: 34,
                                  width: 34,
                                  margin: EdgeInsets.only(left: 12, bottom: 7, top: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentTextTheme.headline.decorationColor,
                                    borderRadius: BorderRadius.all(Radius.circular(6))
                                  ),
                                  child: InkWell(
                                    onTap: () => sendStore.setSendAll(),
                                    child: Center(
                                      child: Text(S.of(context).all,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).primaryTextTheme.caption.color
                                          )
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          hintText: '0.0000',
                          borderColor: Theme.of(context).primaryTextTheme.display4.decorationColor,
                          validator: (value) {
                            sendStore.validateXMR(
                                value, balanceStore.unlockedBalance);
                            return sendStore.errorMessage;
                          }
                        )
                      );
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: BaseTextFormField(
                      controller: _fiatAmountController,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      inputFormatters: [
                        BlacklistingTextInputFormatter(
                            RegExp('[\\-|\\ |\\,]'))
                      ],
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                            '${settingsStore.fiatCurrency.toString()}:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryTextTheme.title.color,
                            )),
                      ),
                      hintText: '0.00',
                      borderColor: Theme.of(context).primaryTextTheme.display4.decorationColor,
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(S.of(context).send_estimated_fee,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryTextTheme.title.color,
                            )),
                        Text(
                            '${calculateEstimatedFee(priority: settingsStore.transactionPriority)} XMR',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryTextTheme.title.color,
                            ))
                      ],
                    ),
                  )
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 32,
                left: 24,
                bottom: 24
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).send_templates,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryTextTheme.caption.color
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              padding: EdgeInsets.only(left: 24),
              child: Observer(
                builder: (_) {
                  final templates = sendTemplateStore.templates;
                  final itemCount = templates.length + 1;

                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {

                        if (index == 0) {
                          return GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(Routes.sendTemplate),
                            child: Container(
                              padding: EdgeInsets.only(right: 10),
                              child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  dashPattern: [8, 4],
                                  color: Theme.of(context).accentTextTheme.title.backgroundColor,
                                  strokeWidth: 2,
                                  radius: Radius.circular(20),
                                  child: Container(
                                    height: 40,
                                    width: 75,
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      color: Colors.transparent,
                                    ),
                                    child: Text(
                                      S.of(context).send_new,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryTextTheme.caption.color
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          );
                        }

                        index -= 1;

                        final template = templates[index];

                        return TemplateTile(
                          key: UniqueKey(),
                          to: template.name,
                          amount: template.amount,
                          from: template.cryptoCurrency,
                          onTap: () {
                            _addressController.text = template.address;
                            _cryptoAmountController.text = template.amount;
                            getOpenaliasRecord(context);
                          },
                          onRemove: () {
                            showDialog<void>(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertWithTwoActions(
                                      alertTitle: S.of(context).template,
                                      alertContent: S.of(context).confirm_delete_template,
                                      leftButtonText: S.of(context).delete,
                                      rightButtonText: S.of(context).cancel,
                                      actionLeftButton: () {
                                        Navigator.of(dialogContext).pop();
                                        sendTemplateStore.remove(template: template);
                                        sendTemplateStore.update();
                                      },
                                      actionRightButton: () => Navigator.of(dialogContext).pop()
                                  );
                                }
                            );
                          },
                        );
                      }
                  );
                }
              ),
            )
          ],
        ),
        bottomSectionPadding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        bottomSection: Observer(builder: (_) {
          return LoadingPrimaryButton(
              onPressed: syncStore.status is SyncedSyncStatus
                  ? () async {
                await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');

                if (_formKey.currentState.validate()) {
                  await showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertWithTwoActions(
                          alertTitle: S.of(context).send_creating_transaction,
                          alertContent: S.of(context).confirm_sending,
                          leftButtonText: S.of(context).send,
                          rightButtonText: S.of(context).cancel,
                          actionLeftButton: () async {
                            await Navigator.of(dialogContext)
                                .popAndPushNamed(Routes.auth,
                                arguments: (bool
                                isAuthenticatedSuccessfully,
                                    AuthPageState auth) {
                                  if (!isAuthenticatedSuccessfully) {
                                    return;
                                  }

                                  Navigator.of(auth.context).pop();

                                  sendStore.createTransaction(
                                      address: _addressController.text,
                                      paymentId: '');
                                });
                          },
                          actionRightButton: () =>
                              Navigator.of(context).pop()
                        );
                      });
                }
              }
              : null,
              text: S.of(context).send,
              color: Colors.blue,
              textColor: Colors.white,
              isLoading: sendStore.state is CreatingTransaction ||
                  sendStore.state is TransactionCommiting,
              isDisabled: !(syncStore.status is SyncedSyncStatus),
          );
        }),
      ),
    );
  }

  void _setEffects(BuildContext context) {
    if (_effectsInstalled) {
      return;
    }

    final sendStore = Provider.of<SendStore>(context);

    reaction((_) => sendStore.fiatAmount, (String amount) {
      if (amount != _fiatAmountController.text) {
        _fiatAmountController.text = amount;
      }
    });

    reaction((_) => sendStore.cryptoAmount, (String amount) {
      if (amount != _cryptoAmountController.text) {
        _cryptoAmountController.text = amount;
      }
    });

    reaction((_) => sendStore.address, (String address) {
      if (address != _addressController.text) {
        _addressController.text = address;
      }
    });

    _addressController.addListener(() {
      final address = _addressController.text;

      if (sendStore.address != address) {
        sendStore.changeAddress(address);
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

    reaction((_) => sendStore.state, (SendingState state) {
      if (state is SendingFailed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertWithOneAction(
                  alertTitle: S.of(context).error,
                  alertContent: state.error,
                  buttonText: S.of(context).ok,
                  buttonAction: () => Navigator.of(context).pop()
                );
              });
        });
      }

      if (state is TransactionCreatedSuccessfully) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
          showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return ConfirmSendingAlert(
                    alertTitle: S.of(context).confirm_sending,
                    amount: S.of(context).send_amount,
                    amountValue: sendStore.pendingTransaction.amount,
                    fee: S.of(context).send_fee,
                    feeValue: sendStore.pendingTransaction.fee,
                    leftButtonText: S.of(context).ok,
                    rightButtonText: S.of(context).cancel,
                    actionLeftButton: () {
                      Navigator.of(dialogContext).pop();
                      sendStore.commitTransaction();
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return SendingAlert(sendStore: sendStore);
                        }
                      );
                    },
                    actionRightButton: () => Navigator.of(dialogContext).pop()
                );
              });
        });
      }

      if (state is TransactionCommitted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _addressController.text = '';
          _cryptoAmountController.text = '';
          SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
        });
      }
    });

    _effectsInstalled = true;
  }
}
