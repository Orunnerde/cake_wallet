import 'package:cake_wallet/src/stores/account_list/account_list_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/stores/validation/validation_store.dart';

class AccountPage extends BasePage {
  String get title => 'Account';

  @override
  Widget body(BuildContext context) => AccountForm();

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Scaffold(
        backgroundColor: _isDarkTheme ? PaletteDark.darkThemeBackgroundDark
            : Colors.white,
        resizeToAvoidBottomPadding: false,
        appBar: CupertinoNavigationBar(
          leading: leading(context),
          middle: middle(context),
          trailing: trailing(context),
          backgroundColor: _isDarkTheme ? PaletteDark.darkThemeBackgroundDark
              : Colors.white,
          border: null,
        ),
        body: SafeArea(child: body(context)));
  }
}

class AccountForm extends StatefulWidget {
  @override
  createState() => AccountFormState();
}

class AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountListStore = Provider.of<AccountListStore>(context);
    final validation = Provider.of<ValidationStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: _isDarkTheme ? PaletteDark.darkThemeGrey
                            : Palette.lightBlue
                    ),
                    hintText: 'Account',
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(
                                color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                    : Palette.lightGrey,
                                width: 1.0
                            )),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(
                                color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                    : Palette.lightGrey,
                                width: 1.0
                            ))),
                controller: _textController,
                validator: (value) {
                  validation.validateWalletName(value);
                  if (!validation.isValidate) return 'Account name can only contain letters, '
                      'numbers\nand must be between 1 and 15 characters long';
                  return null;
                },
              ),
            )),
            PrimaryButton(
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  await accountListStore.addAccount(
                      label: _textController.text);
                  Navigator.pop(context, _textController.text);
                },
                text: 'Add',
              color: _isDarkTheme ? PaletteDark.darkThemePurpleButton
                  : Palette.purple,
              borderColor: _isDarkTheme ? PaletteDark.darkThemePurpleButtonBorder
                  : Palette.deepPink,
            )
          ],
        ),
      ),
    );
  }
}
