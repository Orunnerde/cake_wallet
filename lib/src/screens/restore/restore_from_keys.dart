import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/bloc/wallets_manager/wallets_manager.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';

// import 'package:cake_wallet/src/wallets_service.dart';

import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';

class RestoreFromKeys extends StatelessWidget {
  final WalletListService walletsService;
  final WalletService walletService;
  final SharedPreferences sharedPreferences;

  RestoreFromKeys(
      {@required this.walletsService,
      @required this.sharedPreferences,
      @required this.walletService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: CupertinoNavigationBar(
          middle: Text('Restore from keys'),
          backgroundColor: Colors.white,
          border: null,
        ),
        body: BlocProvider(
            builder: (context) => WalletsManagerBloc(
                walletsService: walletsService,
                walletService: walletService,
                sharedPreferences: sharedPreferences),
            child: RestoreFromKeysFrom()));
  }
}

class RestoreFromKeysFrom extends StatefulWidget {
  @override
  createState() => _RestoreFromKeysFromState();
}

class _RestoreFromKeysFromState extends State<RestoreFromKeysFrom> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _viewKeyController = TextEditingController();
  final _spendKeyController = TextEditingController();
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
    final bloc = BlocProvider.of<WalletsManagerBloc>(context);

    return BlocListener(
        bloc: bloc,
        listener: (context, state) {
          if (state is WalletCreatedSuccessfully) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/dashboard', (Route<dynamic> route) => false);
          }

          if (state is WalletCreatedFailed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(state.msg),
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
        },
        child: GestureDetector(
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
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            controller: _addressController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Palette.lightBlue),
                                hintText: 'Address',
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
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            controller: _viewKeyController,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Palette.lightBlue),
                                hintText: 'View key (private)',
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
                          padding: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            controller: _spendKeyController,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Palette.lightBlue),
                                hintText: 'Spend key (private)',
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
                                    hintStyle:
                                        TextStyle(color: Palette.lightBlue),
                                    hintText: 'Restore from date',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0))),
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
                    Flexible(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: BlocBuilder(
                              bloc: bloc,
                              builder: (context, state) {
                                return LoadingPrimaryButton(
                                    onPressed: () {
                                      if (_formKey.currentState.validate())
                                        bloc.dispatch(RestoreFromKeysWallet(
                                            name: _nameController.text,
                                            address: _addressController.text,
                                            viewKey: _viewKeyController.text,
                                            spendKey: _spendKeyController.text,
                                            restoreHeight: int.parse(
                                                _restoreHeightController
                                                    .text)));
                                    },
                                    text: 'Recover');
                              },
                            )))
                  ],
                ),
              )),
        ));
  }
}
