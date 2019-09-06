import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/routes.dart';

class NewWallet extends StatelessWidget{
  static const _aspectRatioImage = 1.54;
  static final _image = Image.asset('assets/images/bitmap.png');
  static final backArrowImage = Image.asset('assets/images/back_arrow.png');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
              onPressed: (){Navigator.pop(context);},
              child: backArrowImage
          ),
        ),
        middle: Text('New Wallet', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          child: Column(children: <Widget>[
            Spacer(
              flex: 1,
            ),
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
            Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 8,
              child: WalletNameForm(),
            )
          ],),
        )
      )
    );
  }

}

class WalletNameForm extends StatefulWidget{

  @override
  createState() => _WalletNameFormState();

}

class _WalletNameFormState extends State<WalletNameForm>{
  final _formKey = GlobalKey<FormState>();
  bool _isWalletCreating = false;

  void createWallet() {
    setState(() {
      _isWalletCreating = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    style: TextStyle(fontSize: 24.0),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Palette.lightBlueWithOpacity),
                        hintText: 'Wallet name',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Palette.lightGrey,
                                width: 2.0
                            )
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Palette.lightGrey,
                                width: 2.0
                            )
                        )
                    ),
                    validator: (value){
                      String p = '[^ ]';
                      RegExp regExp = new RegExp(p);
                      if (regExp.hasMatch(value)) return null;
                      else return 'Please enter a wallet name';
                    },
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: PrimaryButton(
                    onPressed: (){
                      if (_formKey.currentState.validate()) Navigator.pushNamed(context, seedAlertRoute);
                    },
                    text: 'Create New'
                )

                /*LoadingPrimaryButton(
                  onPressed: (){
                    if (_formKey.currentState.validate()) createWallet();
                  },
                  text: 'Continue',
                  isLoading: _isWalletCreating,
                )*/

              ),
            )
          ],
        )
      ),
    );
  }

}