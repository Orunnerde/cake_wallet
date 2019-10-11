import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/stores/node_list/node_list_store.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class NewNodePage extends StatefulWidget {
  @override
  createState() => NewNodeState();
}

class NewNodeState extends State<NewNodePage> {
  final _formKey = GlobalKey<FormState>();
  final _backArrowImage = Image.asset('assets/images/back_arrow.png');
  final _backArrowImageDarkTheme = Image.asset('assets/images/back_arrow_dark_theme.png');
  final _nodeAddressController = TextEditingController();
  final _nodePortController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  String _nodeAddress;
  bool _isSaved = false;

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

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
              onPressed: () {
                Navigator.pop(context, _isSaved ? _nodeAddress : null);
              },
              child: _isDarkTheme ? _backArrowImageDarkTheme : _backArrowImage),
        ),
        middle: Text(
          'New Node',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: _isDarkTheme ? PaletteDark.darkThemeTitle : Colors.black
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        border: null,
      ),
      body: SafeArea(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(38.0),
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
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Palette.wildDarkBlue,
                                      ),
                                      hintText: 'Node Address',
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
                                    String p = '[^ ]';
                                    RegExp regExp = new RegExp(p);
                                    if (regExp.hasMatch(value))
                                      return null;
                                    else
                                      return 'Please enter a node address';
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
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Palette.wildDarkBlue),
                                      hintText: 'Node port',
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
                                    return null;
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
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Palette.wildDarkBlue),
                                      hintText: 'Login',
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
                                  validator: (value) {
                                    return null;
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
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Palette.wildDarkBlue),
                                      hintText: 'Password',
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
                                  validator: (value) {
                                    return null;
                                  },
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
                              _isSaved = false;
                              _nodeAddressController.text = '';
                              _nodePortController.text = '';
                              _loginController.text = '';
                              _passwordController.text = '';
                            },
                            text: 'Reset',
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
                              text: 'Save',
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
              ))),
    );
  }
}
