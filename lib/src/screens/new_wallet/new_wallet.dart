import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';

class NewWallet extends StatelessWidget{
  static const _aspectRatioImage = 1.54;
  final _image = Image.asset('assets/images/bitmap.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          Navigator.pop(context);
        }),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('New wallet', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0
      ),
      body: GestureDetector(
        onTap: (){
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Column(children: <Widget>[
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
        ],),
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
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Palette.lightBlue),
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
                      if (value.isEmpty) return 'Please enter a wallet name';
                      return null;
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
                    if (_formKey.currentState.validate()) Navigator.pop(context);
                  },
                  text: 'Continue',
                )
              ),
            )
          ],
        )
      ),
    );
  }

}