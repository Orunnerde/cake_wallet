import 'package:cake_wallet/src/widgets/scollable_with_bottom_section.dart';
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
import 'package:cake_wallet/src/stores/send/send_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/src/widgets/top_panel.dart';
import 'package:cake_wallet/src/stores/send_template/send_template_store.dart';
import 'package:cake_wallet/src/widgets/base_text_form_field.dart';

class SendTemplatePage extends BasePage {
  @override
  String get title => S.current.exchange_new_template;

  @override
  Color get backgroundLightColor => Palette.lavender;

  @override
  Color get backgroundDarkColor => PaletteDark.lightNightBlue;

  @override
  bool get resizeToAvoidBottomPadding => false;

  @override
  Widget body(BuildContext context) => SendTemplateForm();
}

class SendTemplateForm extends StatefulWidget {
  @override
  SendTemplateFormState createState() => SendTemplateFormState();
}

class SendTemplateFormState extends State<SendTemplateForm> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cryptoAmountController = TextEditingController();
  final _fiatAmountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _effectsInstalled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cryptoAmountController.dispose();
    _fiatAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);
    final balanceStore = Provider.of<BalanceStore>(context);
    final sendStore = Provider.of<SendStore>(context);
    sendStore.settingsStore = settingsStore;
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
                  BaseTextFormField(
                    controller: _nameController,
                    hintText: S.of(context).send_name,
                    validator: (value) {
                      sendTemplateStore.validateTemplate(value);
                      return sendTemplateStore.errorMessage;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: AddressTextField(
                      controller: _addressController,
                      placeholder: S.of(context).send_monero_address,
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
                      validator: (value) {
                        sendTemplateStore.validateTemplate(value);
                        return sendTemplateStore.errorMessage;
                      },
                    ),
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
                                )
                              ),
                            ),
                            hintText: '0.0000',
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
                          )
                        ),
                      ),
                      hintText: '0.00',
                    )
                  ),
                ]),
              ),
            ),
          ],
        ),
        bottomSectionPadding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        bottomSection: PrimaryButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              sendTemplateStore.addTemplate(
                name: _nameController.text,
                address: _addressController.text,
                cryptoCurrency: 'XMR',
                amount: _cryptoAmountController.text
              );
              sendTemplateStore.update();
              Navigator.of(context).pop();
            }
          },
          text: S.of(context).save,
          color: Colors.green,
          textColor: Colors.white
        ),
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

    _effectsInstalled = true;
  }
}