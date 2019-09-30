import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/transaction_priority.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/settings/change_language.dart';
import 'package:cake_wallet/src/screens/disclaimer/disclaimer_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Settings extends StatefulWidget {
  @override
  createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();

  final _cakeArrowImage = Image.asset('assets/images/cake_arrow.png');
  final _telegramImage = Image.asset('assets/images/Telegram.png');
  final _twitterImage = Image.asset('assets/images/Twitter.png');
  final _changeNowImage = Image.asset('assets/images/change_now.png');
  final _morphImage = Image.asset('assets/images/morph_icon.png');
  final _xmrBtcImage = Image.asset('assets/images/xmr_btc.png');

  bool _isSaveRecipientAddressOn = false;
  bool _isAllowBiometricalAuthenticationOn = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);

    return Scaffold(
      backgroundColor: Palette.lightGrey2,
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
        leading: Offstage(),
        middle: Text(
          'Settings',
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: Palette.lightGrey2,
        border: null,
      ),
      body: Container(
        padding: EdgeInsets.only(
            //top: 20.0,
            //bottom: 20.0
            ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Nodes',
                      style: TextStyle(
                          fontSize: 15.0, color: Palette.wildDarkBlue),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed(Routes.nodeList),
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                    title: Text(
                      'Current node',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    trailing: Observer(
                        builder: (_) => Text(
                              settingsStore.node == null
                                  ? ''
                                  : settingsStore.node.uri,
                              // widget.currentNode,
                              style: TextStyle(
                                  fontSize: 16.0, color: Palette.wildDarkBlue),
                            )),
                  ),
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Wallets',
                      style: TextStyle(
                          fontSize: 15.0, color: Palette.wildDarkBlue),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Text(
                        'Display balance as',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: Observer(
                          builder: (_) => Text(
                                settingsStore.balanceDisplayMode.toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Palette.wildDarkBlue),
                              )),
                      onTap: () {
                        _setBalance(context);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Text(
                        'Currency',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: Observer(
                          builder: (_) => Text(
                                settingsStore.fiatCurrency.toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Palette.wildDarkBlue),
                              )),
                      onTap: () => _setCurrency(context),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Text(
                        'Fee priority',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: Observer(
                          builder: (_) => Text(
                                settingsStore.transactionPriority.toString(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Palette.wildDarkBlue),
                              )),
                      onTap: () => _setTransactionPriority(context),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                        contentPadding:
                            EdgeInsets.only(left: 20.0, right: 20.0),
                        title: Text(
                          'Save recipient address',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSaveRecipientAddressOn =
                                  !_isSaveRecipientAddressOn;
                            });
                          },
                          child: AnimatedContainer(
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            alignment: _isSaveRecipientAddressOn
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            duration: Duration(milliseconds: 250),
                            width: 55.0,
                            height: 33.0,
                            decoration: BoxDecoration(
                                color: Palette.switchBackground,
                                border: Border.all(color: Palette.switchBorder),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Container(
                              width: 25.0,
                              height: 25.0,
                              decoration: BoxDecoration(
                                  color: _isSaveRecipientAddressOn
                                      ? Palette.cakeGreen
                                      : Palette.wildDarkBlue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Icon(
                                _isSaveRecipientAddressOn
                                    ? Icons.check
                                    : Icons.close,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Personal',
                      style: TextStyle(
                          fontSize: 15.0, color: Palette.wildDarkBlue),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Text(
                        'Change PIN',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: _cakeArrowImage,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Routes.auth, arguments: [
                          (auth) => Navigator.of(context).popAndPushNamed(
                              Routes.setupPin,
                              arguments: (setupPinContext, _) =>
                                  Navigator.of(context).pop())
                        ]);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Text(
                        'Change language',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: _cakeArrowImage,
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    ChangeLanguage()));
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                        contentPadding:
                            EdgeInsets.only(left: 20.0, right: 20.0),
                        title: Text(
                          'Allow biometrical authentication',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAllowBiometricalAuthenticationOn =
                                  !_isAllowBiometricalAuthenticationOn;
                            });
                          },
                          child: AnimatedContainer(
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            alignment: _isAllowBiometricalAuthenticationOn
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            duration: Duration(milliseconds: 250),
                            width: 55.0,
                            height: 33.0,
                            decoration: BoxDecoration(
                                color: Palette.switchBackground,
                                border: Border.all(color: Palette.switchBorder),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Container(
                              width: 25.0,
                              height: 25.0,
                              decoration: BoxDecoration(
                                  color: _isAllowBiometricalAuthenticationOn
                                      ? Palette.cakeGreen
                                      : Palette.wildDarkBlue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Icon(
                                _isAllowBiometricalAuthenticationOn
                                    ? Icons.check
                                    : Icons.close,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              // Container(
              //   padding: EdgeInsets.only(left: 20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: <Widget>[
              //       Text(
              //         'Backup',
              //         style: TextStyle(
              //             fontSize: 15.0, color: Palette.wildDarkBlue),
              //       )
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 14.0,
              // ),
              // Container(
              //   color: Colors.white,
              //   child: Column(
              //     children: <Widget>[
              //       ListTile(
              //         contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
              //         title: Text(
              //           'Show backup password',
              //           style: TextStyle(fontSize: 16.0),
              //         ),
              //         trailing: _cakeArrowImage,
              //         onTap: () async {
              //           var _isPinCorrect = await Navigator.push(
              //               context,
              //               CupertinoPageRoute(
              //                   builder: (BuildContext context) => EnterPinCode(
              //                       widget.currentPinLength,
              //                       widget.currentPin)));
              //           if (_isPinCorrect != null && _isPinCorrect) {
              //             _showBackupPasswordAlertDialog(context);
              //           }
              //         },
              //       ),
              //       Container(
              //         padding: EdgeInsets.only(
              //           left: 20.0,
              //           right: 20.0,
              //         ),
              //         child: Divider(
              //           color: Palette.lightGrey,
              //           height: 1.0,
              //         ),
              //       ),
              //       ListTile(
              //         contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
              //         title: Text(
              //           'Change backup password',
              //           style: TextStyle(fontSize: 16.0),
              //         ),
              //         trailing: _cakeArrowImage,
              //         onTap: () async {
              //           _newPasswordController.text = '';

              //           var _isChange = await showDialog(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return AlertDialog(
              //                   title: Text(
              //                     'Backup password',
              //                     textAlign: TextAlign.center,
              //                   ),
              //                   content: Text(
              //                     'If you will change the Backup password for backups, '
              //                     'the previous MANUAL backups will not work with the new password. '
              //                     'Auto backups will continue to work with the new password.',
              //                     textAlign: TextAlign.center,
              //                   ),
              //                   actions: <Widget>[
              //                     FlatButton(
              //                         onPressed: () {
              //                           Navigator.pop(context, false);
              //                         },
              //                         child: Text('Cancel')),
              //                     FlatButton(
              //                         onPressed: () {
              //                           Navigator.pop(context, true);
              //                         },
              //                         child: Text('Change')),
              //                   ],
              //                 );
              //               });

              //           if (_isChange != null && _isChange) {
              //             var _isPinCorrect = await Navigator.push(
              //                 context,
              //                 CupertinoPageRoute(
              //                     builder: (BuildContext context) =>
              //                         EnterPinCode(widget.currentPinLength,
              //                             widget.currentPin)));

              //             if (_isPinCorrect != null && _isPinCorrect) {
              //               var _isOK = await showDialog(
              //                   context: context,
              //                   builder: (BuildContext context) {
              //                     return AlertDialog(
              //                       title: Text(
              //                         'Change/Set master password',
              //                         textAlign: TextAlign.center,
              //                       ),
              //                       content: Form(
              //                         key: _formKey,
              //                         child: Column(
              //                           mainAxisSize: MainAxisSize.min,
              //                           children: <Widget>[
              //                             Text(
              //                               'Enter new password',
              //                               textAlign: TextAlign.center,
              //                             ),
              //                             SizedBox(
              //                               height: 20.0,
              //                             ),
              //                             TextFormField(
              //                               decoration: InputDecoration(
              //                                   border: OutlineInputBorder(
              //                                       borderSide: BorderSide(
              //                                           color: Palette
              //                                               .lightGrey))),
              //                               controller: _newPasswordController,
              //                               validator: (value) {
              //                                 String p = '[^ ]';
              //                                 RegExp regExp = new RegExp(p);
              //                                 if (regExp.hasMatch(value))
              //                                   return null;
              //                                 else
              //                                   return 'Please enter a new password';
              //                               },
              //                             )
              //                           ],
              //                         ),
              //                       ),
              //                       actions: <Widget>[
              //                         FlatButton(
              //                             onPressed: () {
              //                               Navigator.pop(context, false);
              //                             },
              //                             child: Text('Generate new')),
              //                         FlatButton(
              //                             onPressed: () {
              //                               if (_formKey.currentState
              //                                   .validate()) {
              //                                 Navigator.pop(context, true);
              //                               }
              //                             },
              //                             child: Text('OK')),
              //                       ],
              //                     );
              //                   });

              //               if (_isOK != null && _isOK) {
              //                 await showDialog(
              //                     context: context,
              //                     builder: (BuildContext context) {
              //                       return AlertDialog(
              //                         title: Text(
              //                           'Backup password',
              //                           textAlign: TextAlign.center,
              //                         ),
              //                         content: Text(
              //                           'Backup password has changed successfuly.',
              //                           textAlign: TextAlign.center,
              //                         ),
              //                         actions: <Widget>[
              //                           FlatButton(
              //                               onPressed: () {
              //                                 Navigator.pop(context);
              //                               },
              //                               child: Text('OK')),
              //                         ],
              //                       );
              //                     });
              //               }
              //             }
              //           }
              //         },
              //       ),
              //       Container(
              //         padding: EdgeInsets.only(
              //           left: 20.0,
              //           right: 20.0,
              //         ),
              //         child: Divider(
              //           color: Palette.lightGrey,
              //           height: 1.0,
              //         ),
              //       ),
              //       ListTile(
              //           contentPadding:
              //               EdgeInsets.only(left: 20.0, right: 20.0),
              //           title: Text(
              //             'Auto backup to Cloud',
              //             style: TextStyle(fontSize: 16.0),
              //           ),
              //           trailing: GestureDetector(
              //             onTap: () {
              //               setState(() {
              //                 _isAutoBackupToCloudOn = !_isAutoBackupToCloudOn;
              //               });
              //             },
              //             child: AnimatedContainer(
              //               padding: EdgeInsets.only(left: 4.0, right: 4.0),
              //               alignment: _isAutoBackupToCloudOn
              //                   ? Alignment.centerRight
              //                   : Alignment.centerLeft,
              //               duration: Duration(milliseconds: 250),
              //               width: 55.0,
              //               height: 33.0,
              //               decoration: BoxDecoration(
              //                   color: Palette.switchBackground,
              //                   border: Border.all(color: Palette.switchBorder),
              //                   borderRadius:
              //                       BorderRadius.all(Radius.circular(10.0))),
              //               child: Container(
              //                 width: 25.0,
              //                 height: 25.0,
              //                 decoration: BoxDecoration(
              //                     color: _isAutoBackupToCloudOn
              //                         ? Palette.cakeGreen
              //                         : Palette.wildDarkBlue,
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(8.0))),
              //                 child: Icon(
              //                   _isAutoBackupToCloudOn
              //                       ? Icons.check
              //                       : Icons.close,
              //                   color: Colors.white,
              //                   size: 16.0,
              //                 ),
              //               ),
              //             ),
              //           )),
              //       Container(
              //         padding: EdgeInsets.only(
              //           left: 20.0,
              //           right: 20.0,
              //         ),
              //         child: Divider(
              //           color: Palette.lightGrey,
              //           height: 1.0,
              //         ),
              //       ),
              //       ListTile(
              //         contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
              //         title: Text(
              //           'Backup now to Cloud',
              //           style: TextStyle(fontSize: 16.0),
              //         ),
              //         trailing: _cakeArrowImage,
              //         onTap: () async {
              //           var _pushedButton = await showDialog(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return AlertDialog(
              //                   title: Text(
              //                     'Backup',
              //                     textAlign: TextAlign.center,
              //                   ),
              //                   content: Text(
              //                     'Did you save your backup password?',
              //                     textAlign: TextAlign.center,
              //                   ),
              //                   actions: <Widget>[
              //                     FlatButton(
              //                         onPressed: () {
              //                           Navigator.pop(context, 1);
              //                         },
              //                         child: Text('Yes')),
              //                     FlatButton(
              //                         onPressed: () {
              //                           Navigator.pop(context, 2);
              //                         },
              //                         child: Text('Show password')),
              //                     FlatButton(
              //                         onPressed: () {
              //                           Navigator.pop(context, 3);
              //                         },
              //                         child: Text('Cancel')),
              //                   ],
              //                 );
              //               });

              //           if (_pushedButton != null) {
              //             switch (_pushedButton) {
              //               case 1:
              //                 await showDialog(
              //                     context: context,
              //                     builder: (BuildContext context) {
              //                       Future.delayed(
              //                           const Duration(milliseconds: 500), () {
              //                         Navigator.pop(context, true);
              //                       });
              //                       return AlertDialog(
              //                           title: Text(
              //                             'Creating backup',
              //                             textAlign: TextAlign.center,
              //                           ),
              //                           content: CupertinoActivityIndicator(
              //                               animating: true));
              //                     });

              //                 await showDialog(
              //                     context: context,
              //                     builder: (BuildContext context) {
              //                       return AlertDialog(
              //                         title: Text(
              //                           'Backup uploaded',
              //                           textAlign: TextAlign.center,
              //                         ),
              //                         content: Text(
              //                           'Backup has uploaded to your Cloud',
              //                           textAlign: TextAlign.center,
              //                         ),
              //                         actions: <Widget>[
              //                           FlatButton(
              //                               onPressed: () {
              //                                 Navigator.pop(context);
              //                               },
              //                               child: Text('OK'))
              //                         ],
              //                       );
              //                     });

              //                 break;

              //               case 2:
              //                 var _isPinCorrect = await Navigator.push(
              //                     context,
              //                     CupertinoPageRoute(
              //                         builder: (BuildContext context) =>
              //                             EnterPinCode(widget.currentPinLength,
              //                                 widget.currentPin)));

              //                 if (_isPinCorrect != null && _isPinCorrect) {
              //                   _showBackupPasswordAlertDialog(context);
              //                 }
              //             }
              //           }
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 28.0,
              // ),
              // Container(
              //   padding: EdgeInsets.only(left: 20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: <Widget>[
              //       Text(
              //         'Manual backup',
              //         style: TextStyle(
              //             fontSize: 15.0, color: Palette.wildDarkBlue),
              //       )
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 14.0,
              // ),
              // Container(
              //   color: Colors.white,
              //   child: ListTile(
              //     contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
              //     title: Text(
              //       'Save backup file to other location',
              //       style: TextStyle(fontSize: 16.0),
              //     ),
              //     trailing: _cakeArrowImage,
              //     onTap: () async {
              //       var _pushedButton = await showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AlertDialog(
              //               title: Text(
              //                 'Backup',
              //                 textAlign: TextAlign.center,
              //               ),
              //               content: Text(
              //                 'Did you save your backup password?',
              //                 textAlign: TextAlign.center,
              //               ),
              //               actions: <Widget>[
              //                 FlatButton(
              //                     onPressed: () {
              //                       Navigator.pop(context, 1);
              //                     },
              //                     child: Text('Yes')),
              //                 FlatButton(
              //                     onPressed: () {
              //                       Navigator.pop(context, 2);
              //                     },
              //                     child: Text('Show password')),
              //                 FlatButton(
              //                     onPressed: () {
              //                       Navigator.pop(context, 3);
              //                     },
              //                     child: Text('Cancel')),
              //               ],
              //             );
              //           });

              //       if (_pushedButton != null) {
              //         switch (_pushedButton) {
              //           case 1:
              //             Share.share(' ');
              //             break;

              //           case 2:
              //             var _isPinCorrect = await Navigator.push(
              //                 context,
              //                 CupertinoPageRoute(
              //                     builder: (BuildContext context) =>
              //                         EnterPinCode(widget.currentPinLength,
              //                             widget.currentPin)));

              //             if (_isPinCorrect != null && _isPinCorrect) {
              //               _showBackupPasswordAlertDialog(context);
              //             }
              //         }
              //       }
              //     },
              //   ),
              // ),
              // SizedBox(
              //   height: 28.0,
              // ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Support',
                      style: TextStyle(
                          fontSize: 15.0, color: Palette.wildDarkBlue),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.0,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Text(
                        'Email',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      trailing: Text(
                        'support@cakewallet.io',
                        style:
                            TextStyle(fontSize: 14.0, color: Palette.cakeGreen),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _telegramImage,
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Telegram',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      trailing: Text(
                        'support@cakewallet.io',
                        style:
                            TextStyle(fontSize: 14.0, color: Palette.cakeGreen),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _twitterImage,
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Twitter',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      trailing: Text(
                        'support@cakewallet.io',
                        style:
                            TextStyle(fontSize: 14.0, color: Palette.cakeGreen),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _changeNowImage,
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'ChangeNow',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      trailing: Text(
                        'support@changenow.io',
                        style:
                            TextStyle(fontSize: 14.0, color: Palette.cakeGreen),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _morphImage,
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Morph',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      trailing: Text(
                        'contact@morphtoken.com',
                        style:
                            TextStyle(fontSize: 14.0, color: Palette.cakeGreen),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _xmrBtcImage,
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Xmr->BTC',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      trailing: Text(
                        'support@xmr.to',
                        style:
                            TextStyle(fontSize: 14.0, color: Palette.cakeGreen),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                      title: Text(
                        'Terms and conditions',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      trailing: _cakeArrowImage,
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    DisclaimerPage()));
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Divider(
                        color: Palette.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<T> _presentPicker<T extends Object>(
      BuildContext context, List<T> list) async {
    T _value = list[0];

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please select:'),
            content: Container(
              height: 150.0,
              child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 45.0,
                  onSelectedItemChanged: (int index) => _value = list[index],
                  children: List.generate(
                      list.length,
                      (index) => Center(
                            child: Text(list[index].toString()),
                          ))),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(_value),
                  child: Text('OK'))
            ],
          );
        });
  }

  void _setBalance(BuildContext context) async {
    final settingsStore = Provider.of<SettingsStore>(context);
    final selectedDisplayMode =
        await _presentPicker(context, BalanceDisplayMode.all);

    if (selectedDisplayMode != null) {
      settingsStore.setCurrentBalanceDisplayMode(
          balanceDisplayMode: selectedDisplayMode);
    }
  }

  void _setCurrency(BuildContext context) async {
    final settingsStore = Provider.of<SettingsStore>(context);
    final selectedCurrency = await _presentPicker(context, FiatCurrency.all);

    if (selectedCurrency != null) {
      settingsStore.setCurrentFiatCurrency(currency: selectedCurrency);
    }
  }

  void _setTransactionPriority(BuildContext context) async {
    final settingsStore = Provider.of<SettingsStore>(context);
    final selectedPriority =
        await _presentPicker(context, TransactionPriority.all);

    if (selectedPriority != null) {
      settingsStore.setCurrentTransactionPriority(priority: selectedPriority);
    }
  }

  // _showBackupPasswordAlertDialog(BuildContext context) async {
  //   await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(
  //             'Backup password',
  //             textAlign: TextAlign.center,
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text('Cancel')),
  //             FlatButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text('Copy')),
  //           ],
  //         );
  //       });
  // }
}
