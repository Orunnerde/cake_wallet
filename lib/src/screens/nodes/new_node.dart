import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';

class NewNode extends StatefulWidget{

  @override
  createState() => NewNodeState();

}

class NewNodeState extends State<NewNode>{

  final _formKey = GlobalKey<FormState>();
  final _backArrowImage = Image.asset('assets/images/back_arrow.png');
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

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){

              Navigator.pop(context, _isSaved? _nodeAddress : null);

            },
            child: _backArrowImage
          ),
        ),
        middle: Text('New Node', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,
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
                                  hintStyle: TextStyle(color: Palette.wildDarkBlue),
                                  hintText: 'Node Address',
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
                                controller: _nodeAddressController,
                                validator: (value){
                                  String p = '[^ ]';
                                  RegExp regExp = new RegExp(p);
                                  if (regExp.hasMatch(value)) return null;
                                  else return 'Please enter a node address';
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
                                  signed: false,
                                  decimal: false
                                ),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Palette.wildDarkBlue),
                                  hintText: 'Node port',
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
                                controller: _nodePortController,
                                validator: (value){
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
                                  hintStyle: TextStyle(color: Palette.wildDarkBlue),
                                  hintText: 'Login',
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
                                controller: _loginController,
                                validator: (value){
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
                                  hintStyle: TextStyle(color: Palette.wildDarkBlue),
                                  hintText: 'Password',
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
                                controller: _passwordController,
                                validator: (value){
                                  return null;
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(right: 8.0),
                        child: PrimaryButton(
                          onPressed: (){
                            _isSaved = false;
                            _nodeAddressController.text = '';
                            _nodePortController.text = '';
                            _loginController.text = '';
                            _passwordController.text = '';
                          },
                          text: 'Reset',
                          color: Palette.indigo,
                          borderColor: Palette.deepIndigo,
                        ),
                      )
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0),
                        child: PrimaryButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()){

                              _isSaved = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  Future.delayed(const Duration(milliseconds: 500), () {
                                    Navigator.pop(context, true);
                                  });
                                  return AlertDialog(
                                    title: Text('Saving',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: CupertinoActivityIndicator(animating: true)
                                  );
                                }
                              );

                              if (_isSaved) {
                                _nodeAddress = _nodeAddressController.text;
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Saved',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text('OK')
                                        )
                                      ],
                                    );
                                  }
                                );
                              }
                            }
                          },
                          text: 'Save'
                        ),
                      )
                    ),
                  ],
                ),
              )
            ],
          )
        )
      ),
    );

  }

}