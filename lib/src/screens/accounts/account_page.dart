import 'package:cake_wallet/src/stores/account_list/account_list_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'dart:ui';

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

class AccountFormState extends State<AccountForm> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  bool isBlurred = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.suspending) {
      setState(() {
        isBlurred = true;
      });
    }
    if (state == AppLifecycleState.resumed) {
      setState(() {
        isBlurred = false;
      });
    }
    print('isBlurred  = $isBlurred');
    print('state = $state');
  }

  @override
  Widget build(BuildContext context) {
    final accountListStore = Provider.of<AccountListStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
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
                            // FIXME: Replace validation logic
                            String p = '[^ ]';
                            RegExp regExp = new RegExp(p);
                            if (regExp.hasMatch(value))
                              return null;
                            else
                              return 'Please enter a name of account';
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
            isBlurred ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ) : Offstage(),
          ],
        )
    );
  }
}
