import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';

class AddAccount extends StatefulWidget{

  @override
  createState() => AddAccountState();

}

class AddAccountState extends State<AddAccount>{
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  static final backArrowImage = Image.asset('assets/images/back_arrow.png');

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){ Navigator.pop(context, null); },
            child: backArrowImage
          ),
        ),
        middle: Text('Account', style: TextStyle(fontSize: 16.0),),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Palette.lightBlue),
                      hintText: 'Account',
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
                    controller: _textController,
                    validator: (value){
                      String p = '[^ ]';
                      RegExp regExp = new RegExp(p);
                      if (regExp.hasMatch(value)) return null;
                      else return 'Please enter a name of account';
                    },
                  ),
                )
              ),
              PrimaryButton(
                onPressed: (){
                  if (_formKey.currentState.validate()){
                    Navigator.pop(context, _textController.text);
                  }
                },
                text: 'Add'
              )
            ],
          ),
        ),
      )
    );

  }
}