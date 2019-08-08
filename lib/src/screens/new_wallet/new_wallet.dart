import 'package:flutter/material.dart';

class NewWallet extends StatelessWidget{

  // New wallet image

  var _image = new Image(image: AssetImage('assets/images/bitmap.png'));

  // Aspects of image

  double _aspectRatioImage = 375.0/243.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          FocusScope.of(context).requestFocus(new FocusNode());
          Navigator.pop(context);
        }),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('New wallet', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0
      ),
      body: Column(children: <Widget>[
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
    );
  }

}

class WalletNameForm extends StatefulWidget{

  @override
  createState() => _WalletNameFormState();

}

class _WalletNameFormState extends State<WalletNameForm>{

  final _formKey = GlobalKey<FormState>();

  // Insets and radius

  final double _insets = 30.0;
  final double _insetsTop = 10.0;
  final double _radius = 10.0;

  // Colors of widgets

  final Color _hintTextColor = Color.fromARGB(255, 126, 147, 177);
  final Color _buttonColor = Colors.purple[50];
  final Color _buttonBorderColor = Colors.deepPurple[100];

  // Font size

  final double _buttonTextFontSize = 18.0;

  // Height of button

  final double _buttonHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: _insets,
        top: _insetsTop,
        right: _insets,
        bottom: _insets
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: _hintTextColor),
                hintText: 'Wallet name'
              ),
              validator: (value){
                if (value.isEmpty) return 'Please enter a wallet name';
              },
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: ButtonTheme(
                  minWidth: double.infinity,
                  height: _buttonHeight,
                  child: FlatButton(
                    onPressed: (){
                      if (_formKey.currentState.validate()) Navigator.pop(context);
                    },
                    color: _buttonColor,
                    shape: RoundedRectangleBorder(side: BorderSide(color: _buttonBorderColor), borderRadius: BorderRadius.circular(_radius)),
                    child: Text('Continue',
                      style: TextStyle(
                          fontSize: _buttonTextFontSize,
                          fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

}