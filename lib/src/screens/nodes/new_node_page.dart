import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/stores/node_list/node_list_store.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/generated/i18n.dart';

class NewNodePage extends BasePage {
  @override
  String get title => S.current.node_new;

  @override
  Widget body(BuildContext context) => NewNodePageForm();
}

class NewNodePageForm extends StatefulWidget {
  @override
  createState() => NewNodeFormState();
}

class NewNodeFormState extends State<NewNodePageForm> {
  final _formKey = GlobalKey<FormState>();
  final _nodeAddressController = TextEditingController();
  final _nodePortController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nodeAddressController.dispose();
    _nodePortController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodeList = Provider.of<NodeListStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 38.0, right: 38.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Palette.wildDarkBlue),
                                hintText: S.of(context).node_address,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0))),
                            controller: _nodeAddressController,
                            validator: (value) {
                              nodeList.validateNodeAddress(value);
                              return nodeList.errorMessage;
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(fontSize: 14.0),
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                            decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Palette.wildDarkBlue),
                                hintText: S.of(context).node_port,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0))),
                            controller: _nodePortController,
                            validator: (value) {
                              nodeList.validateNodePort(value);
                              return nodeList.errorMessage;
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Palette.wildDarkBlue),
                                hintText: S.of(context).login,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0))),
                            controller: _loginController,
                            validator: (value) => null,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Palette.wildDarkBlue),
                                hintText: S.of(context).password,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isDarkTheme ? PaletteDark.darkThemeGreyWithOpacity
                                            : Palette.lightGrey,
                                        width: 1.0))),
                            controller: _passwordController,
                            validator: (value) => null,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: Container(
                    padding: EdgeInsets.only(right: 8.0),
                    child: PrimaryButton(
                      onPressed: () {
                        _nodeAddressController.text = '';
                        _nodePortController.text = '';
                        _loginController.text = '';
                        _passwordController.text = '';
                      },
                      text: S.of(context).reset,
                      color: _isDarkTheme ? PaletteDark.darkThemeIndigoButton
                          : Palette.indigo,
                      borderColor: _isDarkTheme ? PaletteDark.darkThemeIndigoButtonBorder
                          : Palette.deepIndigo,
                    ),
                  )),
                  Flexible(
                      child: Container(
                    padding: EdgeInsets.only(left: 8.0),
                    child: PrimaryButton(
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          await nodeList.addNode(
                              address: _nodeAddressController.text,
                              port: _nodePortController.text,
                              login: _loginController.text,
                              password: _passwordController.text);

                          Navigator.of(context).pop();

                          // _isSaved = await showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       Future.delayed(
                          //           const Duration(milliseconds: 500),
                          //           () {
                          //         Navigator.pop(context, true);
                          //       });
                          //       return AlertDialog(
                          //           title: Text(
                          //             'Saving',
                          //             textAlign: TextAlign.center,
                          //           ),
                          //           content: CupertinoActivityIndicator(
                          //               animating: true));
                          //     });

                          // if (_isSaved) {
                          //   _nodeAddress = _nodeAddressController.text;
                          //   await showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return AlertDialog(
                          //           title: Text(
                          //             'Saved',
                          //             textAlign: TextAlign.center,
                          //           ),
                          //           actions: <Widget>[
                          //             FlatButton(
                          //                 onPressed: () {
                          //                   Navigator.pop(context);
                          //                 },
                          //                 child: Text('OK'))
                          //           ],
                          //         );
                          //       });
                          // }
                          // }
                        },
                        text: S.of(context).save,
                        color: _isDarkTheme ? PaletteDark.darkThemePurpleButton
                            : Palette.purple,
                        borderColor: _isDarkTheme ? PaletteDark.darkThemePurpleButtonBorder
                            : Palette.deepPink,
                    ),
                  )),
                ],
              ),
            )
          ],
        ));
  }
}
