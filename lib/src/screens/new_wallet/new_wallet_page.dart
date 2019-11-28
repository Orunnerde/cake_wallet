import 'package:cake_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/stores/wallet_creation/wallet_creation_store.dart';
import 'package:cake_wallet/src/stores/wallet_creation/wallet_creation_state.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/theme_changer.dart';

class NewWalletPage extends BasePage {
  final WalletListService walletsService;
  final WalletService walletService;
  final SharedPreferences sharedPreferences;

  String get title => 'New Wallet';

  NewWalletPage(
      {@required this.walletsService,
      @required this.walletService,
      @required this.sharedPreferences});

  @override
  Widget body(BuildContext context) => WalletNameForm();
}

class WalletNameForm extends StatefulWidget {
  @override
  createState() => _WalletNameFormState();
}

class _WalletNameFormState extends State<WalletNameForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletCreationStore = Provider.of<WalletCreationStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    reaction((_) => walletCreationStore.state, (state) {
      if (state is WalletCreatedSuccessfully) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      if (state is WalletCreationFailure) {
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
        content: Column(children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Image.asset('assets/images/bitmap.png',
                height: 224, width: 400),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 24.0,
                      color: _isDarkTheme
                          ? PaletteDark.wildDarkBlueWithOpacity
                          : Colors.black),
                  controller: nameController,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontSize: 24.0,
                          color: _isDarkTheme
                              ? PaletteDark.wildDarkBlueWithOpacity
                              : Palette.lightBlue),
                      hintText: 'Wallet name',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _isDarkTheme
                                  ? PaletteDark.darkThemeGrey
                                  : Palette.lightGrey,
                              width: 1.0)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _isDarkTheme
                                  ? PaletteDark.darkThemeGrey
                                  : Palette.lightGrey,
                              width: 1.0))),
                  validator: (value) {
                    walletCreationStore.validateWalletName(value);
                    return walletCreationStore.errorMessage;
                  },
                )),
          )
        ]),
        bottomSection: Observer(
          builder: (context) {
            return LoadingPrimaryButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  walletCreationStore.create(name: nameController.text);
                }
              },
              text: 'Continue',
              color: _isDarkTheme
                  ? PaletteDark.darkThemePurpleButton
                  : Palette.purple,
              borderColor: _isDarkTheme
                  ? PaletteDark.darkThemePurpleButtonBorder
                  : Palette.deepPink,
              isLoading: walletCreationStore.state is WalletIsCreating,
            );
          },
        ));
  }
}
