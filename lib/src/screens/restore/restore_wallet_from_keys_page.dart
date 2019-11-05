import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/stores/wallet_restoration/wallet_restoration_store.dart';
import 'package:cake_wallet/src/stores/wallet_restoration/wallet_restoration_state.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/widgets/blockchain_height_widget.dart';
import 'package:cake_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/stores/validation/validation_store.dart';

class RestoreWalletFromKeysPage extends BasePage {
  final WalletListService walletsService;
  final WalletService walletService;
  final SharedPreferences sharedPreferences;

  String get title => 'Restore from keys';

  RestoreWalletFromKeysPage(
      {@required this.walletsService,
      @required this.sharedPreferences,
      @required this.walletService});

  @override
  Widget body(BuildContext context) => RestoreFromKeysFrom();
}

class RestoreFromKeysFrom extends StatefulWidget {
  @override
  createState() => _RestoreFromKeysFromState();
}

class _RestoreFromKeysFromState extends State<RestoreFromKeysFrom> {
  final _formKey = GlobalKey<FormState>();
  final _blockchainHeightKey = GlobalKey<BlockchainHeightState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _viewKeyController = TextEditingController();
  final _spendKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletRestorationStore = Provider.of<WalletRestorationStore>(context);
    final validation = Provider.of<ValidationStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme)
      _isDarkTheme = true;
    else
      _isDarkTheme = false;

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

    return ScrollableWithBottomSection(
      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 13, right: 13),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14.0),
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeGrey
                                    : Palette.lightBlue),
                            hintText: 'Wallet name',
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
                          validation.validateWalletName(value);
                          if (!validation.isValidate) return 'Wallet name can only contain letters, '
                              'numbers\nand must be between 1 and 15 characters long';
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
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14.0),
                        controller: _addressController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeGrey
                                    : Palette.lightBlue),
                            hintText: 'Address',
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
                          validation.validateAddress(value);
                          if (!validation.isValidate) return 'Wallet address must correspond to the type of cryptocurrency';
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
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14.0),
                        controller: _viewKeyController,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeGrey
                                    : Palette.lightBlue),
                            hintText: 'View key (private)',
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
                          validation.validateKeys(value);
                          if (!validation.isValidate) return 'Wallet keys can only contain 64 chars in hex';
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
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14.0),
                        controller: _spendKeyController,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: _isDarkTheme
                                    ? PaletteDark.darkThemeGrey
                                    : Palette.lightBlue),
                            hintText: 'Spend key (private)',
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
                          validation.validateKeys(value);
                          if (!validation.isValidate) return 'Wallet keys can only contain 64 chars in hex';
                          return null;
                        },
                      ),
                    ))
                  ],
                ),
                BlockchainHeightWidget(key: _blockchainHeightKey),
              ]),
            )
          ],
        ),
      ),
      bottomSection: Observer(builder: (_) {
        return LoadingPrimaryButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              walletRestorationStore.restoreFromKeys(
                  name: _nameController.text,
                  address: _addressController.text,
                  viewKey: _viewKeyController.text,
                  spendKey: _spendKeyController.text,
                  restoreHeight: _blockchainHeightKey.currentState.height);
            }
          },
          text: 'Recover',
          color:
              _isDarkTheme ? PaletteDark.darkThemePurpleButton : Palette.purple,
          borderColor: _isDarkTheme
              ? PaletteDark.darkThemePurpleButtonBorder
              : Palette.deepPink,
        );
      }),
    );
  }
}
