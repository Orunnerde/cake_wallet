import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/bloc/wallets_manager/wallets_manager.dart';
import 'package:cake_wallet/src/bloc/wallets_manager/wallets_manager_state.dart';
import 'package:cake_wallet/src/wallets_service.dart';

class NewWallet extends StatelessWidget {
  static const _aspectRatioImage = 1.54;
  final _image = Image.asset('assets/images/bitmap.png');

  final WalletsService walletsService;
  final SharedPreferences sharedPreferences;

  NewWallet({this.walletsService, this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        appBar: CupertinoNavigationBar(
            middle: Text('New wallet'),
            backgroundColor: Colors.white,
            border: null),
        body: BlocProvider(
            builder: (context) => WalletsManagerBloc(
                walletsService: walletsService,
                sharedPreferences: sharedPreferences),
            child: GestureDetector(
              onTap: () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: _aspectRatioImage,
                    child: Container(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: _image,
                      ),
                    ),
                  ),
                  Expanded(
                    child: WalletNameForm(),
                  )
                ],
              ),
            )));
  }
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
    final bloc = BlocProvider.of<WalletsManagerBloc>(context);

    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: BlocListener(
            bloc: bloc,
            listener: (context, state) {
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
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: nameController,
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
                              if (value.isEmpty)
                                return 'Please enter a wallet name';
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                    Expanded(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: BlocBuilder(
                              bloc: bloc,
                              builder: (context, state) {
                                return LoadingPrimaryButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate())
                                      bloc.dispatch(CreateWallet(
                                          name: nameController.text));
                                  },
                                  text: 'Continue',
                                  isLoading: state is CreatingWallet,
                                );
                              },
                            )))
                  ],
                ))));
  }
}
