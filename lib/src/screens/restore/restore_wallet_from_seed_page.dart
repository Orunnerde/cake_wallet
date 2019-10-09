import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/stores/wallet_restoration/wallet_restoration_store.dart';
import 'package:cake_wallet/src/stores/wallet_restoration/wallet_restoration_state.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/widgets/blockchain_height_widget.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

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
  final _blockchainHeightKey = GlobalKey<BlockchainHeightState>();
  final _nameController = TextEditingController();
  final _seedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletRestorationStore = Provider.of<WalletRestorationStore>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

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
                BlockchainHeightWidget(key: _blockchainHeightKey),
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
                                      restoreHeight: _blockchainHeightKey
                                          .currentState.height);
                                }
                              },
                              isLoading: walletRestorationStore.state
                                  is WalletIsRestoring,
                              text: 'Recover',
                            color: _isDarkTheme ? PaletteDark.darkThemePurpleButton
                                : Palette.purple,
                            borderColor: _isDarkTheme ? PaletteDark.darkThemeViolet
                                : Palette.deepPink,
                          );
                        })))
              ],
            ),
          )),
    );
  }
}
