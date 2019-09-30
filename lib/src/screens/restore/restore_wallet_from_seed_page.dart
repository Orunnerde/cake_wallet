import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/stores/wallet_restoration/wallet_restoration_store.dart';
import 'package:cake_wallet/src/stores/wallet_restoration/wallet_restoration_state.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class RestoreWalletFromSeedPage extends BasePage {
  final WalletListService walletsService;
  final WalletService walletService;
  final SharedPreferences sharedPreferences;

  String get title => 'Restore from seed';

  RestoreWalletFromSeedPage(
      {@required this.walletsService,
      @required this.walletService,
      @required this.sharedPreferences});

  @override
  Widget body(BuildContext context) => RestoreFromSeedForm();
}

class RestoreFromSeedForm extends StatefulWidget {
  @override
  createState() => _RestoreFromSeedFormState();
}

class _RestoreFromSeedFormState extends State<RestoreFromSeedForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _seedController = TextEditingController();
  final _restoreHeightController = TextEditingController();

  Future _selectDate(BuildContext context) async {
    final DateTime restoreData = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030));
    if (restoreData != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(restoreData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletRestorationStore = Provider.of<WalletRestorationStore>(context);

    reaction((_) => walletRestorationStore.state, (state) {
      if (state is WalletRestoredSuccessfully) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      if (state is WalletRestorationFailure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(state.error),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              });
        });
      }
    });

    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Palette.lightBlue),
                            hintText: 'Wallet name',
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Palette.lightGrey, width: 2.0)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Palette.lightGrey, width: 2.0))),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: TextFormField(
                        controller: _restoreHeightController,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Palette.lightBlue),
                            hintText: 'Restore from blockheight',
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Palette.lightGrey, width: 2.0)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Palette.lightGrey, width: 2.0))),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ))
                  ],
                ),
                Text(
                  'or',
                  style: TextStyle(fontSize: 16.0),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Palette.lightBlue),
                                hintText: 'Restore from date',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Palette.lightGrey, width: 2.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Palette.lightGrey, width: 2.0))),
                            controller: _dateController,
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        controller: _seedController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Palette.lightBlue),
                            hintText: 'Seed',
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Palette.lightGrey, width: 2.0)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Palette.lightGrey, width: 2.0))),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ))
                  ],
                ),
                Flexible(
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Observer(builder: (_) {
                          return LoadingPrimaryButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  walletRestorationStore.restoreFromSeed(
                                      name: _nameController.text,
                                      seed: _seedController.text,
                                      restoreHeight: int.parse(
                                          _restoreHeightController.text));
                                }
                              },
                              isLoading: walletRestorationStore.state
                                  is WalletIsRestoring,
                              text: 'Recover');
                        })))
              ],
            ),
          )),
    );
  }
}
